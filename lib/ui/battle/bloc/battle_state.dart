part of 'battle_bloc.dart';

class BattleState {
  final List<BaseObject> bases;
  final List<EntitesObject> ships;
  final int score;
  final bool isWin;
  final bool isLost;
  final bool isPause;

  BattleState({
    required this.bases,
    required this.ships,
    required this.isWin,
    required this.isLost,
    required this.isPause,
    required this.score,
  });
  factory BattleState.initial() => BattleState(
        bases: [],
        ships: [],
        isLost: false,
        isWin: false,
        isPause: false,
        score: 0,
      );
  BattleState copyWith({
    List<BaseObject>? bases,
    List<EntitesObject>? ships,
    int? score,
    bool? isWin,
    bool? isLost,
    bool? isPause,
  }) =>
      BattleState(
        bases: bases ?? this.bases,
        ships: ships ?? this.ships,
        isLost: isLost ?? this.isLost,
        isWin: isWin ?? this.isWin,
        isPause: isPause ?? this.isPause,
        score: score ?? this.score,
      );
}
