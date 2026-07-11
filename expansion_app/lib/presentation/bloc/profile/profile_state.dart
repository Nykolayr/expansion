import 'package:equatable/equatable.dart';

import 'package:expansion/domain/entities/auth_user.dart';
import 'package:expansion/domain/entities/guest_profile.dart';

enum ProfileStatus { initial, loading, ready, failure }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.accountUser,
    this.accountLoading = false,
  });

  final ProfileStatus status;
  final GuestProfile? profile;
  final AuthUser? accountUser;
  final bool accountLoading;

  bool get isLoggedIn => accountUser != null;

  ProfileState copyWith({
    ProfileStatus? status,
    GuestProfile? profile,
    AuthUser? accountUser,
    bool? accountLoading,
    bool clearAccountUser = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      accountUser:
          clearAccountUser ? null : accountUser ?? this.accountUser,
      accountLoading: accountLoading ?? this.accountLoading,
    );
  }

  @override
  List<Object?> get props => [status, profile, accountUser, accountLoading];
}
