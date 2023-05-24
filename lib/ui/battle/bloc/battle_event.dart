part of 'battle_bloc.dart';

abstract class BattleEvent extends Equatable {
  const BattleEvent();

  @override
  List<Object> get props => [];
}

class InitEvent extends BattleEvent {}

class PauseEvent extends BattleEvent {}

class PlayEvent extends BattleEvent {}

class WinEvent extends BattleEvent {}

class LostEvent extends BattleEvent {}

class TicEvent extends BattleEvent {}

class PressEvent extends BattleEvent {
  final int index;
  const PressEvent(this.index);
}

class SendEvent extends BattleEvent {
  final int index;
  final int send;
  const SendEvent(this.index, this.send);
}

class ArriveShipsEvent extends BattleEvent {
  final int index;
  final int toIndex;
  const ArriveShipsEvent(this.index, this.toIndex);
}
