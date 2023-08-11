part of 'update_bloc.dart';

abstract class UpdateEvent extends Equatable {
  const UpdateEvent();

  @override
  List<Object> get props => [];
}

class ChangeUdrade extends UpdateEvent {
  final TypeUp type;
  const ChangeUdrade(this.type);
}

class ResetScore extends UpdateEvent {}
