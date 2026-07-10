import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/core/audio/game_audio_service.dart';
import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/core/ui/game_haptic.dart';
import 'package:expansion/game_core/battle/battle_session_factory.dart';
import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/entities/campaign_scene.dart';
import 'package:expansion/domain/entities/meta_battle_bonuses.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/domain/enums/game_difficulty.dart';
import 'package:expansion/domain/enums/tactical_upgrade_type.dart';
import 'package:expansion/domain/repositories/campaign_repository.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/game_core/ai/battle_intent.dart';
import 'package:expansion/game_core/ai/enemy_commander.dart';
import 'package:expansion/game_core/ai/enemy_personality.dart';
import 'package:expansion/game_core/ai/enemy_upgrade_advisor.dart';
import 'package:expansion/game_core/battle/battle_difficulty_config.dart';
import 'package:expansion/game_core/battle/battle_engine.dart';
import 'package:expansion/game_core/battle/battle_pacing.dart';
import 'package:expansion/game_core/battle/battle_victory_reward.dart';
import 'package:expansion/game_core/battle/tactical_upgrade_result.dart';
import 'package:expansion/game_core/game_loop/battle_tick_loop.dart';
import 'package:expansion/presentation/bloc/battle/battle_state.dart';

class BattleCubit extends Cubit<BattleState> {
  BattleCubit(
    this._sessionFactory,
    this._campaign,
    this._guest,
  ) : super(const BattleState());

  final BattleSessionFactory _sessionFactory;
  final CampaignRepository _campaign;
  final GuestProfileRepository _guest;

  final EnemyCommander _enemyCommander = const EnemyCommander();
  final EnemyUpgradeAdvisor _enemyUpgradeAdvisor = const EnemyUpgradeAdvisor();
  BattleEngine? _engine;

  final BattleTickLoop _tickLoop = BattleTickLoop();
  GameDifficulty _difficulty = GameDifficulty.average;
  int _enemyTickCounter = 0;
  Random? _battleRng;
  MetaBattleBonuses _bonuses = MetaBattleBonuses.none;
  DateTime? _battleStartedAt;
  bool _firstBattleEnemyGrace = false;
  bool _asteroidTutorialSeen = false;
  int _initialPlayerBaseCount = 0;
  DateTime? _missionTutorialEndedAt;

  Future<void> loadMission(int sceneId) async {
    await _stopLoop();
    _engine = null;
    emit(
      state.copyWith(
        status: BattleStatus.loading,
        sceneId: sceneId,
        clearSelection: true,
        outcome: null,
        isPaused: false,
        clearErrorKey: true,
      ),
    );
    AppLog.trace('battle load sceneId=$sceneId', tag: 'Battle');

    try {
      final guest = await _guest.load();
      _difficulty = guest.difficulty;
      _battleRng = Random(sceneId * 9973 + guest.mapClassic);

      _bonuses = MetaBattleBonuses.fromProgress(guest.meta);
      final engine = await _sessionFactory.createEngine(
        sceneId,
        bonuses: _bonuses,
        difficulty: guest.difficulty,
      );
      if (engine == null) {
        emit(
          state.copyWith(
            status: BattleStatus.failure,
            errorKey: BattleErrorKey.layoutNotFound,
          ),
        );
        return;
      }

      final scenes = await _campaign.getCampaignScenes();
      CampaignScene? scene;
      for (final s in scenes) {
        if (s.id == sceneId) {
          scene = s;
          break;
        }
      }
      _engine = engine..bindRandom(_battleRng!);
      _initialPlayerBaseCount = engine.snapshot().playerBases.length;
      _missionTutorialEndedAt = null;

      final tutorialStep = sceneId == 1 && !guest.mission1TutorialCompleted
          ? MissionTutorialStep.drag
          : MissionTutorialStep.none;

      if (sceneId == 1 && tutorialStep != MissionTutorialStep.none) {
        engine.setTutorialCaptureBonusBaseId(
          engine.mission1TutorialCaptureBaseId,
        );
      }

      emit(
        state.copyWith(
          status: BattleStatus.playing,
          snapshot: engine.snapshot(),
          briefingRu: scene?.battleRu ?? '',
          briefingEn: scene?.battleEn ?? '',
          clearSelection: true,
          isPaused: false,
          missionTutorialStep: tutorialStep,
        ),
      );

      _enemyTickCounter = 0;
      _battleStartedAt = DateTime.now();
      _firstBattleEnemyGrace = !guest.firstBattleCompleted;
      _asteroidTutorialSeen = guest.asteroidTutorialSeen;
      await _tickLoop.start(_onTick);
      AppLog.trace(
        'battle tick loop started grace=$_firstBattleEnemyGrace',
        tag: 'Battle',
      );
    } catch (e, stackTrace) {
      AppLog.error('battle load failed', error: e, stackTrace: stackTrace);
      emit(
        state.copyWith(
          status: BattleStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void selectBase(int baseId) {
    final engine = _engine;
    if (engine == null || !state.canInteract) return;
    final base = engine.snapshot().baseById(baseId);
    if (base == null || base.side != BattleSide.player) return;

    if (state.missionTutorialStep == MissionTutorialStep.captureHint) {
      final snap = engine.snapshot();
      if (snap.playerBases.length <= _initialPlayerBaseCount) return;
      emit(
        state.copyWith(
          selectedBaseId: baseId,
          missionTutorialStep: MissionTutorialStep.upgradeOverlay,
        ),
      );
      return;
    }

    if (!_canOpenBaseStatus(base)) return;

    emit(state.copyWith(selectedBaseId: baseId));
  }

  void clearBaseSelection() {
    emit(state.copyWith(clearSelection: true));
  }

  /// Свайп со своей базы на клетку с базой-целью.
  bool sendFleetDrag(int fromX, int fromY, int toX, int toY) {
    final engine = _engine;
    if (engine == null || !state.canSendFleet) return false;

    final from = engine.snapshot().baseAt(fromX, fromY);
    final to = engine.snapshot().baseAt(toX, toY);
    if (from == null || to == null) return false;
    if (from.side != BattleSide.player) return false;
    if (from.id == to.id) return false;

    final sent = engine.sendFleet(
      from.id,
      to.id,
      requiredSide: BattleSide.player,
    );
    if (sent) {
      sl<GameAudioService>().playFleetSend();
      GameHaptic.light();
      if (state.sceneId == 1 && state.missionTutorialActive) {
        engine.setTutorialCaptureBonusBaseId(to.id);
      }
      final toBase = engine.snapshot().baseAt(toX, toY);
      emit(
        state.copyWith(
          clearBlocked: true,
          missionTutorialStep:
              state.missionTutorialStep == MissionTutorialStep.drag
                  ? MissionTutorialStep.captureHint
                  : state.missionTutorialStep,
          tutorialTargetBaseId: toBase?.id,
        ),
      );
      _emitPlaying();
      _checkOutcome();
    } else {
      final blocker = engine.lineOfSightBlocker(from.id, to.id);
      emit(
        state.copyWith(
          blockedCellX: blocker?.$1,
          blockedCellY: blocker?.$2,
          clearBlocked: blocker == null,
        ),
      );
    }
    return sent;
  }

  void clearBlockedCell() => emit(state.copyWith(clearBlocked: true));

  void dismissMeteoriteTutorial() {
    emit(state.copyWith(showMeteoriteTutorial: false));
    if (_asteroidTutorialSeen) return;
    _asteroidTutorialSeen = true;
    unawaited(_guest.markAsteroidTutorialSeen());
  }

  Future<void> skipMissionTutorial() async {
    _beginPostTutorialEnemyGrace();
    emit(
      state.copyWith(
        missionTutorialStep: MissionTutorialStep.none,
        clearSelection: true,
        clearTutorialTarget: true,
      ),
    );
    await _guest.markMission1TutorialCompleted();
    AppLog.trace('mission1 tutorial skipped', tag: 'Battle');
  }

  void dismissMissionTutorialUpgrade() {
    if (state.missionTutorialStep != MissionTutorialStep.upgradeOverlay) return;
    emit(
      state.copyWith(
        missionTutorialStep: MissionTutorialStep.goalOverlay,
        clearSelection: true,
        clearTutorialTarget: true,
      ),
    );
  }

  void dismissMissionTutorialGoal() {
    if (state.missionTutorialStep != MissionTutorialStep.goalOverlay) return;
    _beginPostTutorialEnemyGrace();
    emit(
      state.copyWith(
        missionTutorialStep: MissionTutorialStep.none,
        clearTutorialTarget: true,
      ),
    );
    unawaited(_guest.markMission1TutorialCompleted());
  }

  int tacticalCostFor(int baseId, TacticalUpgradeType type) {
    final engine = _engine;
    final base = engine?.snapshot().baseById(baseId);
    if (engine == null || base == null) return 0;
    return engine.tacticalUpgradeCost(base, type);
  }

  TacticalUpgradeResult? purchaseTacticalUpgrade(TacticalUpgradeType type) {
    final engine = _engine;
    final baseId = state.selectedBaseId;
    if (engine == null ||
        baseId == null ||
        !state.isPlaying ||
        state.isPaused) {
      return null;
    }

    final result = engine.applyTacticalUpgrade(baseId, type);
    if (result == TacticalUpgradeResult.success) {
      final tutorialStep = state.missionTutorialStep;
      final nextTutorialStep =
          tutorialStep == MissionTutorialStep.upgradeOverlay
              ? MissionTutorialStep.goalOverlay
              : tutorialStep;
      emit(
        state.copyWith(
          snapshot: engine.snapshot(),
          clearSelection: true,
          missionTutorialStep: nextTutorialStep,
          clearTutorialTarget:
              tutorialStep == MissionTutorialStep.upgradeOverlay,
        ),
      );
    }
    return result;
  }

  /// Базы с доступным тактическим улучшением (для подсветки и тапа).
  Set<int> upgradablePlayerBaseIds() {
    final engine = _engine;
    final snap = state.snapshot;
    if (engine == null || snap == null) return const {};

    final ids = <int>{};
    for (final base in snap.playerBases) {
      if (_showsUpgradeHint(base)) ids.add(base.id);
    }
    return ids;
  }

  bool _canOpenBaseStatus(BattleBase base) => _showsUpgradeHint(base);

  bool _showsUpgradeHint(BattleBase base) {
    final engine = _engine;
    if (engine == null || base.side != BattleSide.player) return false;

    final step = state.missionTutorialStep;
    if (step == MissionTutorialStep.captureHint ||
        step == MissionTutorialStep.upgradeOverlay) {
      return TacticalUpgradeType.values.any((t) => !base.isTacticalMaxed(t));
    }

    return engine.hasAffordableTacticalUpgrade(base);
  }

  ({String current, String next, int cost, bool maxed})? tacticalPreview(
    TacticalUpgradeType type,
  ) {
    final engine = _engine;
    final baseId = state.selectedBaseId;
    if (engine == null || baseId == null) return null;
    final base = engine.snapshot().baseById(baseId);
    if (base == null) return null;
    return engine.tacticalPreview(base, type);
  }

  Future<BattleVictoryReward> completeAfterVictory() async {
    final guest = await _guest.load();
    final nextMission = (state.sceneId + 1).clamp(1, 40);
    final reward = BattleRewardCalculator.forMission(state.sceneId);
    await _guest.save(
      guest.copyWith(
        mapClassic: nextMission > guest.mapClassic
            ? nextMission
            : guest.mapClassic,
        firstBattleCompleted: true,
        scoreClassic: guest.scoreClassic + reward.total,
        defeatStreakSceneId: 0,
        defeatStreakCount: 0,
        meta: guest.meta.afterVictory(),
      ),
    );
    return reward;
  }

  /// Учитывает поражение; возвращает серию поражений на текущей миссии.
  Future<int> completeAfterDefeat() async {
    return _guest.recordMissionDefeat(state.sceneId);
  }

  Future<void> disposeBattle() async {
    await _stopLoop();
    _engine = null;
    emit(const BattleState());
  }

  Future<void> pauseBattle() async {
    if (!state.isPlaying || state.isPaused) return;
    _tickLoop.pause();
    emit(state.copyWith(isPaused: true, clearSelection: true));
    AppLog.trace('battle paused scene=${state.sceneId}', tag: 'Battle');
  }

  Future<void> resumeBattle() async {
    if (!state.isPaused) return;
    _tickLoop.resume();
    emit(state.copyWith(isPaused: false));
    AppLog.trace('battle resumed scene=${state.sceneId}', tag: 'Battle');
  }

  Future<void> restartMission() async {
    final sceneId = state.sceneId;
    AppLog.trace('battle restart scene=$sceneId', tag: 'Battle');
    await loadMission(sceneId);
  }

  Future<void> leaveBattle() async {
    AppLog.trace('battle leave to main', tag: 'Battle');
    await disposeBattle();
  }

  Future<void> _stopLoop() async {
    await _tickLoop.stop();
  }

  void _onTick() {
    final engine = _engine;
    final rng = _battleRng;
    if (engine == null || rng == null || !state.ticksRunning) {
      return;
    }
    if (state.tutorialPausesTicks) return;

    final asteroidsBefore = state.snapshot?.asteroids.length ?? 0;
    engine.tick(spawnAsteroids: !state.tutorialPausesAsteroids);
    final asteroidsAfter = engine.snapshot().asteroids.length;

    if (!state.missionTutorialActive &&
        !_asteroidTutorialSeen &&
        asteroidsBefore == 0 &&
        asteroidsAfter > 0) {
      _emitPlaying();
      emit(state.copyWith(showMeteoriteTutorial: true));
      AppLog.trace('asteroid tutorial pause scene=${state.sceneId}', tag: 'Battle');
      return;
    }

    final config = BattleDifficultyConfig.forDifficulty(_difficulty);
    final baseTicks = config.ticksPerEnemyTurn / _bonuses.enemyTurnDivider;
    final jitter = (baseTicks * (0.85 + rng.nextDouble() * 0.3)).round();

    if (_isEnemyGraceActive()) {
      _enemyTickCounter = 0;
    } else {
      _enemyTickCounter++;
      if (_enemyTickCounter >= jitter) {
        _enemyTickCounter = 0;
        _runEnemyTurn(engine, rng);
      }
    }

    _emitPlaying();
    _checkOutcome();
  }

  void _runEnemyTurn(BattleEngine engine, Random rng) {
    final personality = EnemyPersonality.forDifficulty(_difficulty);
    final snapshot = engine.snapshot();

    final upgrade = _enemyUpgradeAdvisor.pick(
      engine: engine,
      snapshot: snapshot,
      personality: personality,
      difficulty: _difficulty,
      random: rng,
    );
    if (upgrade != null) {
      final result = engine.applyTacticalUpgrade(
        upgrade.baseId,
        upgrade.type,
      );
      if (result == TacticalUpgradeResult.success) {
        AppLog.trace(
          'enemy upgrade ${upgrade.type.name} base=${upgrade.baseId}',
          tag: 'Battle',
        );
      }
    }

    final intents = _enemyCommander.decide(
      snapshot: engine.snapshot(),
      personality: personality,
      random: rng,
    );

    for (final intent in intents) {
      switch (intent) {
        case SendFleetIntent(
            :final fromBaseId,
            :final toBaseId,
            :final shipCount,
          ):
          engine.sendFleet(
            fromBaseId,
            toBaseId,
            requiredSide: BattleSide.enemy,
            shipCount: shipCount,
          );
        case WaitIntent():
          break;
      }
    }
  }

  void _emitPlaying() {
    final engine = _engine;
    if (engine == null) return;
    emit(state.copyWith(snapshot: engine.snapshot()));
    _syncMissionTutorialCapture();
  }

  void _syncMissionTutorialCapture() {
    if (state.missionTutorialStep != MissionTutorialStep.captureHint) return;
    final snap = state.snapshot;
    if (snap == null) return;
    if (snap.playerBases.length > _initialPlayerBaseCount) {
      emit(state.copyWith(missionTutorialStep: MissionTutorialStep.upgradeOverlay));
    }
  }

  void _beginPostTutorialEnemyGrace() {
    _missionTutorialEndedAt = DateTime.now();
    _enemyTickCounter = 0;
    AppLog.trace(
      'post-tutorial enemy grace ${BattlePacing.postTutorialEnemyGrace.inSeconds}s',
      tag: 'Battle',
    );
  }

  bool _isEnemyGraceActive() {
    if (state.tutorialPausesEnemy) return true;

    if (_missionTutorialEndedAt != null &&
        DateTime.now().difference(_missionTutorialEndedAt!) <
            BattlePacing.postTutorialEnemyGrace) {
      return true;
    }

    if (_firstBattleEnemyGrace &&
        _battleStartedAt != null &&
        DateTime.now().difference(_battleStartedAt!) <
            BattlePacing.firstBattleEnemyGrace) {
      return true;
    }

    return false;
  }

  void _checkOutcome() {
    final result = _engine?.outcome();
    if (result == null) return;
    unawaited(_stopLoop());
    emit(
      state.copyWith(
        status: BattleStatus.ended,
        outcome: result,
        clearSelection: true,
      ),
    );
    AppLog.trace('battle ended $result', tag: 'Battle');
  }

  @override
  Future<void> close() async {
    await disposeBattle();
    return super.close();
  }
}
