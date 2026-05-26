import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/entities/campaign_scene.dart';
import 'package:expansion/presentation/widgets/maps/map_scene_tile.dart';

class CampaignMapGrid extends StatelessWidget {
  const CampaignMapGrid({
    required this.scenes,
    required this.currentMissionId,
    required this.selectedSceneId,
    required this.resolveTitle,
    required this.onSceneTap,
    super.key,
  });

  static const int _columns = 5;

  final List<CampaignScene> scenes;
  final int currentMissionId;
  final int? selectedSceneId;
  final String Function(CampaignScene scene) resolveTitle;
  final void Function(CampaignScene scene) onSceneTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _columns,
        mainAxisExtent: 108,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: scenes.length,
      itemBuilder: (context, index) {
        final scene = scenes[index];
        final tileState = _resolveState(scene);
        final locked = scene.id > currentMissionId;

        return MapSceneTile(
          scene: scene,
          title: resolveTitle(scene),
          tileState: tileState,
          onTap: locked ? null : () => onSceneTap(scene),
        );
      },
    );
  }

  MapSceneTileState _resolveState(CampaignScene scene) {
    if (scene.id > currentMissionId) {
      return MapSceneTileState.locked;
    }
    if (scene.id == selectedSceneId) {
      return MapSceneTileState.selected;
    }
    if (scene.id == currentMissionId) {
      return MapSceneTileState.current;
    }
    return MapSceneTileState.completed;
  }
}

/// Панель описания выбранной миссии.
class CampaignMissionPanel extends StatelessWidget {
  const CampaignMissionPanel({
    required this.title,
    required this.description,
    required this.startLabel,
    required this.canStart,
    required this.onStart,
    super.key,
  });

  final String title;
  final String description;
  final String startLabel;
  final bool canStart;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ExpansionColors.accent,
                ),
          ),
          const Gap(8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ExpansionColors.black,
                ),
          ),
          const Gap(12),
          FilledButton(
            onPressed: canStart ? onStart : null,
            child: Text(startLabel),
          ),
        ],
      ),
    );
  }
}
