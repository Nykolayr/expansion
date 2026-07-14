import 'package:expansion/domain/entities/account_update_result.dart';
import 'package:expansion/domain/entities/auth_session.dart';
import 'package:expansion/domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    required super.nick,
    required super.realName,
    required super.emailVerified,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      nick: json['nick'] as String,
      realName: json['realName'] as String? ?? '',
      emailVerified: json['emailVerified'] as bool? ?? false,
    );
  }
}

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.accessToken,
    required super.refreshToken,
    required super.user,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: AuthUserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class AccountUpdateModel extends AccountUpdateResult {
  const AccountUpdateModel({
    required super.user,
    required super.passwordChanged,
  });

  factory AccountUpdateModel.fromJson(Map<String, dynamic> json) {
    return AccountUpdateModel(
      user: AuthUserModel.fromJson(json),
      passwordChanged: json['passwordChanged'] as bool? ?? false,
    );
  }
}

class RegisterPendingModel extends RegisterPending {
  const RegisterPendingModel({
    required super.email,
    required super.verificationExpiresAt,
    super.message,
  });

  factory RegisterPendingModel.fromJson(Map<String, dynamic> json) {
    final expiresRaw = json['verificationExpiresAt'] as String?;
    return RegisterPendingModel(
      email: json['email'] as String,
      message: json['message'] as String? ?? '',
      verificationExpiresAt:
          expiresRaw != null ? DateTime.tryParse(expiresRaw) : null,
    );
  }
}

class NickAvailabilityModel extends NickAvailability {
  const NickAvailabilityModel({
    required super.available,
    super.reason,
  });

  factory NickAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return NickAvailabilityModel(
      available: json['available'] as bool? ?? false,
      reason: json['reason'] as String?,
    );
  }
}
