import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/constants/game_assets.dart';
import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/ui/app_feedback_kind.dart';
import 'package:expansion/core/ui/app_feedback_service.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/upgrades/upgrades_cubit.dart';
import 'package:expansion/presentation/bloc/upgrades/upgrades_state.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/upgrades/meta_upgrade_tile.dart';

class UpgradesPage extends StatefulWidget {
  const UpgradesPage({super.key});

  @override
  State<UpgradesPage> createState() => _UpgradesPageState();
}

class _UpgradesPageState extends State<UpgradesPage> {
  @override
  void initState() {
    super.initState();
    sl<UpgradesCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(GameAssets.splashBackground, fit: BoxFit.cover),
          BlocConsumer<UpgradesCubit, UpgradesState>(
            bloc: sl<UpgradesCubit>(),
            listenWhen: (p, c) => p.messageKey != c.messageKey && c.messageKey != null,
            listener: (context, state) {
              final text = switch (state.messageKey) {
                'success' => loc.metaUpgradePurchased,
                'notEnough' => loc.metaUpgradeNotEnough,
                _ => '',
              };
              if (text.isEmpty) return;
              sl<AppFeedbackService>().show(
                text,
                kind: state.messageKey == 'success'
                    ? AppFeedbackKind.success
                    : AppFeedbackKind.warning,
              );
            },
            builder: (context, state) {
              final profile = state.profile;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GameScreenBackBar(title: loc.upgradesTitle),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      loc.metaUpgradeScore(state.score),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ExpansionColors.accent,
                          ),
                    ),
                  ),
                  const Gap(8),
                  if (profile == null)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: profile.meta.slots.length,
                        separatorBuilder: (_, _) => const Gap(8),
                        itemBuilder: (context, index) {
                          final slot = profile.meta.slots[index];
                          return MetaUpgradeTile(
                            slot: slot,
                            score: profile.scoreClassic,
                            onUpgrade: () =>
                                sl<UpgradesCubit>().purchase(slot.type),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
