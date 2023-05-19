part of 'battle_bloc.dart';

class BattleState {
  final List<BaseObject> objects;
  final int index;
  final int toIndex;
  final ActionObject action;

  BattleState({
    required this.objects,
    required this.index,
    required this.toIndex,
    required this.action,
  });
  factory BattleState.initial() =>
      BattleState(objects: [], index: -1, toIndex: -1, action: ActionObject.no);
  BattleState copyWith({
    List<BaseObject>? objects,
    int? index,
    int? toIndex,
    ActionObject? action,
  }) =>
      BattleState(
        objects: objects ?? this.objects,
        index: index ?? this.index,
        toIndex: toIndex ?? this.toIndex,
        action: action ?? this.action,
      );
}
