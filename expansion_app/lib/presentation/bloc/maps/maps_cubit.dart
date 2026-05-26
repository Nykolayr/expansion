import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/domain/repositories/campaign_repository.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/presentation/bloc/maps/maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  MapsCubit(this._campaign, this._guest) : super(const MapsState());

  final CampaignRepository _campaign;
  final GuestProfileRepository _guest;

  Future<void> load() async {
    emit(state.copyWith(status: MapsStatus.loading));
    AppLog.trace('maps load start', tag: 'Maps');

    try {
      final guest = await _guest.load();
      final scenes = await _campaign.getCampaignScenes();
      final currentId = guest.mapClassic.clamp(1, scenes.length);

      emit(
        state.copyWith(
          status: MapsStatus.ready,
          scenes: scenes,
          currentMissionId: currentId,
          selectedSceneId: currentId,
          clearSelection: false,
        ),
      );
      AppLog.trace('maps load done n=${scenes.length}', tag: 'Maps');
    } catch (e, stackTrace) {
      AppLog.error('maps load failed', error: e, stackTrace: stackTrace);
      emit(
        state.copyWith(
          status: MapsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void selectScene(int sceneId) {
    if (sceneId > state.currentMissionId) return;
    emit(state.copyWith(selectedSceneId: sceneId));
  }

  bool canStartBattle(int sceneId) => sceneId <= state.currentMissionId;

  Future<int?> missionIdForBattle() async {
    final id = state.selectedSceneId ?? state.currentMissionId;
    if (!canStartBattle(id)) return null;
    return id;
  }
}
