import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/constants/campaign_difficulty_policy.dart';
import 'package:expansion/core/constants/game_assets.dart';
import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/core/audio/game_audio_service.dart';
import 'package:expansion/core/ui/game_haptic.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/domain/enums/game_difficulty.dart';
import 'package:expansion/game_core/battle/battle_victory_reward.dart';
import 'package:expansion/game_core/battle/battle_engine.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/battle/battle_cubit.dart';
import 'package:expansion/presentation/bloc/battle/battle_state.dart';
import 'package:expansion/presentation/bloc/maps/maps_cubit.dart';
import 'package:expansion/presentation/bloc/settings/game_difficulty_cubit.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/battle/battle_field_grid.dart';
import 'package:expansion/presentation/widgets/battle/battle_mission_tutorial.dart';
import 'package:expansion/presentation/widgets/battle/battle_tutorial_drag_hint.dart';
import 'package:expansion/presentation/widgets/battle/battle_meteorite_tutorial.dart';
import 'package:expansion/presentation/widgets/battle/battle_tactical_bar.dart';
import 'package:expansion/presentation/widgets/dialogs/battle_outcome_dialog.dart';
import 'package:expansion/presentation/widgets/dialogs/battle_pause_menu_dialog.dart';

class BattlePage extends StatefulWidget {
  const BattlePage({super.key, this.sceneId});

  final int? sceneId;

  @override
  State<BattlePage> createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  @override
  void initState() {
    super.initState();
    final id = widget.sceneId ?? 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      sl<BattleCubit>().loadMission(id);
    });
  }

  @override
  void dispose() {
    sl<BattleCubit>().disposeBattle();
    super.dispose();
  }

  BattleBase? _selectedPlayerBase(BattleState state) {
    final id = state.selectedBaseId;
    if (id == null || state.snapshot == null) return null;
    final base = state.snapshot!.baseById(id);
    if (base == null || base.side != BattleSide.player) return null;
    return base;
  }

  String _briefing(BattleState state, AppLocalizations loc) {
    final code = Localizations.localeOf(context).languageCode;
    final text = code == 'ru' ? state.briefingRu : state.briefingEn;
    if (text.trim().isNotEmpty) return text;
    return loc.battleBriefingFallback;
  }

  String _battleErrorText(BattleState state, AppLocalizations loc) {
    if (state.errorKey == BattleErrorKey.layoutNotFound) {
      return loc.battleLayoutNotFound;
    }
    return state.errorMessage ?? loc.mapsLoadFailed;
  }

  Future<void> _onOutcomeDialog(BattleOutcome outcome) async {
    final loc = AppLocalizations.of(context)!;
    final won = outcome == BattleOutcome.playerWin;
    final cubit = sl<BattleCubit>();
    final difficultyCubit = sl<GameDifficultyCubit>();
    final sceneId = cubit.state.sceneId;

    BattleVictoryReward? reward;
    var defeatStreak = 0;
    if (won) {
      reward = await cubit.completeAfterVictory();
      await sl<GameAudioService>().playVictory();
      GameHaptic.success();
    } else {
      defeatStreak = await cubit.completeAfterDefeat();
      await sl<GameAudioService>().playDefeat();
      GameHaptic.warning();
    }

    if (!mounted) return;

    final guest = await sl<GuestProfileRepository>().load();
    final showLowerHint = !won &&
        defeatStreak >= CampaignDifficultyPolicy.defeatHintStreakThreshold &&
        difficultyCubit.state != GameDifficulty.easy;

    Future<void> goToMaps() async {
      await cubit.disposeBattle();
      await sl<MapsCubit>().load();
      if (!mounted) return;
      context.goToMaps();
    }

    final nextMissionId = sceneId + 1;
    final canNextMission =
        won && nextMissionId <= 40 && nextMissionId <= guest.mapClassic;
    final canUpgrades = won && guest.scoreClassic >= 180;

    final extraActions = <BattleOutcomeExtraAction>[
      if (canUpgrades)
        (
          label: loc.battleVictoryToUpgrades,
          onTap: () async {
            await cubit.disposeBattle();
            if (!mounted) return;
            context.goToUpgrades();
          },
        ),
      if (canNextMission)
        (
          label: loc.battleVictoryNextMission(nextMissionId),
          onTap: () async {
            await cubit.disposeBattle();
            if (!mounted) return;
            context.goToBattle(sceneId: nextMissionId);
          },
        ),
    ];

    if (!mounted) return;

    await showBattleOutcomeDialog(
      context,
      won: won,
      title: won ? loc.battleVictoryTitle : loc.battleDefeatTitle,
      body: won && reward != null
          ? '${loc.battleVictoryBody}\n\n${loc.battleVictoryRewardDetail(reward.basePoints, reward.missionBonus, reward.total)}'
          : showLowerHint
              ? loc.battleDefeatHintStreakBody
              : loc.battleDefeatBody,
      continueLabel: won ? loc.battleVictoryToMap : loc.battleContinue,
      onContinue: goToMaps,
      secondaryLabel: showLowerHint ? loc.battleLowerDifficulty : null,
      onSecondary: showLowerHint
          ? () async {
              await difficultyCubit.lowerDifficulty();
              await goToMaps();
            }
          : null,
      extraActions: extraActions,
    );
  }

  Future<void> _openPauseMenu() async {
    final cubit = sl<BattleCubit>();
    final state = cubit.state;
    if (!state.isPlaying || state.isPaused) return;

    await cubit.pauseBattle();
    if (!mounted) return;

    final action = await showBattlePauseMenuDialog(context);
    if (!mounted) return;

    switch (action) {
      case BattlePauseAction.continueGame:
        await cubit.resumeBattle();
      case BattlePauseAction.restart:
        await cubit.restartMission();
      case BattlePauseAction.exitToMain:
        await cubit.leaveBattle();
        if (mounted) context.goToSplash();
      case null:
        await cubit.resumeBattle();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = sl<BattleCubit>();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(GameAssets.splashBackground, fit: BoxFit.cover),
          BlocConsumer<BattleCubit, BattleState>(
            bloc: cubit,
            listenWhen: (prev, next) =>
                prev.status != BattleStatus.ended &&
                next.status == BattleStatus.ended &&
                next.outcome != null,
            listener: (context, state) {
              _onOutcomeDialog(state.outcome!);
            },
            builder: (context, state) {
              final selectedBase = _selectedPlayerBase(state);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GameScreenBackBar(
                    title: '${loc.battleTitle} · ${state.sceneId}',
                    onBack: () async {
                      await sl<MapsCubit>().load();
                      if (context.mounted) context.goToMaps();
                    },
                    trailing: state.isPlaying
                        ? IconButton(
                            icon: const Icon(Icons.pause_rounded),
                            color: ExpansionColors.accent,
                            tooltip: loc.battlePauseTitle,
                            onPressed:
                                state.isPaused ? null : _openPauseMenu,
                          )
                        : null,
                  ),
                  if (state.status == BattleStatus.loading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.status == BattleStatus.failure)
                    Expanded(
                      child: Center(
                        child: Text(
                          _battleErrorText(state, loc),
                          style: const TextStyle(color: ExpansionColors.accent),
                        ),
                      ),
                    )
                  else if (state.snapshot != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _briefing(state, loc),
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Gap(6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        loc.battleDragHint,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: ExpansionColors.grey),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Stack(
                          fit: StackFit.expand,
                          clipBehavior: Clip.none,
                          children: [
                            BattleFieldGrid(
                              snapshot: state.snapshot!,
                              selectedBaseId: state.selectedBaseId,
                              upgradableBaseIds: cubit.upgradablePlayerBaseIds(),
                              onPlayerBaseTap: (id) {
                                if (state.selectedBaseId == id) {
                                  cubit.clearBaseSelection();
                                } else {
                                  cubit.selectBase(id);
                                }
                              },
                              onDismissOverlay: selectedBase != null
                                  ? cubit.clearBaseSelection
                                  : null,
                              onDragStarted: cubit.clearBlockedCell,
                              onFleetDrag: cubit.sendFleetDrag,
                              blockedCellX: state.blockedCellX,
                              blockedCellY: state.blockedCellY,
                            ),
                            if (state.showMeteoriteTutorial)
                              BattleMeteoriteTutorial(
                                onDismiss: cubit.dismissMeteoriteTutorial,
                              ),
                            if (state.missionTutorialStep ==
                                    MissionTutorialStep.drag ||
                                state.missionTutorialStep ==
                                    MissionTutorialStep.captureHint)
                              IgnorePointer(
                                child: BattleTutorialDragHint(
                                  snapshot: state.snapshot!,
                                  step: state.missionTutorialStep,
                                  targetBaseId: state.tutorialTargetBaseId,
                                ),
                              ),
                            if (state.missionTutorialStep ==
                                MissionTutorialStep.goalOverlay)
                              Positioned.fill(
                                child: BattleMissionTutorial(
                                  step: state.missionTutorialStep,
                                  onSkip: cubit.skipMissionTutorial,
                                  onDismissUpgrade:
                                      cubit.dismissMissionTutorialUpgrade,
                                  onDismissGoal:
                                      cubit.dismissMissionTutorialGoal,
                                  prominent: true,
                                ),
                              )
                            else if (state.missionTutorialStep !=
                                MissionTutorialStep.none)
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: BattleMissionTutorial(
                                  step: state.missionTutorialStep,
                                  onSkip: cubit.skipMissionTutorial,
                                  onDismissUpgrade:
                                      cubit.dismissMissionTutorialUpgrade,
                                  onDismissGoal:
                                      cubit.dismissMissionTutorialGoal,
                                ),
                              ),
                            if (selectedBase != null && state.canInteract)
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: BattleTacticalBar(
                                  base: selectedBase,
                                  onClose: cubit.clearBaseSelection,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
