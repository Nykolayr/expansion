import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/core/error/failures.dart';
import 'package:expansion/domain/repositories/auth_repository.dart';
import 'package:expansion/presentation/bloc/auth/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._auth) : super(const ForgotPasswordState());

  final AuthRepository _auth;

  void updateEmail(String value) => emit(state.copyWith(email: value));

  Future<void> submitEmail() async {
    emit(state.copyWith(status: ForgotStatus.loading, clearError: true));
    final result = await _auth.forgotPassword(state.email);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ForgotStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: ForgotStatus.initial,
          step: ForgotStep.reset,
          clearError: true,
        ),
      ),
    );
  }

  Future<bool> submitReset({
    required String code,
    required String newPassword,
  }) async {
    emit(state.copyWith(status: ForgotStatus.loading, clearError: true));
    final result = await _auth.resetPassword(
      email: state.email,
      code: code,
      newPassword: newPassword,
    );

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ForgotStatus.failure,
            errorMessage: _message(failure),
          ),
        );
        return false;
      },
      (_) {
        emit(state.copyWith(status: ForgotStatus.success));
        return true;
      },
    );
  }

  String _message(Failure failure) {
    if (failure is AuthFailure && failure.code == 'VALIDATION') {
      return 'authErrorInvalidCode';
    }
    return failure.message;
  }
}
