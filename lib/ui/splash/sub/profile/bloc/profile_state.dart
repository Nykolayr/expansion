part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final User user;
  const ProfileState({required this.user});

  @override
  List<Object> get props => [];

  factory ProfileState.initial() => ProfileState(user: userRepository.user);
  ProfileState copyWith({User? user}) => ProfileState(user: user ?? this.user);
}
