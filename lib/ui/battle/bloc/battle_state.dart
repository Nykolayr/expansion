part of 'battle_bloc.dart';

abstract class BattleState extends Equatable {
  @override
  List<EntityObject> get props => [];
}

class Battleinit extends BattleState {}

class BattleChange extends BattleState {
  final List<EntityObject> objects;
  final int index;
  BattleChange(this.objects, this.index);
  factory BattleChange.copyWith(List<EntityObject> objects, int index) {
    return BattleChange(objects, index);
  }
}
