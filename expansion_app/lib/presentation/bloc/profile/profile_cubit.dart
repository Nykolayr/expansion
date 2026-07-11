import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/domain/repositories/auth_repository.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/presentation/bloc/profile/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._guest, this._auth) : super(const ProfileState());

  final GuestProfileRepository _guest;
  final AuthRepository _auth;

  Future<void> load() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await _guest.ensureCampaignStartedAt();
      final profile = await _guest.load();
      emit(
        state.copyWith(
          status: ProfileStatus.ready,
          profile: profile,
          accountLoading: true,
        ),
      );
      await _loadAccountUser();
    } catch (e, stackTrace) {
      AppLog.error('profile load failed', error: e, stackTrace: stackTrace);
      emit(state.copyWith(status: ProfileStatus.failure));
    }
  }

  Future<void> _loadAccountUser() async {
    if (!await _auth.isLoggedIn()) {
      emit(state.copyWith(clearAccountUser: true, accountLoading: false));
      return;
    }

    final result = await _auth.fetchMe();
    result.fold(
      (_) => emit(state.copyWith(clearAccountUser: true, accountLoading: false)),
      (user) => emit(
        state.copyWith(accountUser: user, accountLoading: false),
      ),
    );
  }

  Future<void> updateDisplayName(String name) async {
    final profile = state.profile;
    if (profile == null) return;
    final trimmed = name.trim();
    await _guest.save(profile.copyWith(displayName: trimmed));
    emit(state.copyWith(profile: profile.copyWith(displayName: trimmed)));
  }

  Future<bool> logout() async {
    emit(state.copyWith(accountLoading: true));
    final result = await _auth.logout();
    return result.fold(
      (_) {
        emit(state.copyWith(accountLoading: false));
        return false;
      },
      (_) {
        emit(state.copyWith(clearAccountUser: true, accountLoading: false));
        return true;
      },
    );
  }

  Future<bool> deleteAccount() async {
    emit(state.copyWith(accountLoading: true));
    final result = await _auth.deleteAccount();
    return result.fold(
      (_) {
        emit(state.copyWith(accountLoading: false));
        return false;
      },
      (_) {
        emit(state.copyWith(clearAccountUser: true, accountLoading: false));
        return true;
      },
    );
  }
}
