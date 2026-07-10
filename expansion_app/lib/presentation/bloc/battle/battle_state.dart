import 'package:equatable/equatable.dart';

import 'package:expansion/domain/entities/battle_snapshot.dart';
import 'package:expansion/game_core/battle/battle_engine.dart';

enum BattleStatus { initial, loading, playing, ended, failure }

enum BattleErrorKey { layoutNotFound }

enum MissionTutorialStep {
  none,
  drag,
  captureHint,
  upgradeOverlay,
  goalOverlay,
}

class BattleState extends Equatable {
  const BattleState({
    this.status = BattleStatus.initial,
    this.sceneId = 1,
    this.snapshot,
    this.selectedBaseId,
    this.outcome,
    this.briefingRu = '',
    this.briefingEn = '',
    this.errorKey,
    this.errorMessage,
    this.blockedCellX,
    this.blockedCellY,
    this.showMeteoriteTutorial = false,
    this.missionTutorialStep = MissionTutorialStep.none,
    this.tutorialTargetBaseId,
    this.isPaused = false,
  });

  final BattleStatus status;
  final int sceneId;
  final BattleSnapshot? snapshot;
  final int? selectedBaseId;
  final BattleOutcome? outcome;
  final String briefingRu;
  final String briefingEn;
  final BattleErrorKey? errorKey;
  final String? errorMessage;

  /// Крестик на базе, блокирующей линию отправки.
  final int? blockedCellX;
  final int? blockedCellY;

  /// Пауза при первом астероиде.
  final bool showMeteoriteTutorial;

  /// Пошаговый туториал миссии 1.
  final MissionTutorialStep missionTutorialStep;

  /// Цель свайпа (для подсказки «захват»).
  final int? tutorialTargetBaseId;

  /// Меню паузы — тики остановлены.
  final bool isPaused;

  bool get isPlaying => status == BattleStatus.playing;

  bool get missionTutorialActive =>
      missionTutorialStep != MissionTutorialStep.none;

  /// Враг не ходит, пока идёт туториал миссии 1.
  bool get tutorialPausesEnemy => missionTutorialActive;

  /// Новые астероиды не спавнятся во время туториала.
  bool get tutorialPausesAsteroids => missionTutorialActive;

  bool get tutorialPausesTicks => showMeteoriteTutorial;

  bool get canInteract =>
      isPlaying && !isPaused && !showMeteoriteTutorial;

  /// Свайп флота — только когда панель статуса базы закрыта.
  bool get canSendFleet => canInteract && selectedBaseId == null;

  /// Тики боя — пауза при открытой панели статуса базы.
  bool get ticksRunning => canInteract && selectedBaseId == null;

  BattleState copyWith({
    BattleStatus? status,
    int? sceneId,
    BattleSnapshot? snapshot,
    int? selectedBaseId,
    bool clearSelection = false,
    BattleOutcome? outcome,
    String? briefingRu,
    String? briefingEn,
    BattleErrorKey? errorKey,
    bool clearErrorKey = false,
    String? errorMessage,
    int? blockedCellX,
    int? blockedCellY,
    bool clearBlocked = false,
    bool? showMeteoriteTutorial,
    MissionTutorialStep? missionTutorialStep,
    int? tutorialTargetBaseId,
    bool clearTutorialTarget = false,
    bool? isPaused,
  }) {
    return BattleState(
      status: status ?? this.status,
      sceneId: sceneId ?? this.sceneId,
      snapshot: snapshot ?? this.snapshot,
      selectedBaseId:
          clearSelection ? null : selectedBaseId ?? this.selectedBaseId,
      outcome: outcome ?? this.outcome,
      briefingRu: briefingRu ?? this.briefingRu,
      briefingEn: briefingEn ?? this.briefingEn,
      errorKey: clearErrorKey ? null : errorKey ?? this.errorKey,
      errorMessage: errorMessage,
      blockedCellX: clearBlocked ? null : blockedCellX ?? this.blockedCellX,
      blockedCellY: clearBlocked ? null : blockedCellY ?? this.blockedCellY,
      showMeteoriteTutorial:
          showMeteoriteTutorial ?? this.showMeteoriteTutorial,
      missionTutorialStep: missionTutorialStep ?? this.missionTutorialStep,
      tutorialTargetBaseId:
          clearTutorialTarget ? null : tutorialTargetBaseId ?? this.tutorialTargetBaseId,
      isPaused: isPaused ?? this.isPaused,
    );
  }

  @override
  List<Object?> get props => [
        status,
        sceneId,
        snapshot,
        selectedBaseId,
        outcome,
        briefingRu,
        briefingEn,
        errorKey,
        errorMessage,
        blockedCellX,
        blockedCellY,
        showMeteoriteTutorial,
        missionTutorialStep,
        tutorialTargetBaseId,
        isPaused,
      ];
}
