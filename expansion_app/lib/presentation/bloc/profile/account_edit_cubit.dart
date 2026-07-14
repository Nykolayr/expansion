import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/core/error/failures.dart';
import 'package:expansion/domain/repositories/auth_repository.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/presentation/bloc/auth/register_state.dart';
import 'package:expansion/presentation/bloc/profile/account_edit_state.dart';
import 'package:expansion/presentation/services/profile_sync_service.dart';

class AccountEditCubit extends Cubit<AccountEditState> {
  AccountEditCubit(
    this._auth,
    this._guest,
    this._sync, {
    required this.initialNick,
  }) : super(const AccountEditState());

  final AuthRepository _auth;
  final GuestProfileRepository _guest;
  final ProfileSyncService _sync;
  final String initialNick;

  Timer? _nickDebounce;

  void checkNick(String raw) {
    final nick = raw.trim();
    if (nick == initialNick.trim()) {
      emit(
        state.copyWith(
          nickStatus: NickCheckStatus.available,
          clearNickReason: true,
        ),
      );
      return;
    }

    if (nick.length < 3) {
      emit(
        state.copyWith(
          nickStatus: NickCheckStatus.unavailable,
          nickReason: 'NICK_LENGTH',
        ),
      );
      return;
    }

    emit(state.copyWith(nickStatus: NickCheckStatus.checking, clearNickReason: true));
    _nickDebounce?.cancel();
    _nickDebounce = Timer(const Duration(milliseconds: 450), () async {
      final result = await _auth.checkNickAvailable(nick);
      result.fold(
        (_) => emit(state.copyWith(nickStatus: NickCheckStatus.idle)),
        (availability) => emit(
          state.copyWith(
            nickStatus: availability.available
                ? NickCheckStatus.available
                : NickCheckStatus.unavailable,
            nickReason: availability.reason,
          ),
        ),
      );
    });
  }

  Future<void> submit({
    required String realName,
    required String nick,
    required String currentPassword,
    required String newPassword,
  }) async {
    if (state.nickStatus == NickCheckStatus.unavailable ||
        state.nickStatus == NickCheckStatus.checking) {
      return;
    }

    emit(state.copyWith(status: AccountEditStatus.loading, clearError: true));

    final result = await _auth.updateAccount(
      realName: realName.trim(),
      nick: nick.trim(),
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: AccountEditStatus.failure,
            errorMessage: _message(failure),
          ),
        );
      },
      (update) async {
        final profile = await _guest.load();
        final trimmedName = realName.trim();
        _sync.pause();
        try {
          await _guest.save(profile.copyWith(displayName: trimmedName));
        } finally {
          _sync.resume();
        }

        emit(
          state.copyWith(
            status: AccountEditStatus.success,
            passwordChanged: update.passwordChanged,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _nickDebounce?.cancel();
    return super.close();
  }

  String _message(Failure failure) {
    if (failure is AuthFailure) {
      return switch (failure.code) {
        'NICK_TAKEN' => 'authErrorNickTaken',
        'AUTH' => 'profileWrongCurrentPassword',
        'VALIDATION' => 'authErrorGeneric',
        _ => failure.message,
      };
    }
    return failure.message;
  }
}
