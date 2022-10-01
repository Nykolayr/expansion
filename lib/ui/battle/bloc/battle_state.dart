part of 'battle_bloc.dart';

abstract class BattleState extends Equatable {
  final double x;
  final double y;
  const BattleState(this.x, this.y);

  @override
  List<Object> get props => [x, y];
}

class BattleChange extends BattleState {
  const BattleChange(super.x, super.y);
  factory BattleChange.copyWith(double x, double y) {
    return BattleChange(x, y);
  }
}
