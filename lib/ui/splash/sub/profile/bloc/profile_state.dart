part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final UserGame user;
  const ProfileState({required this.user});

  @override
  List<Object> get props => [];

  factory ProfileState.initial() => ProfileState(user: userRepository.user);
  ProfileState copyWith({UserGame? user}) =>
      ProfileState(user: user ?? this.user);
}
