part of 'battle_bloc.dart';

class BattleState {
  final List<EntitesObject> bases;
  final List<Ship> ships;
  final int index;
  final int toIndex;
  final ActionObject action;

  BattleState({
    required this.bases,
    required this.index,
    required this.toIndex,
    required this.action,
    required this.ships,
  });
  factory BattleState.initial() => BattleState(
      bases: [], ships: [], index: -1, toIndex: -1, action: ActionObject.no);
  BattleState copyWith({
    List<EntitesObject>? bases,
    List<Ship>? ships,
    int? index,
    int? toIndex,
    ActionObject? action,
  }) =>
      BattleState(
        bases: bases ?? this.bases,
        ships: ships ?? this.ships,
        index: index ?? this.index,
        toIndex: toIndex ?? this.toIndex,
        action: action ?? this.action,
      );
}
