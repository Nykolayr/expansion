part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ChangeSound extends ProfileEvent {}

class ChangeLang extends ProfileEvent {}
