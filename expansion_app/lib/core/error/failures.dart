import 'package:equatable/equatable.dart';

/// Ошибка для слоя domain / presentation (например `Either<Failure, T>`).
abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Auth/API с кодом сервера (`CONFLICT`, `NICK_TAKEN`, …).
class AuthFailure extends Failure {
  const AuthFailure(super.message, {this.code});

  final String? code;

  @override
  List<Object?> get props => [message, code];
}
