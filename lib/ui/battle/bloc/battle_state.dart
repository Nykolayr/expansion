part of 'battle_bloc.dart';

class BattleState {
  final List<Base> bases;
  final List<EntitesObject> ships;
  final int score;
  final bool isWin;
  final bool isLost;
  final bool isPause;
  final bool isBegin;

  BattleState({
    required this.bases,
    required this.ships,
    required this.isWin,
    required this.isLost,
    required this.isPause,
    required this.score,
    required this.isBegin,
  });
  factory BattleState.initial() => BattleState(
        bases: [],
        ships: [],
        isLost: false,
        isWin: false,
        isPause: true,
        score: 0,
        isBegin: true,
      );
  BattleState copyWith({
    List<Base>? bases,
    List<EntitesObject>? ships,
    int? score,
    bool? isWin,
    bool? isLost,
    bool? isPause,
    bool? isBegin,
  }) =>
      BattleState(
        bases: bases ?? this.bases,
        ships: ships ?? this.ships,
        isLost: isLost ?? this.isLost,
        isWin: isWin ?? this.isWin,
        isPause: isPause ?? this.isPause,
        score: score ?? this.score,
        isBegin: isBegin ?? this.isBegin,
      );
}
