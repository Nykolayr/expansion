import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/core/error/failures.dart';
import 'package:expansion/domain/repositories/auth_repository.dart';
import 'package:expansion/presentation/bloc/auth/register_state.dart';
import 'package:expansion/presentation/services/auth_post_login_service.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._auth, this._postLogin) : super(const RegisterState());

  final AuthRepository _auth;
  final AuthPostLoginService _postLogin;
  Timer? _nickDebounce;

  void updateEmail(String value) => emit(state.copyWith(email: value));
  void updatePassword(String value) => emit(state.copyWith(password: value));
  void updateRealName(String value) => emit(state.copyWith(realName: value));

  void updateNick(String value) {
    emit(
      state.copyWith(
        nick: value,
        nickStatus: NickCheckStatus.idle,
        clearNickReason: true,
      ),
    );
    _nickDebounce?.cancel();
    _nickDebounce = Timer(const Duration(milliseconds: 450), () {
      _checkNick(value);
    });
  }

  Future<void> _checkNick(String raw) async {
    final nick = raw.trim();
    if (nick.length < 3) {
      emit(
        state.copyWith(
          nickStatus: NickCheckStatus.unavailable,
          nickReason: 'NICK_LENGTH',
        ),
      );
      return;
    }

    emit(state.copyWith(nickStatus: NickCheckStatus.checking));
    final result = await _auth.checkNickAvailable(nick);
    result.fold(
      (_) => emit(
        state.copyWith(nickStatus: NickCheckStatus.idle),
      ),
      (availability) {
        emit(
          state.copyWith(
            nickStatus: availability.available
                ? NickCheckStatus.available
                : NickCheckStatus.unavailable,
            nickReason: availability.reason,
          ),
        );
      },
    );
  }

  Future<void> submitCredentials() async {
    emit(state.copyWith(status: RegisterStatus.loading, clearError: true));

    final result = await _auth.register(
      email: state.email,
      password: state.password,
      nick: state.nick,
      realName: state.realName,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: _message(failure),
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: RegisterStatus.initial,
          step: RegisterStep.verification,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> submitVerificationCode(String code) async {
    emit(state.copyWith(status: RegisterStatus.loading, clearError: true));

    final result = await _auth.verifyEmail(
      email: state.email,
      code: code,
    );

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: RegisterStatus.failure,
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
              status: RegisterStatus.success,
              needsMerge: true,
            ),
          );
          return;
        }

        await _postLogin.syncAfterAuth(realName: state.realName.trim());
        emit(state.copyWith(status: RegisterStatus.success));
      },
    );
  }

  Future<void> completeMerge(ProgressMergeChoice choice) async {
    await _postLogin.syncAfterAuth(
      forcedChoice: choice,
      realName: state.realName.trim(),
    );
    emit(state.copyWith(status: RegisterStatus.success, needsMerge: false));
  }

  @override
  Future<void> close() {
    _nickDebounce?.cancel();
    return super.close();
  }

  String _message(Failure failure) {
    if (failure is AuthFailure) {
      if (failure.code == 'CONFLICT') return 'authErrorEmailExists';
      if (failure.code == 'NICK_TAKEN') return 'authErrorNickTaken';
      if (failure.code == 'EMAIL_SEND_FAILED') return 'authErrorEmailSend';
    }
    return failure.message;
  }
}
