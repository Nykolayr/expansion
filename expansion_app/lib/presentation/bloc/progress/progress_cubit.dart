import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/domain/campaign/campaign_sectors.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/presentation/bloc/progress/progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit(this._guest) : super(const ProgressState());

  final GuestProfileRepository _guest;

  Future<void> load() async {
    emit(state.copyWith(status: ProgressStatus.loading));
    try {
      final guest = await _guest.load();
      final mission = guest.mapClassic < 1 ? 1 : guest.mapClassic;
      emit(
        state.copyWith(
          status: ProgressStatus.ready,
          currentMission: mission,
          completedMissions: (guest.mapClassic - 1).clamp(0, 1 << 20),
          score: guest.scoreClassic,
          nebulaIndex: CampaignSectors.nebulaIndexForMission(mission),
          enemyTurnDivider:
              CampaignSectors.enemyTurnDividerForMission(mission),
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
