part of 'begin_bloc.dart';

abstract class BeginState extends Equatable {
  const BeginState();
  
  @override
  List<Object> get props => [];
}

class BeginInitial extends BeginState {}
