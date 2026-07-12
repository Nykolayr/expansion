import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/constants/game_assets.dart';
import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/leaderboard/leaderboard_cubit.dart';
import 'package:expansion/presentation/bloc/leaderboard/leaderboard_state.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';
import 'package:expansion/presentation/widgets/layout/game_sticky_bottom_bar.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => sl<LeaderboardCubit>()..load(),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(GameAssets.splashBackground, fit: BoxFit.cover),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GameScreenBackBar(title: loc.leaderboardTitle),
                Expanded(
                  child: BlocBuilder<LeaderboardCubit, LeaderboardState>(
                    builder: (context, state) {
                      if (state.status == LeaderboardStatus.loading ||
                          state.status == LeaderboardStatus.initial) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.status == LeaderboardStatus.failure) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              state.errorMessage ?? loc.leaderboardLoadFailed,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      final guestPad = !state.isLoggedIn
                          ? GameStickyBottomBar.scrollPadding(context)
                          : 8.0;

                      return Stack(
                        children: [
                          state.entries.isEmpty
                              ? Center(child: Text(loc.leaderboardEmpty))
                              : ListView.separated(
                                  padding: EdgeInsets.fromLTRB(
                                    16,
                                    8,
                                    16,
                                    guestPad,
                                  ),
                                  itemCount: state.entries.length,
                                  separatorBuilder: (_, _) =>
                                      const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final entry = state.entries[index];
                                    return ListTile(
                                      leading: SizedBox(
                                        width: 36,
                                        child: Text(
                                          '${entry.rank}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                      title: Text(entry.label),
                                      subtitle: Text(
                                        loc.leaderboardMission(
                                          entry.mapClassic,
                                        ),
                                      ),
                                      trailing: Text(
                                        '${entry.scoreClassic}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    );
                                  },
                                ),
                          if (!state.isLoggedIn)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: GameStickyBottomBar(
                                child: _GuestLeaderboardBanner(
                                  onRegister: () => context.goToAuthRegister(),
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
      ),
    );
  }
}

class _GuestLeaderboardBanner extends StatelessWidget {
  const _GuestLeaderboardBanner({required this.onRegister});

  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          loc.leaderboardGuestHint,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Gap(12),
        Center(
          child: GameLongButton(
            label: loc.profileRegister,
            fontSize: 16,
            onPressed: onRegister,
          ),
        ),
      ],
    );
  }
}
