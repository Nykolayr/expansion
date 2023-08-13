part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ChangeName extends ProfileEvent {
  final String name;

  const ChangeName({
    required this.name,
  });
}

class SignOut extends ProfileEvent {}

class ChangeUser extends ProfileEvent {
  final String uid;
  const ChangeUser({required this.uid});
}
