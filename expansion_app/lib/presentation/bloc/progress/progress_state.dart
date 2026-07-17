import 'package:equatable/equatable.dart';

import 'package:expansion/domain/enums/game_difficulty.dart';
import 'package:expansion/domain/enums/univer_kind.dart';

enum ProgressStatus { initial, loading, ready, failure }

class ProgressState extends Equatable {
  const ProgressState({
    this.status = ProgressStatus.initial,
    this.currentMission = 1,
    this.completedMissions = 0,
    this.score = 0,
    this.nebulaIndex = 0,
    this.enemyTurnDivider = 1,
    this.difficulty = GameDifficulty.average,
    this.univer = UniverKind.classic,
  });

  final ProgressStatus status;
  final int currentMission;
  final int completedMissions;
  final int score;
  final int nebulaIndex;
  final double enemyTurnDivider;
  final GameDifficulty difficulty;
  final UniverKind univer;

  ProgressState copyWith({
    ProgressStatus? status,
    int? currentMission,
    int? completedMissions,
    int? score,
    int? nebulaIndex,
    double? enemyTurnDivider,
    GameDifficulty? difficulty,
    UniverKind? univer,
  }) {
    return ProgressState(
      status: status ?? this.status,
      currentMission: currentMission ?? this.currentMission,
      completedMissions: completedMissions ?? this.completedMissions,
      score: score ?? this.score,
      nebulaIndex: nebulaIndex ?? this.nebulaIndex,
      enemyTurnDivider: enemyTurnDivider ?? this.enemyTurnDivider,
      difficulty: difficulty ?? this.difficulty,
      univer: univer ?? this.univer,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentMission,
        completedMissions,
        score,
        nebulaIndex,
        enemyTurnDivider,
        difficulty,
        univer,
      ];
}
