part of 'battle_bloc.dart';

abstract class BattleEvent extends Equatable {
  const BattleEvent();

  @override
  List<Object> get props => [];
}

class InitEvent extends BattleEvent {}

class CloseEvent extends BattleEvent {}

class PauseEvent extends BattleEvent {}

class PlayEvent extends BattleEvent {}

class WinEvent extends BattleEvent {}

class LostEvent extends BattleEvent {}

class TicEvent extends BattleEvent {}

class AddScore extends BattleEvent {}

class ArriveAsteroidEvent extends BattleEvent {
  final int index;
  final int? indexBase;
  final int? indexShip;
  const ArriveAsteroidEvent(this.index, this.indexBase, this.indexShip);
}

class SendEvent extends BattleEvent {
  final int toIndex;
  final int fromIndex;
  const SendEvent(this.toIndex, this.fromIndex);
}

class ArriveShipsEvent extends BattleEvent {
  final int index;
  final int toIndex;
  final int? indexShip;
  const ArriveShipsEvent(this.index, this.toIndex, this.indexShip);
}

class BattleShipsEvent extends BattleEvent {
  final int enemyIndex;
  final int indexShip;
  const BattleShipsEvent(this.enemyIndex, this.indexShip);
}
