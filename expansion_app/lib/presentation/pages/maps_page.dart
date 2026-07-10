import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/core/constants/game_assets.dart';
import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/domain/entities/campaign_scene.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/maps/maps_cubit.dart';
import 'package:expansion/presentation/bloc/maps/maps_state.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/maps/campaign_map_grid.dart';

/// Карта кампании Classic (40 миссий).
class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  @override
  void activate() {
    super.activate();
    _reloadMaps();
  }

  void _reloadMaps() {
    sl<MapsCubit>().load();
  }

  String _sceneTitle(CampaignScene scene, AppLocalizations loc) {
    final code = Localizations.localeOf(context).languageCode;
    return code == 'ru' ? scene.nameRu : scene.nameEn;
  }

  String _sceneDescription(CampaignScene scene, AppLocalizations loc) {
    final code = Localizations.localeOf(context).languageCode;
    final text = code == 'ru' ? scene.descriptionRu : scene.descriptionEn;
    if (text.trim().isNotEmpty) return text;
    return loc.mapsDescriptionFallback;
  }

  Future<void> _onStartBattle() async {
    final cubit = sl<MapsCubit>();
    final missionId = await cubit.missionIdForBattle();
    if (!mounted || missionId == null) return;
    context.goToBattle(sceneId: missionId);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(GameAssets.splashBackground, fit: BoxFit.cover),
          BlocBuilder<MapsCubit, MapsState>(
        bloc: sl<MapsCubit>(),
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GameScreenBackBar(
                title: loc.mapsTitle,
                onBack: () => context.goHome(),
              ),
              if (state.status == MapsStatus.loading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.status == MapsStatus.failure)
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                      state.errorMessage ?? loc.mapsLoadFailed,
                      style: const TextStyle(color: ExpansionColors.accent),
                    ),
                    ),
                  ),
                )
              else if (state.status == MapsStatus.ready) ...[
                Expanded(
                  child: CampaignMapGrid(
                    scenes: state.scenes,
                    currentMissionId: state.currentMissionId,
                    selectedSceneId: state.selectedSceneId,
                    resolveTitle: (s) => _sceneTitle(s, loc),
                    onSceneTap: (scene) =>
                        sl<MapsCubit>().selectScene(scene.id),
                  ),
                ),
                if (state.selectedScene != null)
                  CampaignMissionPanel(
                    title: _sceneTitle(state.selectedScene!, loc),
                    description:
                        _sceneDescription(state.selectedScene!, loc),
                    startLabel: loc.mapsStartBattle,
                    canStart: sl<MapsCubit>().canStartBattle(
                      state.selectedScene!.id,
                    ),
                    onStart: _onStartBattle,
                  ),
              ]               else
                const SizedBox.shrink(),
            ],
          );
        },
      ),
        ],
      ),
    );
  }
}
