import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/data/repositories/battle_session_loader.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/domain/enums/game_difficulty.dart';
import 'package:expansion/domain/repositories/campaign_repository.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/game_core/ai/battle_intent.dart';
import 'package:expansion/game_core/ai/enemy_commander.dart';
import 'package:expansion/game_core/ai/enemy_personality.dart';
import 'package:expansion/game_core/battle/battle_difficulty_config.dart';
import 'package:expansion/game_core/battle/battle_engine.dart';
import 'package:expansion/presentation/bloc/battle/battle_state.dart';

class BattleCubit extends Cubit<BattleState> {
  BattleCubit(
    this._loader,
    this._campaign,
    this._guest,
  ) : super(const BattleState());

  final BattleSessionLoader _loader;
  final CampaignRepository _campaign;
  final GuestProfileRepository _guest;

  final EnemyCommander _enemyCommander = const EnemyCommander();
  BattleEngine? _engine;
  Timer? _tickTimer;
  GameDifficulty _difficulty = GameDifficulty.average;
  int _enemyTickCounter = 0;
  Random? _battleRng;

  Future<void> loadMission(int sceneId) async {
    await _stopTimer();
    _engine = null;
    emit(
      state.copyWith(
        status: BattleStatus.loading,
        sceneId: sceneId,
        clearSelection: true,
        outcome: null,
      ),
    );
    AppLog.trace('battle load sceneId=$sceneId', tag: 'Battle');

    try {
      final guest = await _guest.load();
      _difficulty = guest.difficulty;
      _battleRng = Random(sceneId * 9973 + guest.mapClassic);

      final engine = await _loader.loadEngine(sceneId);
      if (engine == null) {
        emit(
          state.copyWith(
            status: BattleStatus.failure,
            errorMessage: 'Layout not found',
          ),
        );
        return;
      }

      final scenes = await _campaign.getCampaignScenes();
      final scene = scenes.where((s) => s.id == sceneId).firstOrNull;
      _engine = engine;

      emit(
        state.copyWith(
          status: BattleStatus.playing,
          snapshot: engine.snapshot(),
          briefingRu: scene?.battleRu ?? '',
          briefingEn: scene?.battleEn ?? '',
          clearSelection: true,
        ),
      );

      _enemyTickCounter = 0;
      _tickTimer = Timer.periodic(
        const Duration(milliseconds: 50),
        (_) => _onTick(),
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
    if (engine == null || !state.isPlaying) return;
    final base = engine.snapshot().baseById(baseId);
    if (base == null || base.side != BattleSide.player) return;
    emit(state.copyWith(selectedBaseId: baseId));
  }

  void tapCell(int x, int y) {
    final engine = _engine;
    if (engine == null || !state.isPlaying) return;
    if (state.snapshot!.fleets.isNotEmpty) return;

    final tapped = engine.snapshot().baseAt(x, y);
    if (tapped != null && tapped.side == BattleSide.player) {
      selectBase(tapped.id);
      return;
    }

    final fromId = state.selectedBaseId;
    if (fromId == null || tapped == null) return;
    final target = tapped;

    final sent = engine.sendFleet(
      fromId,
      target.id,
      requiredSide: BattleSide.player,
    );
    if (sent) {
      _emitPlaying();
      _checkOutcome();
    }
    emit(state.copyWith(clearSelection: true));
  }

  Future<void> completeAfterVictory() async {
    final guest = await _guest.load();
    final nextMission = state.sceneId + 1;
    await _guest.save(
      guest.copyWith(
        mapClassic: nextMission.clamp(1, 40),
        firstBattleCompleted: true,
      ),
    );
  }

  Future<void> disposeBattle() async {
    await _stopTimer();
    _engine = null;
    emit(const BattleState());
  }

  Future<void> _stopTimer() async {
    _tickTimer?.cancel();
    _tickTimer = null;
  }

  void _onTick() {
    final engine = _engine;
    final rng = _battleRng;
    if (engine == null || rng == null || !state.isPlaying) return;

    engine.tick();
    _enemyTickCounter++;

    final config = BattleDifficultyConfig.forDifficulty(_difficulty);
    final jitter = (config.ticksPerEnemyTurn * (0.85 + rng.nextDouble() * 0.3))
        .round();

    if (_enemyTickCounter >= jitter) {
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
        case SendFleetIntent(:final fromBaseId, :final toBaseId):
          engine.sendFleet(
            fromBaseId,
            toBaseId,
            requiredSide: BattleSide.enemy,
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
    _stopTimer();
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

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
