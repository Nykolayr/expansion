part of 'profile_register_bloc.dart';

abstract class ProfileRegisterState extends Equatable {
  const ProfileRegisterState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileRegisterState {}

class ProfileChange extends ProfileRegisterState {}
