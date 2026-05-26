import 'package:equatable/equatable.dart';

import 'package:expansion/domain/enums/game_difficulty.dart';
import 'package:expansion/domain/enums/univer_kind.dart';

class BeginState extends Equatable {
  const BeginState({
    this.difficulty = GameDifficulty.average,
    this.univerKind = UniverKind.classic,
    this.isSaving = false,
  });

  final GameDifficulty difficulty;
  final UniverKind univerKind;
  final bool isSaving;

  BeginState copyWith({
    GameDifficulty? difficulty,
    UniverKind? univerKind,
    bool? isSaving,
  }) {
    return BeginState(
      difficulty: difficulty ?? this.difficulty,
      univerKind: univerKind ?? this.univerKind,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [difficulty, univerKind, isSaving];
}
