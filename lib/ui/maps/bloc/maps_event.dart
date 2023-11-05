part of 'maps_bloc.dart';

abstract class MapsEvent extends Equatable {
  const MapsEvent();

  @override
  List<Object> get props => [];
}

class MapsBeginEvent extends MapsEvent {}

class MapsShowEvent extends MapsEvent {}

class MapsMoveEvent extends MapsEvent {}

class MapsEndEvent extends MapsEvent {}
