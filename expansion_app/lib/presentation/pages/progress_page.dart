import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/constants/game_assets.dart';
import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/extensions/game_difficulty_l10n.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/core/extensions/univer_kind_l10n.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/progress/progress_cubit.dart';
import 'package:expansion/presentation/bloc/progress/progress_state.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';
import 'package:expansion/presentation/widgets/cards/game_stat_card.dart';
import 'package:expansion/presentation/widgets/layout/game_sticky_bottom_bar.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  void initState() {
    super.initState();
    sl<ProgressCubit>().load();
  }

  @override
  void activate() {
    super.activate();
    sl<ProgressCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(GameAssets.splashBackground, fit: BoxFit.cover),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GameScreenBackBar(title: loc.progressTitle),
              Expanded(
                child: BlocBuilder<ProgressCubit, ProgressState>(
                  bloc: sl<ProgressCubit>(),
                  builder: (context, state) {
                    if (state.status == ProgressStatus.loading ||
                        state.status == ProgressStatus.initial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.status == ProgressStatus.failure) {
                      return Center(
                        child: Text(
                          loc.mapsLoadFailed,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    return Stack(
                      children: [
                        ListView(
                          padding: EdgeInsets.fromLTRB(
                            24,
                            24,
                            24,
                            GameStickyBottomBar.scrollPadding(context),
                          ),
                          children: [
                            GameStatCard(
                              title: loc.progressCurrentMission,
                              value: '${state.currentMission} / 40',
                            ),
                            const Gap(12),
                            GameStatCard(
                              title: loc.progressUniver,
                              value: state.univer.label(loc),
                            ),
                            const Gap(12),
                            GameStatCard(
                              title: loc.progressDifficulty,
                              value: state.difficulty.label(loc),
                            ),
                            const Gap(12),
                            GameStatCard(
                              title: loc.progressCompleted,
                              value: '${state.completedMissions}',
                            ),
                            const Gap(12),
                            GameStatCard(
                              title: loc.progressScore,
                              value: '${state.score}',
                            ),
                            const Gap(12),
                            GameStatCard(
                              title: loc.progressEnemyPower,
                              value: '${state.enemyPower}',
                            ),
                          ],
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: GameStickyBottomBar(
                            child: Center(
                              child: GameLongButton(
                                label: loc.progressLeaderboard,
                                onPressed: () => context.goToLeaderboard(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
