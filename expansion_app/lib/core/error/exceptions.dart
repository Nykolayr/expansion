/// Базовое исключение сетевого/серверного слоя (data). Ловить в репозиториях и маппить в [Failure].
abstract class ServerException implements Exception {
  const ServerException(this.message);

  final String message;

  @override
  String toString() => message;
}

class BadRequestException extends ServerException {
  const BadRequestException([super.message = 'Bad request']);
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException([super.message = 'Unauthorized']);
}

class NotFoundException extends ServerException {
  const NotFoundException([super.message = 'Not found']);
}

class InternalServerErrorException extends ServerException {
  const InternalServerErrorException([super.message = 'Internal server error']);
}

class NoInternetConnectionException extends ServerException {
  const NoInternetConnectionException([super.message = 'No internet connection']);
}

/// Таймаут запроса (имя отличается от [TimeoutException] из `dart:async`).
class RequestTimeoutException extends ServerException {
  const RequestTimeoutException([super.message = 'Request timeout']);
}

/// Ответ/ситуация без отдельного кодового типа.
class UnknownServerException extends ServerException {
  const UnknownServerException(super.message);
}
