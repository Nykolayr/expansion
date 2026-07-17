import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/extensions/campaign_nebula_l10n.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/campaign/campaign_sectors.dart';
import 'package:expansion/domain/entities/campaign_scene.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/maps/campaign_map_grid.dart';

/// Туманности карты: горизонтальный свайп, при открытии — текущая.
class CampaignMapSectorsView extends StatefulWidget {
  const CampaignMapSectorsView({
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
  State<CampaignMapSectorsView> createState() => _CampaignMapSectorsViewState();
}

class _CampaignMapSectorsViewState extends State<CampaignMapSectorsView> {
  PageController? _pageController;
  int _pageIndex = 0;
  int _nebulaCount = 0;

  @override
  void initState() {
    super.initState();
    _syncController();
  }

  @override
  void didUpdateWidget(covariant CampaignMapSectorsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextCount = CampaignSectors.nebulaCount(widget.scenes.length);
    final nextPage = CampaignSectors.initialNebulaPage(
      widget.currentMissionId,
      widget.scenes.length,
    );
    if (nextCount != _nebulaCount ||
        oldWidget.currentMissionId != widget.currentMissionId) {
      _pageController?.dispose();
      _nebulaCount = nextCount;
      _pageIndex = nextPage;
      _pageController = nextCount > 0
          ? PageController(initialPage: nextPage)
          : null;
    }
  }

  void _syncController() {
    _nebulaCount = CampaignSectors.nebulaCount(widget.scenes.length);
    _pageIndex = CampaignSectors.initialNebulaPage(
      widget.currentMissionId,
      widget.scenes.length,
    );
    _pageController =
        _nebulaCount > 0 ? PageController(initialPage: _pageIndex) : null;
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final controller = _pageController;
    if (controller == null || _nebulaCount <= 0) {
      return const SizedBox.shrink();
    }

    final nebulaId = CampaignSectors.nebulaIdForIndex(_pageIndex);
    final (rangeStart, _) = CampaignSectors.missionRange(_pageIndex);
    final inNebula = CampaignSectors.scenesInNebula(widget.scenes, _pageIndex);
    final lastMission = inNebula.isEmpty ? rangeStart : inNebula.last.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: Column(
            children: [
              Text(
                nebulaId.label(loc),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ExpansionColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Gap(2),
              Text(
                loc.mapsNebulaRange(rangeStart, lastMission),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ExpansionColors.white.withValues(alpha: 0.7),
                    ),
              ),
              if (_nebulaCount > 1) ...[
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_nebulaCount, (i) {
                    final active = i == _pageIndex;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: active ? 10 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: active
                              ? ExpansionColors.accent
                              : ExpansionColors.white.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ],
          ),
        ),
        const Gap(4),
        Expanded(
          child: PageView.builder(
            controller: controller,
            itemCount: _nebulaCount,
            onPageChanged: (i) => setState(() => _pageIndex = i),
            itemBuilder: (context, index) {
              final nebulaScenes =
                  CampaignSectors.scenesInNebula(widget.scenes, index);
              return CampaignMapGrid(
                scenes: nebulaScenes,
                currentMissionId: widget.currentMissionId,
                selectedSceneId: widget.selectedSceneId,
                resolveTitle: widget.resolveTitle,
                onSceneTap: widget.onSceneTap,
              );
            },
          ),
        ),
      ],
    );
  }
}
