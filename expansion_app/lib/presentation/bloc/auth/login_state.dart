import 'package:equatable/equatable.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.needsMerge = false,
  });

  final LoginStatus status;
  final String? errorMessage;
  final bool needsMerge;

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    bool? needsMerge,
    bool clearError = false,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      needsMerge: needsMerge ?? this.needsMerge,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, needsMerge];
}
