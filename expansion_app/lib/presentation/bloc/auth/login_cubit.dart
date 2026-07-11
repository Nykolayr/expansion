import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/core/error/failures.dart';
import 'package:expansion/domain/repositories/auth_repository.dart';
import 'package:expansion/presentation/bloc/auth/login_state.dart';
import 'package:expansion/presentation/services/auth_post_login_service.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._auth, this._postLogin) : super(const LoginState());

  final AuthRepository _auth;
  final AuthPostLoginService _postLogin;

  Future<void> submit({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: LoginStatus.loading, clearError: true));

    final result = await _auth.login(email: email, password: password);
    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorMessage: _message(failure),
          ),
        );
      },
      (_) async {
        final local = await _postLogin.loadLocalProfile();
        final server = await _postLogin.fetchServerProfile();
        final needsMerge = _postLogin.needsMergeChoice(
          local: local,
          server: server,
        );

        if (needsMerge) {
          emit(
            state.copyWith(
              status: LoginStatus.success,
              needsMerge: true,
            ),
          );
          return;
        }

        await _postLogin.syncAfterAuth();
        emit(state.copyWith(status: LoginStatus.success));
      },
    );
  }

  Future<void> completeMerge(ProgressMergeChoice choice) async {
    await _postLogin.syncAfterAuth(forcedChoice: choice);
    emit(state.copyWith(status: LoginStatus.success, needsMerge: false));
  }

  String _message(Failure failure) {
    if (failure is AuthFailure) {
      if (failure.code == 'UNAUTHORIZED') {
        return 'authErrorInvalidCredentials';
      }
      return failure.message;
    }
    return failure.message;
  }
}
