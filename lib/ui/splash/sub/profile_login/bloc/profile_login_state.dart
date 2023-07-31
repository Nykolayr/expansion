part of 'profile_login_bloc.dart';

abstract class ProfileLoginState extends Equatable {
  const ProfileLoginState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileLoginState {}

class ProfileChange extends ProfileLoginState {}
