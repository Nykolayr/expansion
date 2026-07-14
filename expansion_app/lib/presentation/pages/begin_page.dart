import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/core/extensions/univer_kind_l10n.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/enums/game_difficulty.dart';
import 'package:expansion/domain/enums/univer_kind.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/begin/begin_cubit.dart';
import 'package:expansion/presentation/bloc/begin/begin_state.dart';
import 'package:expansion/presentation/bloc/settings/game_difficulty_cubit.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';
import 'package:expansion/presentation/widgets/dialogs/game_confirm_dialog.dart';
import 'package:expansion/presentation/widgets/forms/difficulty_option_tile.dart';
import 'package:expansion/presentation/widgets/layout/game_menu_backdrop.dart';

class BeginPage extends StatefulWidget {
  const BeginPage({super.key});

  @override
  State<BeginPage> createState() => _BeginPageState();
}

class _BeginPageState extends State<BeginPage> {
  @override
  void initState() {
    super.initState();
    sl<BeginCubit>().load();
  }

  Future<void> _onStart() async {
    final guest = await sl<GuestProfileRepository>().load();
    if (!mounted) return;

    if (guest.hasCampaignProgress) {
      final loc = AppLocalizations.of(context)!;
      final confirmed = await showGameConfirmDialog(
        context,
        title: loc.beginResetConfirmTitle,
        message: loc.beginResetConfirmBody,
        confirmLabel: loc.beginResetConfirm,
        cancelLabel: loc.beginResetCancel,
      );
      if (!confirmed || !mounted) return;
    }

    final cubit = sl<BeginCubit>();
    await cubit.startNewCampaign();
    await sl<GameDifficultyCubit>().load();
    if (!mounted) return;
    context.replaceWithBattle(sceneId: 1);
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
            child: BlocBuilder<BeginCubit, BeginState>(
            bloc: sl<BeginCubit>(),
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GameScreenBackBar(title: loc.beginTitle),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        Text(
                          loc.beginUniverHint,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Gap(12),
                        for (final kind in UniverKind.values)
                          _UniverTile(
                            label: kind.label(loc),
                            subtitle: kind.hint(loc),
                            selected: state.univerKind == kind,
                            enabled: kind.isPlayable,
                            onTap: () => sl<BeginCubit>().selectUniver(kind),
                          ),
                        const Gap(24),
                        Text(
                          loc.beginDifficultyHint,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Gap(8),
                        DifficultyOptionTile(
                          label: loc.beginDifficultyEasy,
                          selected: state.difficulty == GameDifficulty.easy,
                          onTap: () => sl<BeginCubit>()
                              .selectDifficulty(GameDifficulty.easy),
                        ),
                        DifficultyOptionTile(
                          label: loc.beginDifficultyAverage,
                          selected:
                              state.difficulty == GameDifficulty.average,
                          onTap: () => sl<BeginCubit>()
                              .selectDifficulty(GameDifficulty.average),
                        ),
                        DifficultyOptionTile(
                          label: loc.beginDifficultyHard,
                          selected:
                              state.difficulty == GameDifficulty.difficult,
                          onTap: () => sl<BeginCubit>()
                              .selectDifficulty(GameDifficulty.difficult),
                        ),
                        const Gap(24),
                        GameLongButton(
                          label: loc.beginStartMission,
                          onPressed: state.isSaving ? null : _onStart,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          ),
        ],
      ),
    );
  }
}

class _UniverTile extends StatelessWidget {
  const _UniverTile({
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        color: ExpansionColors.background.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: selected ? ExpansionColors.accent : ExpansionColors.grey,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          enabled: enabled,
          title: Text(label),
          subtitle: Text(subtitle),
          trailing: selected
              ? const Icon(Icons.check_circle, color: ExpansionColors.accent)
              : null,
          onTap: enabled ? onTap : null,
        ),
      ),
    );
  }
}
