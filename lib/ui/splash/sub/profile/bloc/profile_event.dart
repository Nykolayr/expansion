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

class ChangeUser extends ProfileEvent {
  final String name;
  final String photoUrl;
  final String uid;
  final bool isRegistration;
  const ChangeUser(
      {required this.name,
      required this.photoUrl,
      required this.uid,
      required this.isRegistration});
}
