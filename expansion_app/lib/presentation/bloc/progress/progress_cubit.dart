import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/presentation/bloc/progress/progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit(this._guest) : super(const ProgressState());

  final GuestProfileRepository _guest;

  Future<void> load() async {
    emit(state.copyWith(status: ProgressStatus.loading));
    try {
      final guest = await _guest.load();
      emit(
        state.copyWith(
          status: ProgressStatus.ready,
          currentMission: guest.mapClassic,
          completedMissions: (guest.mapClassic - 1).clamp(0, 40),
          score: guest.scoreClassic,
          enemyPower: guest.meta.enemyPowerLevel,
          difficulty: guest.difficulty,
          univer: guest.univerKind,
        ),
      );
    } catch (e, stackTrace) {
      AppLog.error('progress load failed', error: e, stackTrace: stackTrace);
      emit(state.copyWith(status: ProgressStatus.failure));
    }
  }
}
