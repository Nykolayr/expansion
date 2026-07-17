import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/domain/campaign/campaign_progress.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/domain/entities/campaign_scene.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/maps/maps_cubit.dart';
import 'package:expansion/presentation/bloc/maps/maps_state.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/dialogs/game_confirm_dialog.dart';
import 'package:expansion/presentation/widgets/maps/campaign_epilogue_overlay.dart';
import 'package:expansion/presentation/widgets/maps/campaign_map_grid.dart';
import 'package:expansion/presentation/widgets/maps/campaign_map_sectors_view.dart';
import 'package:expansion/presentation/widgets/layout/game_menu_backdrop.dart';
import 'package:expansion/presentation/widgets/monetization/game_banner_ad_slot.dart';

/// Карта кампании Classic.
class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  bool _mapTutorialChecked = false;
  bool _epilogueChecked = false;
  bool _epilogueVisible = false;
  String? _epilogueText;

  @override
  void initState() {
    super.initState();
    _reloadMaps();
  }

  @override
  void activate() {
    super.activate();
    _reloadMaps();
  }

  void _reloadMaps() {
    sl<MapsCubit>().load();
  }

  Future<void> _maybeShowCampaignEpilogue(int missionCount) async {
    if (_epilogueChecked) return;
    _epilogueChecked = true;
    final guest = await sl<GuestProfileRepository>().load();
    if (!CampaignProgress.shouldShowEpilogue(guest, missionCount)) return;
    if (!mounted) return;
    final loc = AppLocalizations.of(context)!;
    setState(() {
      _epilogueVisible = true;
      _epilogueText = loc.campaignEpilogueText(missionCount);
    });
  }

  Future<void> _dismissCampaignEpilogue(int missionCount) async {
    await sl<GuestProfileRepository>().markCampaignEpilogueSeen(missionCount);
    if (!mounted) return;
    setState(() => _epilogueVisible = false);
  }

  Future<void> _maybeShowMapTutorial() async {
    if (_mapTutorialChecked) return;
    _mapTutorialChecked = true;
    final guest = await sl<GuestProfileRepository>().load();
    if (!guest.firstBattleCompleted || guest.mapTutorialSeen) return;
    if (!mounted) return;
    final loc = AppLocalizations.of(context)!;
    await showGameConfirmDialog(
      context,
      title: loc.mapTutorialTitle,
      message: loc.mapTutorialBody,
      confirmLabel: loc.mapTutorialDismiss,
    );
    await sl<GuestProfileRepository>().markMapTutorialSeen();
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
          const GameMenuBackdrop(),
          GameMenuTheme(
            child: BlocBuilder<MapsCubit, MapsState>(
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
                Builder(
                  builder: (context) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final missionCount = state.scenes.length;
                      _maybeShowCampaignEpilogue(missionCount).then((_) {
                        if (!mounted || _epilogueVisible) return;
                        _maybeShowMapTutorial();
                      });
                    });
                    return Expanded(
                      child: CampaignMapSectorsView(
                        scenes: state.scenes,
                        currentMissionId: state.currentMissionId,
                        selectedSceneId: state.selectedSceneId,
                        resolveTitle: (s) => _sceneTitle(s, loc),
                        onSceneTap: (scene) =>
                            sl<MapsCubit>().selectScene(scene.id),
                      ),
                    );
                  },
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
              const GameBannerAdSlot(),
            ],
          );
        },
      ),
          ),
          if (_epilogueVisible && _epilogueText != null)
            Positioned.fill(
              child: CampaignEpilogueOverlay(
                text: _epilogueText!,
                onDismiss: () {
                  final count = sl<MapsCubit>().state.scenes.length;
                  _dismissCampaignEpilogue(count);
                },
              ),
            ),
        ],
      ),
    );
  }
}
