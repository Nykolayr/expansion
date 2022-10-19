part of 'battle_bloc.dart';

abstract class BattleState extends Equatable {
  @override
  List<Object> get props => [];
}

class Battleinit extends BattleState {}

class BattleChange extends BattleState {
  final List<Planet> planets;
  BattleChange(this.planets);
  factory BattleChange.copyWith(List<Planet> planets) {
    return BattleChange(planets);
  }
}
