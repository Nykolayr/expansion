import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:expansion/core/constants/asset_paths.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';
import 'package:expansion/domain/entities/campaign_scene.dart';
import 'package:expansion/presentation/widgets/maps/campaign_map_layout.dart';

class MapSceneTile extends StatelessWidget {
  const MapSceneTile({
    required this.scene,
    required this.title,
    required this.unknownTitle,
    required this.isLocked,
    required this.showTarget,
    required this.showCurrentGoal,
    required this.isCompleted,
    required this.onTap,
    super.key,
  });

  final CampaignScene scene;
  final String title;
  final String unknownTitle;
  final bool isLocked;
  final bool showTarget;
  final bool showCurrentGoal;
  final bool isCompleted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final displayTitle = isLocked ? unknownTitle : title;

    Widget badge;
    if (isLocked) {
      badge = SvgPicture.asset(
        AssetPaths.svg('lock.svg'),
        width: 13,
        colorFilter: const ColorFilter.mode(
          ExpansionColors.accent,
          BlendMode.srcIn,
        ),
      );
    } else if (showTarget) {
      badge = SvgPicture.asset(
        AssetPaths.svg('target.svg'),
        width: 20,
      );
    } else if (showCurrentGoal) {
      badge = SvgPicture.asset(
        AssetPaths.svg('finger.svg'),
        width: 18,
        colorFilter: const ColorFilter.mode(
          ExpansionColors.accent,
          BlendMode.srcIn,
        ),
      );
    } else if (isCompleted) {
      badge = const Icon(
        Icons.check_circle,
        color: ExpansionColors.green,
        size: 20,
      );
    } else {
      badge = Text(
        '${scene.id}',
        style: ExpansionTextStyles.titleAccent(context, 14),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Opacity(
          opacity: isLocked ? 0.5 : 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: CampaignMapLayout.sceneHeight,
                width: double.infinity,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SvgPicture.asset(
                        AssetPaths.svg('scene.svg'),
                        height: CampaignMapLayout.sceneHeight,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      top: CampaignMapLayout.badgeTop,
                      left: 0,
                      right: 0,
                      child: Center(child: badge),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: CampaignMapLayout.sceneToTitleGap),
              SizedBox(
                height: CampaignMapLayout.titleBlockHeight,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    displayTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: ExpansionTextStyles.bodyOnDark(context, 10).copyWith(
                      color: isCompleted
                          ? ExpansionColors.green
                          : ExpansionColors.white,
                      letterSpacing: isLocked ? 1.2 : 0,
                      height: 1.15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
