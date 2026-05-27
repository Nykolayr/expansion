import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/entities/campaign_scene.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';
import 'package:expansion/presentation/widgets/maps/campaign_map_layout.dart';
import 'package:expansion/presentation/widgets/maps/campaign_map_path_painter.dart';
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

  final List<CampaignScene> scenes;
  final int currentMissionId;
  final int? selectedSceneId;
  final String Function(CampaignScene scene) resolveTitle;
  final void Function(CampaignScene scene) onSceneTap;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final ordered = List<CampaignScene>.from(scenes)
      ..sort((a, b) => a.id.compareTo(b.id));

    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: CampaignMapPathPainter(
                missionCount: ordered.length,
                currentMissionId: currentMissionId,
              ),
            ),
          ),
        ),
        GridView.builder(
          padding: CampaignMapLayout.padding,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: CampaignMapLayout.columns,
            mainAxisExtent: CampaignMapLayout.cellExtent,
            crossAxisSpacing: CampaignMapLayout.crossSpacing,
            mainAxisSpacing: CampaignMapLayout.mainAxisSpacing,
          ),
          itemCount: ordered.length,
          itemBuilder: (context, index) {
            final scene = ordered[index];
            final locked = scene.id > currentMissionId;
            final selected = scene.id == selectedSceneId;
            // Мишень на выбранной (по умолчанию — текущая); палец на текущей,
            // только если мишень перенесли на другую пройденную систему.
            final showTarget = selected;
            final targetOnOtherMission =
                selectedSceneId != null &&
                selectedSceneId != currentMissionId;
            final showCurrentGoal =
                scene.id == currentMissionId && targetOnOtherMission;
            final completed =
                scene.id < currentMissionId && !showTarget && !showCurrentGoal;

            return MapSceneTile(
              scene: scene,
              title: resolveTitle(scene),
              unknownTitle: loc.mapsUnknownSystem,
              isLocked: locked,
              showTarget: showTarget,
              showCurrentGoal: showCurrentGoal,
              isCompleted: completed,
              onTap: locked ? null : () => onSceneTap(scene),
            );
          },
        ),
      ],
    );
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
                  color: ExpansionColors.white,
                  fontSize: 15,
                  height: 1.35,
                  shadows: const [
                    Shadow(color: Colors.black87, blurRadius: 6),
                  ],
                ),
          ),
          const Gap(12),
          GameLongButton(
            label: startLabel,
            onPressed: canStart ? onStart : null,
          ),
        ],
      ),
    );
  }
}
