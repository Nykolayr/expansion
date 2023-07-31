part of 'profile_register_bloc.dart';

abstract class ProfileRegisterEvent extends Equatable {
  const ProfileRegisterEvent();

  @override
  List<Object> get props => [];
}

class ChangeSound extends ProfileRegisterEvent {}

class ChangeLang extends ProfileRegisterEvent {}
