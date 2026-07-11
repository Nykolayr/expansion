import 'package:dartz/dartz.dart';

import 'package:expansion/core/error/failures.dart';
import 'package:expansion/domain/entities/auth_session.dart';
import 'package:expansion/domain/entities/auth_user.dart';

abstract class AuthRepository {
  Future<bool> isLoggedIn();

  Future<Either<Failure, NickAvailability>> checkNickAvailable(String nick);

  Future<Either<Failure, RegisterPending>> register({
    required String email,
    required String password,
    required String nick,
    required String realName,
  });

  Future<Either<Failure, AuthSession>> verifyEmail({
    required String email,
    required String code,
  });

  Future<Either<Failure, AuthSession>> login({
    required String email,
    required String password,
  });

  /// Обновляет пару токенов (rotation). Вызывается interceptor'ом и явно.
  Future<Either<Failure, AuthSession>> refreshSession();

  Future<Either<Failure, AuthUser>> fetchMe();

  Future<Either<Failure, void>> forgotPassword(String email);

  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> deleteAccount();

  Future<void> clearLocalSession();
}
