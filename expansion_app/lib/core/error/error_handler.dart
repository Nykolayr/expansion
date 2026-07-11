import 'package:dio/dio.dart';
import 'package:expansion/core/error/exceptions.dart';

/// Преобразует [DioException] в [ServerException] для data-слоя.
class ErrorHandler {
  const ErrorHandler._();

  static ServerException handle(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return RequestTimeoutException(
          exception.message ?? 'Request timeout',
        );
      case DioExceptionType.connectionError:
        return NoInternetConnectionException(
          exception.message ?? 'No internet connection',
        );
      case DioExceptionType.badCertificate:
        return UnknownServerException(
          exception.message ?? 'Bad certificate',
        );
      case DioExceptionType.cancel:
        return UnknownServerException(exception.message ?? 'Request cancelled');
      case DioExceptionType.badResponse:
        return _fromStatus(exception);
      case DioExceptionType.unknown:
        final msg = exception.message ?? 'Unknown network error';
        if (_looksLikeOffline(msg)) {
          return NoInternetConnectionException(msg);
        }
        return UnknownServerException(msg);
    }
  }

  static bool _looksLikeOffline(String message) {
    final m = message.toLowerCase();
    return m.contains('socketexception') ||
        m.contains('failed host lookup') ||
        m.contains('network is unreachable');
  }

  static ServerException _fromStatus(DioException exception) {
    final status = exception.response?.statusCode;
    final msg = _messageFromResponse(exception) ??
        exception.message ??
        'Server error';

    switch (status) {
      case 400:
        return BadRequestException(_userMessage(msg));
      case 401:
        return UnauthorizedException(_userMessage(msg));
      case 409:
        return ConflictException(
          _userMessage(msg),
          code: _codeFromResponse(exception),
        );
      case 404:
        return NotFoundException(_userMessage(msg));
      case 500:
      case 502:
      case 503:
        return InternalServerErrorException(_userMessage(msg));
      default:
        return InternalServerErrorException(_userMessage(msg));
    }
  }

  static String _userMessage(String raw) {
    final t = raw.trim();
    return t.isEmpty ? 'Server error' : t;
  }

  static String? _messageFromResponse(DioException exception) {
    final data = exception.response?.data;
    if (data is Map<String, dynamic>) {
      final m = data['message'] ?? data['error'] ?? data['detail'];
      if (m is String) return m;
      if (m != null) return m.toString();
    }
    if (data is String && data.trim().isNotEmpty) return data;
    return null;
  }

  static String? _codeFromResponse(DioException exception) {
    final data = exception.response?.data;
    if (data is Map<String, dynamic>) {
      final code = data['code'];
      if (code is String) return code;
      if (code != null) return code.toString();
    }
    return null;
  }
}

