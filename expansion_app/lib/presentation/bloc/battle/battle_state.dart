import 'package:equatable/equatable.dart';

import 'package:expansion/domain/entities/battle_snapshot.dart';
import 'package:expansion/domain/enums/mission_feature_intro.dart';
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
    this.showDebrisTutorial = false,
    this.missionTutorialStep = MissionTutorialStep.none,
    this.tutorialTargetBaseId,
    this.featureIntro,
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

  /// Пауза при первых обломках.
  final bool showDebrisTutorial;

  /// Пошаговый туториал миссии 1.
  final MissionTutorialStep missionTutorialStep;

  /// Цель свайпа (для подсказки «захват»).
  final int? tutorialTargetBaseId;

  /// Интро новой механики (средняя/большая база…) — пауза в начале миссии.
  final MissionFeatureIntro? featureIntro;

  /// Меню паузы — тики остановлены.
  final bool isPaused;

  bool get isPlaying => status == BattleStatus.playing;

  bool get missionTutorialActive =>
      missionTutorialStep != MissionTutorialStep.none;

  bool get featureIntroActive => featureIntro != null;

  /// Враг не ходит, пока идёт туториал миссии 1 или интро механики.
  bool get tutorialPausesEnemy =>
      missionTutorialActive || featureIntroActive;

  /// Новые астероиды не спавнятся во время туториала / интро.
  bool get tutorialPausesAsteroids =>
      missionTutorialActive || featureIntroActive;

  /// Тики боя: пауза на карточках туториала, интро механики и астероиде.
  /// На шагах drag/captureHint тики идут — иначе флот «застревает» в пути.
  bool get tutorialPausesTicks =>
      showMeteoriteTutorial ||
      showDebrisTutorial ||
      featureIntroActive ||
      missionTutorialStep == MissionTutorialStep.upgradeOverlay ||
      missionTutorialStep == MissionTutorialStep.goalOverlay;

  bool get canInteract =>
      isPlaying &&
      !isPaused &&
      !showMeteoriteTutorial &&
      !showDebrisTutorial &&
      !featureIntroActive;

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
    bool? showDebrisTutorial,
    MissionTutorialStep? missionTutorialStep,
    int? tutorialTargetBaseId,
    bool clearTutorialTarget = false,
    MissionFeatureIntro? featureIntro,
    bool clearFeatureIntro = false,
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
      showDebrisTutorial: showDebrisTutorial ?? this.showDebrisTutorial,
      missionTutorialStep: missionTutorialStep ?? this.missionTutorialStep,
      tutorialTargetBaseId:
          clearTutorialTarget ? null : tutorialTargetBaseId ?? this.tutorialTargetBaseId,
      featureIntro:
          clearFeatureIntro ? null : featureIntro ?? this.featureIntro,
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
        showDebrisTutorial,
        missionTutorialStep,
        tutorialTargetBaseId,
        featureIntro,
        isPaused,
      ];
}
