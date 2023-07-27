part of 'battle_bloc.dart';

class BattleState {
  final List<BaseObject> bases;
  final List<EntitesObject> ships;
  final int index;
  final int toIndex;
  final int score;
  final ActionObject action;
  final bool isWin;
  final bool isLost;
  final bool isPause;

  BattleState({
    required this.bases,
    required this.index,
    required this.toIndex,
    required this.action,
    required this.ships,
    required this.isWin,
    required this.isLost,
    required this.isPause,
    required this.score,
  });
  factory BattleState.initial() => BattleState(
        bases: [],
        ships: [],
        index: -1,
        toIndex: -1,
        action: ActionObject.no,
        isLost: false,
        isWin: false,
        isPause: false,
        score: 0,
      );
  BattleState copyWith({
    List<BaseObject>? bases,
    List<EntitesObject>? ships,
    int? index,
    int? toIndex,
    int? score,
    ActionObject? action,
    bool? isWin,
    bool? isLost,
    bool? isPause,
  }) =>
      BattleState(
        bases: bases ?? this.bases,
        ships: ships ?? this.ships,
        index: index ?? this.index,
        toIndex: toIndex ?? this.toIndex,
        action: action ?? this.action,
        isLost: isLost ?? this.isLost,
        isWin: isWin ?? this.isWin,
        isPause: isPause ?? this.isPause,
        score: score ?? this.score,
      );
}
