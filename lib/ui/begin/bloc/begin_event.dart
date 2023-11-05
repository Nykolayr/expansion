part of 'begin_bloc.dart';

abstract class BeginEvent extends Equatable {
  const BeginEvent();

  @override
  List<Object> get props => [];
}

class ChangeLevel extends BeginEvent {
  final Level level;
  const ChangeLevel(this.level);
}

class ChangeUniver extends BeginEvent {
  final Univer univer;
  const ChangeUniver(this.univer);
}

class ChangeHint extends BeginEvent {}
