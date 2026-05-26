import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:expansion/core/constants/game_assets.dart';
import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/game_core/battle/battle_engine.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/battle/battle_cubit.dart';
import 'package:expansion/presentation/bloc/battle/battle_state.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/battle/battle_field_grid.dart';

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
    final id = widget.sceneId ??
        (GoRouterState.of(context).extra is int
            ? GoRouterState.of(context).extra! as int
            : 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<BattleCubit>().loadMission(id);
    });
  }

  @override
  void dispose() {
    sl<BattleCubit>().disposeBattle();
    super.dispose();
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

    if (won) {
      await sl<BattleCubit>().completeAfterVictory();
    }

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(won ? loc.battleVictoryTitle : loc.battleDefeatTitle),
        content: Text(won ? loc.battleVictoryBody : loc.battleDefeatBody),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (won) {
                context.goToMaps();
              } else {
                context.pop();
              }
            },
            child: Text(loc.battleContinue),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(GameAssets.splashBackground, fit: BoxFit.cover),
          BlocConsumer<BattleCubit, BattleState>(
            bloc: sl<BattleCubit>(),
            listenWhen: (prev, next) =>
                prev.status != BattleStatus.ended &&
                next.status == BattleStatus.ended &&
                next.outcome != null,
            listener: (context, state) {
              _onOutcomeDialog(state.outcome!);
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GameScreenBackBar(
                    title: '${loc.battleTitle} · ${state.sceneId}',
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
                      ),
                    ),
                    const Gap(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        loc.battleTapHint,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: ExpansionColors.grey),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: BattleFieldGrid(
                          snapshot: state.snapshot!,
                          selectedBaseId: state.selectedBaseId,
                          onCellTap: sl<BattleCubit>().tapCell,
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
