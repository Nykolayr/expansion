import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/core/monetization/monetization_config.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/supporters/supporters_cubit.dart';
import 'package:expansion/presentation/bloc/supporters/supporters_state.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';
import 'package:expansion/presentation/widgets/layout/game_menu_backdrop.dart';
import 'package:expansion/presentation/widgets/layout/game_sticky_bottom_bar.dart';

class SupportersPage extends StatelessWidget {
  const SupportersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SupportersCubit>()..load(),
      child: const _SupportersView(),
    );
  }
}

class _SupportersView extends StatelessWidget {
  const _SupportersView();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const GameMenuBackdrop(),
          GameMenuTheme(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GameScreenBackBar(title: loc.supportersTitle),
                Expanded(
                  child: BlocBuilder<SupportersCubit, SupportersState>(
                    builder: (context, state) {
                      if (state.status == SupportersStatus.loading ||
                          state.status == SupportersStatus.initial) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.status == SupportersStatus.failure) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              state.errorMessage ?? loc.supportersLoadFailed,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      return Stack(
                        children: [
                          state.entries.isEmpty
                              ? Center(child: Text(loc.supportersEmpty))
                              : ListView.separated(
                                  padding: EdgeInsets.fromLTRB(
                                    16,
                                    8,
                                    16,
                                    GameStickyBottomBar.scrollPadding(
                                      context,
                                      extra: 72,
                                    ),
                                  ),
                                  itemCount: state.entries.length,
                                  separatorBuilder: (_, _) =>
                                      const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final entry = state.entries[index];
                                    final name =
                                        entry.label ?? loc.supportersAnonymous;
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
                                      title: Text(name),
                                      trailing: Text(
                                        MonetizationConfig.priceLabelRub(
                                          entry.totalRub,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    );
                                  },
                                ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: GameStickyBottomBar(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    loc.supportersDonateHint,
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const Gap(12),
                                  GameLongButton(
                                    label: loc.donateTitle,
                                    fontSize: 16,
                                    onPressed: () => context.goToDonate(),
                                  ),
                                ],
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
          ),
        ],
      ),
    );
  }
}
