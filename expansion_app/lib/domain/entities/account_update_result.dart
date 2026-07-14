import 'package:equatable/equatable.dart';

import 'package:expansion/domain/entities/auth_user.dart';

class AccountUpdateResult extends Equatable {
  const AccountUpdateResult({
    required this.user,
    required this.passwordChanged,
  });

  final AuthUser user;
  final bool passwordChanged;

  @override
  List<Object?> get props => [user, passwordChanged];
}
