import 'package:flutter/material.dart';

import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';
import 'package:expansion/domain/entities/campaign_scene.dart';

enum MapSceneTileState { locked, current, completed, selected }

class MapSceneTile extends StatelessWidget {
  const MapSceneTile({
    required this.scene,
    required this.title,
    required this.tileState,
    required this.onTap,
    super.key,
  });

  final CampaignScene scene;
  final String title;
  final MapSceneTileState tileState;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isLocked = tileState == MapSceneTileState.locked;
    final isCurrent = tileState == MapSceneTileState.current;
    final isSelected = tileState == MapSceneTileState.selected;

    Color borderColor = ExpansionColors.grey;
    Color fillColor = ExpansionColors.background.withValues(alpha: 0.75);

    if (isLocked) {
      borderColor = ExpansionColors.grey.withValues(alpha: 0.5);
    } else if (isSelected || isCurrent) {
      borderColor = ExpansionColors.accent;
      fillColor = ExpansionColors.background.withValues(alpha: 0.95);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isLocked ? Icons.lock_outline : Icons.public,
                color: isLocked ? ExpansionColors.grey : ExpansionColors.accent,
                size: 22,
              ),
              const SizedBox(height: 6),
              Text(
                '${scene.id}',
                style: ExpansionTextStyles.titleAccent(context, 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: ExpansionTextStyles.bodyOnDark(context, 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
