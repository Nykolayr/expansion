import 'package:equatable/equatable.dart';

enum ForgotStep { email, reset }

enum ForgotStatus { initial, loading, success, failure }

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.step = ForgotStep.email,
    this.status = ForgotStatus.initial,
    this.errorMessage,
    this.email = '',
  });

  final ForgotStep step;
  final ForgotStatus status;
  final String? errorMessage;
  final String email;

  ForgotPasswordState copyWith({
    ForgotStep? step,
    ForgotStatus? status,
    String? errorMessage,
    String? email,
    bool clearError = false,
  }) {
    return ForgotPasswordState(
      step: step ?? this.step,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [step, status, errorMessage, email];
}
