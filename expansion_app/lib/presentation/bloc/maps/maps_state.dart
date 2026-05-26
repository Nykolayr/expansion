import 'package:equatable/equatable.dart';

import 'package:expansion/domain/entities/campaign_scene.dart';

enum MapsStatus { initial, loading, ready, failure }

class MapsState extends Equatable {
  const MapsState({
    this.status = MapsStatus.initial,
    this.scenes = const [],
    this.currentMissionId = 1,
    this.selectedSceneId,
    this.errorMessage,
  });

  final MapsStatus status;
  final List<CampaignScene> scenes;
  final int currentMissionId;
  final int? selectedSceneId;
  final String? errorMessage;

  CampaignScene? get selectedScene {
    final id = selectedSceneId;
    if (id == null) return null;
    for (final scene in scenes) {
      if (scene.id == id) return scene;
    }
    return null;
  }

  MapsState copyWith({
    MapsStatus? status,
    List<CampaignScene>? scenes,
    int? currentMissionId,
    int? selectedSceneId,
    bool clearSelection = false,
    String? errorMessage,
  }) {
    return MapsState(
      status: status ?? this.status,
      scenes: scenes ?? this.scenes,
      currentMissionId: currentMissionId ?? this.currentMissionId,
      selectedSceneId:
          clearSelection ? null : selectedSceneId ?? this.selectedSceneId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        scenes,
        currentMissionId,
        selectedSceneId,
        errorMessage,
      ];
}
