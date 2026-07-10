import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/presentation/bloc/profile/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._guest) : super(const ProfileState());

  final GuestProfileRepository _guest;

  Future<void> load() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await _guest.ensureCampaignStartedAt();
      final profile = await _guest.load();
      emit(state.copyWith(status: ProfileStatus.ready, profile: profile));
    } catch (e, stackTrace) {
      AppLog.error('profile load failed', error: e, stackTrace: stackTrace);
      emit(state.copyWith(status: ProfileStatus.failure));
    }
  }

  Future<void> updateDisplayName(String name) async {
    final profile = state.profile;
    if (profile == null) return;
    final trimmed = name.trim();
    await _guest.save(profile.copyWith(displayName: trimmed));
    emit(state.copyWith(profile: profile.copyWith(displayName: trimmed)));
  }
}
