import 'package:dartz/dartz.dart';

import 'package:expansion/core/error/exceptions.dart';
import 'package:expansion/core/error/failures.dart';
import 'package:expansion/core/storage/auth_token_storage.dart';
import 'package:expansion/data/datasources/remote/auth_remote_datasource.dart';
import 'package:expansion/domain/entities/auth_session.dart';
import 'package:expansion/domain/entities/auth_user.dart';
import 'package:expansion/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._tokenStorage);

  final AuthRemoteDataSource _remote;
  final AuthTokenStorage _tokenStorage;

  @override
  Future<bool> isLoggedIn() => _tokenStorage.hasRefreshToken();

  @override
  Future<Either<Failure, NickAvailability>> checkNickAvailable(
    String nick,
  ) async {
    return _guard(() async {
      final result = await _remote.checkNickAvailable(nick.trim());
      return NickAvailability(
        available: result.available,
        reason: result.reason,
      );
    });
  }

  @override
  Future<Either<Failure, RegisterPending>> register({
    required String email,
    required String password,
    required String nick,
    required String realName,
  }) async {
    return _guard(() async {
      final result = await _remote.register(
        email: email.trim(),
        password: password,
        nick: nick.trim(),
        realName: realName.trim(),
      );
      return RegisterPending(
        email: result.email,
        message: result.message,
        verificationExpiresAt: result.verificationExpiresAt,
      );
    });
  }

  @override
  Future<Either<Failure, AuthSession>> verifyEmail({
    required String email,
    required String code,
  }) async {
    return _guard(() async {
      final session = await _remote.verifyEmail(
        email: email.trim(),
        code: code.trim(),
      );
      await _persistSession(session);
      return session;
    });
  }

  @override
  Future<Either<Failure, AuthSession>> login({
    required String email,
    required String password,
  }) async {
    return _guard(() async {
      final session = await _remote.login(
        email: email.trim(),
        password: password,
      );
      await _persistSession(session);
      return session;
    });
  }

  @override
  Future<Either<Failure, AuthSession>> refreshSession() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return const Left(AuthFailure('Not logged in', code: 'NO_SESSION'));
    }

    return _guard(() async {
      final session = await _remote.refresh(refreshToken);
      await _persistSession(session);
      return session;
    });
  }

  @override
  Future<Either<Failure, AuthUser>> fetchMe() async {
    if (!await isLoggedIn()) {
      return const Left(AuthFailure('Not logged in', code: 'NO_SESSION'));
    }

    return _guard(() => _remote.fetchMe());
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    return _guard(() async {
      await _remote.forgotPassword(email.trim());
    });
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    return _guard(() async {
      await _remote.resetPassword(
        email: email.trim(),
        code: code.trim(),
        newPassword: newPassword,
      );
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final refreshToken = await _tokenStorage.readRefreshToken();

    if (await isLoggedIn()) {
      try {
        await _remote.logout(refreshToken: refreshToken);
      } on ServerException {
        // Локально всё равно выходим.
      }
    }

    await clearLocalSession();
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    return _guard(() async {
      await _remote.deleteAccount();
      await clearLocalSession();
    });
  }

  @override
  Future<void> clearLocalSession() => _tokenStorage.clear();

  Future<void> _persistSession(AuthSession session) {
    return _tokenStorage.saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on ConflictException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(e.message, code: 'UNAUTHORIZED'));
    } on BadRequestException catch (e) {
      return Left(AuthFailure(e.message, code: 'VALIDATION'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Unknown error'));
    }
  }
}
