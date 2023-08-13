part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ChangeName extends ProfileEvent {
  final String name;
  const ChangeName(this.name);
}
