part of 'progress_bloc.dart';

abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object> get props => [];
}

class ChangeSound extends ProgressEvent {}

class ChangeLang extends ProgressEvent {}
