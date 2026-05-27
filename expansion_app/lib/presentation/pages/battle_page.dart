import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/constants/game_assets.dart';
import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/game_core/battle/battle_engine.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/battle/battle_cubit.dart';
import 'package:expansion/presentation/bloc/battle/battle_state.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/battle/battle_base_overlay_panel.dart';
import 'package:expansion/presentation/widgets/battle/battle_field_grid.dart';
import 'package:expansion/presentation/widgets/battle/battle_tactical_panel.dart';
import 'package:expansion/presentation/widgets/dialogs/battle_outcome_dialog.dart';

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

  Future<void> _onOutcomeDialog(BattleOutcome outcome) async {
    final loc = AppLocalizations.of(context)!;
    final won = outcome == BattleOutcome.playerWin;

    var reward = 0;
    if (won) {
      reward = await sl<BattleCubit>().completeAfterVictory();
    }

    if (!mounted) return;

    await showBattleOutcomeDialog(
      context,
      won: won,
      title: won ? loc.battleVictoryTitle : loc.battleDefeatTitle,
      body: won
          ? loc.battleVictoryBodyWithScore(reward)
          : loc.battleDefeatBody,
      continueLabel: loc.battleContinue,
      onContinue: () {
        context.goToMaps();
      },
    );
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
                    onBack: () => context.goToMaps(),
                  ),
                  if (state.status == BattleStatus.loading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.status == BattleStatus.failure)
                    Expanded(
                      child: Center(
                        child: Text(
                          state.errorMessage ?? loc.mapsLoadFailed,
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
                          clipBehavior: Clip.none,
                          children: [
                            Positioned.fill(
                              child: BattleFieldGrid(
                                snapshot: state.snapshot!,
                                selectedBaseId: state.selectedBaseId,
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
                            ),
                            if (selectedBase != null)
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 0,
                                child: BattleBaseOverlayPanel(
                                  onClose: cubit.clearBaseSelection,
                                  child: BattleTacticalPanel(
                                    base: selectedBase,
                                    projectilesActive:
                                        state.snapshot!.hasActiveProjectiles,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(8),
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
