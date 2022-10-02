part of 'progress_bloc.dart';

abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProgressState {}

class ProfileChange extends ProgressState {}
