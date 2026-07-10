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
    this.enemyPower = 0,
    this.difficulty = GameDifficulty.average,
    this.univer = UniverKind.classic,
  });

  final ProgressStatus status;
  final int currentMission;
  final int completedMissions;
  final int score;
  final int enemyPower;
  final GameDifficulty difficulty;
  final UniverKind univer;

  ProgressState copyWith({
    ProgressStatus? status,
    int? currentMission,
    int? completedMissions,
    int? score,
    int? enemyPower,
    GameDifficulty? difficulty,
    UniverKind? univer,
  }) {
    return ProgressState(
      status: status ?? this.status,
      currentMission: currentMission ?? this.currentMission,
      completedMissions: completedMissions ?? this.completedMissions,
      score: score ?? this.score,
      enemyPower: enemyPower ?? this.enemyPower,
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
        enemyPower,
        difficulty,
        univer,
      ];
}
