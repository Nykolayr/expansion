part of 'battle_bloc.dart';

abstract class BattleState extends Equatable {
  @override
  List<Object> get props => [];
}

class Battleinit extends BattleState {}

class BattleChange extends BattleState {
  final List<NeutralBase> objects;
  BattleChange(this.objects);
  factory BattleChange.copyWith(List<NeutralBase> objects) {
    return BattleChange(objects);
  }
}
