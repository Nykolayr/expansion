import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/domain/enums/meta_upgrade_type.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/presentation/bloc/upgrades/upgrades_state.dart';

class UpgradesCubit extends Cubit<UpgradesState> {
  UpgradesCubit(this._guest) : super(const UpgradesState());

  final GuestProfileRepository _guest;

  Future<void> load() async {
    try {
      final profile = await _guest.load();
      emit(
        state.copyWith(
          status: UpgradesStatus.ready,
          profile: profile,
          clearMessage: true,
        ),
      );
    } catch (e, stackTrace) {
      AppLog.error('upgrades load failed', error: e, stackTrace: stackTrace);
      emit(state.copyWith(status: UpgradesStatus.failure));
    }
  }

  Future<void> purchase(MetaUpgradeType type) async {
    final profile = state.profile;
    if (profile == null) return;

    final updatedMeta = profile.meta.applyUpgrade(type, profile.scoreClassic);
    if (updatedMeta == null) {
      emit(state.copyWith(messageKey: 'notEnough'));
      return;
    }

    final slot = profile.meta.slotOf(type);
    final cost = slot.nextCost;

    final saved = profile.copyWith(
      scoreClassic: profile.scoreClassic - cost,
      meta: updatedMeta,
    );

    await _guest.save(saved);
    AppLog.trace('upgrade ${type.name} -> L${saved.meta.slotOf(type).level}', tag: 'Upgrades');
    emit(
      state.copyWith(
        profile: saved,
        messageKey: 'success',
        clearMessage: false,
      ),
    );
  }
}
