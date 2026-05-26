import 'package:equatable/equatable.dart';

import 'package:expansion/domain/entities/guest_profile.dart';

enum UpgradesStatus { initial, ready, failure }

class UpgradesState extends Equatable {
  const UpgradesState({
    this.status = UpgradesStatus.initial,
    this.profile,
    this.messageKey,
  });

  final UpgradesStatus status;
  final GuestProfile? profile;
  final String? messageKey;

  int get score => profile?.scoreClassic ?? 0;

  UpgradesState copyWith({
    UpgradesStatus? status,
    GuestProfile? profile,
    String? messageKey,
    bool clearMessage = false,
  }) {
    return UpgradesState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      messageKey: clearMessage ? null : messageKey ?? this.messageKey,
    );
  }

  @override
  List<Object?> get props => [status, profile, messageKey];
}
