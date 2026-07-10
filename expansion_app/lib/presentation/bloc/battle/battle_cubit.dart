import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/game_core/battle/battle_session_factory.dart';
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
import 'package:expansion/game_core/battle/battle_difficulty_config.dart';
import 'package:expansion/game_core/battle/battle_engine.dart';
import 'package:expansion/game_core/battle/battle_pacing.dart';
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
  BattleEngine? _engine;

  final BattleTickLoop _tickLoop = BattleTickLoop();
  GameDifficulty _difficulty = GameDifficulty.average;
  int _enemyTickCounter = 0;
  Random? _battleRng;
  MetaBattleBonuses _bonuses = MetaBattleBonuses.none;
  DateTime? _battleStartedAt;
  bool _firstBattleEnemyGrace = false;
  bool _asteroidTutorialSeen = false;

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

      emit(
        state.copyWith(
          status: BattleStatus.playing,
          snapshot: engine.snapshot(),
          briefingRu: scene?.battleRu ?? '',
          briefingEn: scene?.battleEn ?? '',
          clearSelection: true,
          isPaused: false,
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
    emit(state.copyWith(selectedBaseId: baseId));
  }

  void clearBaseSelection() {
    emit(state.copyWith(clearSelection: true));
  }

  /// Свайп со своей базы на клетку с базой-целью.
  bool sendFleetDrag(int fromX, int fromY, int toX, int toY) {
    final engine = _engine;
    if (engine == null || !state.canInteract) return false;

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
      emit(state.copyWith(clearBlocked: true));
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

  int tacticalCostFor(int baseId, TacticalUpgradeType type) {
    final engine = _engine;
    final base = engine?.snapshot().baseById(baseId);
    if (engine == null || base == null) return 0;
    return engine.tacticalUpgradeCost(base, type);
  }

  TacticalUpgradeResult? purchaseTacticalUpgrade(TacticalUpgradeType type) {
    final engine = _engine;
    final baseId = state.selectedBaseId;
    if (engine == null || baseId == null || !state.canInteract) return null;

    final result = engine.applyTacticalUpgrade(baseId, type);
    if (result == TacticalUpgradeResult.success) {
      _emitPlaying();
    }
    return result;
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

  Future<int> completeAfterVictory() async {
    final guest = await _guest.load();
    final nextMission = (state.sceneId + 1).clamp(1, 40);
    final reward = 40 + state.sceneId * 15;
    await _guest.save(
      guest.copyWith(
        mapClassic: nextMission > guest.mapClassic
            ? nextMission
            : guest.mapClassic,
        firstBattleCompleted: true,
        scoreClassic: guest.scoreClassic + reward,
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
    if (engine == null || rng == null || !state.isPlaying || state.isPaused) {
      return;
    }
    if (state.showMeteoriteTutorial) return;

    final asteroidsBefore = state.snapshot?.asteroids.length ?? 0;
    engine.tick();
    final asteroidsAfter = engine.snapshot().asteroids.length;

    if (!_asteroidTutorialSeen &&
        asteroidsBefore == 0 &&
        asteroidsAfter > 0) {
      _emitPlaying();
      emit(state.copyWith(showMeteoriteTutorial: true));
      AppLog.trace('asteroid tutorial pause scene=${state.sceneId}', tag: 'Battle');
      return;
    }

    _enemyTickCounter++;

    final config = BattleDifficultyConfig.forDifficulty(_difficulty);
    final baseTicks = config.ticksPerEnemyTurn / _bonuses.enemyTurnDivider;
    final jitter = (baseTicks * (0.85 + rng.nextDouble() * 0.3)).round();

    final enemyGrace = _firstBattleEnemyGrace &&
        _battleStartedAt != null &&
        DateTime.now().difference(_battleStartedAt!) <
            BattlePacing.firstBattleEnemyGrace;

    if (!enemyGrace && _enemyTickCounter >= jitter) {
      _enemyTickCounter = 0;
      _runEnemyTurn(engine, rng);
    }

    _emitPlaying();
    _checkOutcome();
  }

  void _runEnemyTurn(BattleEngine engine, Random rng) {
    final personality = EnemyPersonality.forDifficulty(_difficulty);
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
