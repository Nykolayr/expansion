part of 'scenarios_bloc.dart';

abstract class ScenariosEvent extends Equatable {
  const ScenariosEvent();

  @override
  List<Object> get props => [];
}

class ScenariosInitEvent extends ScenariosEvent {}
