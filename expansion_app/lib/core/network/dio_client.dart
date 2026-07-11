import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:expansion/core/constants/api_config.dart';
import 'package:expansion/core/network/auth_interceptor.dart';
import 'package:expansion/core/storage/auth_token_storage.dart';

/// Обертка над [Dio]: base URL, таймауты, Bearer + refresh.
class DioClient {
  DioClient(this._tokenStorage) {
    _authInterceptor = AuthInterceptor(_tokenStorage);
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    _dio.interceptors.add(_authInterceptor);
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.extra['dio'] = _dio;
          handler.next(options);
        },
      ),
    );
  }

  final AuthTokenStorage _tokenStorage;
  late final Dio _dio;
  late final AuthInterceptor _authInterceptor;

  Dio get dio => _dio;

  AuthInterceptor get authInterceptor => _authInterceptor;

  void bindTokenRefresh(Future<bool> Function() refreshSession) {
    _authInterceptor.refreshSession = refreshSession;
  }
}
