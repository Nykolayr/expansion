part of 'profile_login_bloc.dart';

abstract class ProfileLoginEvent extends Equatable {
  const ProfileLoginEvent();

  @override
  List<Object> get props => [];
}

class ChangeSound extends ProfileLoginEvent {}

class ChangeLang extends ProfileLoginEvent {}
