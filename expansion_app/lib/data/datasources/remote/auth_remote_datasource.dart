import 'package:dio/dio.dart';

import 'package:expansion/core/error/error_handler.dart';
import 'package:expansion/data/models/auth_models.dart';

/// REST `/auth/*` — см. `expansion_server/API_DOCS.md`.
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<NickAvailabilityModel> checkNickAvailable(String nick) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/auth/nick-available',
        queryParameters: <String, dynamic>{'nick': nick},
      );
      return NickAvailabilityModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<RegisterPendingModel> register({
    required String email,
    required String password,
    required String nick,
    required String realName,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: <String, dynamic>{
          'email': email,
          'password': password,
          'nick': nick,
          'realName': realName,
        },
      );
      return RegisterPendingModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<AuthSessionModel> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/verify-email',
        data: <String, dynamic>{
          'email': email,
          'code': code,
        },
      );
      return AuthSessionModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: <String, dynamic>{
          'email': email,
          'password': password,
        },
      );
      return AuthSessionModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<AuthSessionModel> refresh(String refreshToken) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: <String, dynamic>{'refreshToken': refreshToken},
        options: Options(extra: <String, dynamic>{'skipAuth': true}),
      );
      return AuthSessionModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<AuthUserModel> fetchMe() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/auth/me');
      return AuthUserModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post<void>(
        '/auth/forgot-password',
        data: <String, dynamic>{'email': email},
      );
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await _dio.post<void>(
        '/auth/reset-password',
        data: <String, dynamic>{
          'email': email,
          'code': code,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> logout({String? refreshToken}) async {
    try {
      await _dio.post<void>(
        '/auth/logout',
        data: refreshToken == null
            ? null
            : <String, dynamic>{'refreshToken': refreshToken},
      );
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _dio.delete<void>('/account');
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
