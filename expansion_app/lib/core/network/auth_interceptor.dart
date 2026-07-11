import 'dart:async';

import 'package:dio/dio.dart';

import 'package:expansion/core/storage/auth_token_storage.dart';

/// Bearer + авто-refresh при 401 (rotation refresh token).
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage);

  final AuthTokenStorage _tokenStorage;

  Future<bool> Function()? refreshSession;

  Completer<bool>? _refreshCompleter;

  static const _publicPathPrefixes = <String>[
    '/auth/register',
    '/auth/verify-email',
    '/auth/login',
    '/auth/refresh',
    '/auth/forgot-password',
    '/auth/reset-password',
    '/auth/nick-available',
    '/content/',
    '/leaderboard',
    '/health',
  ];

  bool _isPublic(RequestOptions options) {
    if (options.extra['skipAuth'] == true) return true;
    final path = options.uri.path;
    for (final prefix in _publicPathPrefixes) {
      if (path.contains(prefix)) return true;
    }
    return false;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isPublic(options)) {
      final token = await _tokenStorage.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    final options = err.requestOptions;

    if (response?.statusCode != 401 ||
        _isPublic(options) ||
        options.extra['retriedAfterRefresh'] == true) {
      handler.next(err);
      return;
    }

    final refreshed = await _refreshOnce();
    if (!refreshed) {
      await _tokenStorage.clear();
      handler.next(err);
      return;
    }

    try {
      final token = await _tokenStorage.readAccessToken();
      final retryOptions = options.copyWith(
        extra: Map<String, dynamic>.from(options.extra)
          ..['retriedAfterRefresh'] = true,
        headers: Map<String, dynamic>.from(options.headers)
          ..['Authorization'] = 'Bearer $token',
      );
      final dio = err.requestOptions.extra['dio'] as Dio?;
      if (dio == null) {
        handler.next(err);
        return;
      }
      final retryResponse = await dio.fetch<dynamic>(retryOptions);
      handler.resolve(retryResponse);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<bool> _refreshOnce() async {
    final refresh = refreshSession;
    if (refresh == null) return false;

    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();
    try {
      final ok = await refresh();
      _refreshCompleter!.complete(ok);
      return ok;
    } catch (_) {
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }
}
