import 'package:equatable/equatable.dart';

import 'package:expansion/domain/entities/guest_profile.dart';

enum ProfileStatus { initial, loading, ready, failure }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
  });

  final ProfileStatus status;
  final GuestProfile? profile;

  ProfileState copyWith({
    ProfileStatus? status,
    GuestProfile? profile,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
    );
  }

  @override
  List<Object?> get props => [status, profile];
}
