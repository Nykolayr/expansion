part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final UserGame user;
  final bool isLoading;
  const ProfileState({required this.user, this.isLoading = false});

  @override
  List<Object> get props => [user, isLoading];

  factory ProfileState.initial() =>
      ProfileState(user: Get.find<UserRepository>().user);
  ProfileState copyWith({UserGame? user, bool? isLoading}) => ProfileState(
      user: user ?? this.user, isLoading: isLoading ?? this.isLoading);
}
