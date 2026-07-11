import 'package:equatable/equatable.dart';

import 'package:expansion/domain/entities/auth_user.dart';

class AuthSession extends Equatable {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final AuthUser user;

  @override
  List<Object?> get props => [accessToken, refreshToken, user];
}

class RegisterPending extends Equatable {
  const RegisterPending({
    required this.email,
    required this.verificationExpiresAt,
    this.message = '',
  });

  final String email;
  final DateTime? verificationExpiresAt;
  final String message;

  @override
  List<Object?> get props => [email, verificationExpiresAt, message];
}

class NickAvailability extends Equatable {
  const NickAvailability({
    required this.available,
    this.reason,
  });

  final bool available;
  final String? reason;

  @override
  List<Object?> get props => [available, reason];
}
