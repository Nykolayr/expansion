import 'package:equatable/equatable.dart';

import 'package:expansion/domain/enums/game_difficulty.dart';

class BeginState extends Equatable {
  const BeginState({
    this.difficulty = GameDifficulty.average,
    this.isSaving = false,
  });

  final GameDifficulty difficulty;
  final bool isSaving;

  BeginState copyWith({
    GameDifficulty? difficulty,
    bool? isSaving,
  }) {
    return BeginState(
      difficulty: difficulty ?? this.difficulty,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [difficulty, isSaving];
}
