import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/constants/game_assets.dart';
import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/extensions/game_difficulty_l10n.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/enums/game_difficulty.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/settings/app_locale_cubit.dart';
import 'package:expansion/presentation/bloc/settings/game_difficulty_cubit.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/forms/difficulty_option_tile.dart';

/// Настройки (язык, вступление; звук — позже).
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(GameAssets.splashBackground, fit: BoxFit.cover),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GameScreenBackBar(title: loc.settingsTitle),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  children: [
                    Text(
                      loc.settingsSectionGeneral,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: ExpansionColors.accent,
                      ),
                    ),
                    const Gap(12),
                    BlocBuilder<AppLocaleCubit, Locale>(
                      bloc: sl<AppLocaleCubit>(),
                      builder: (context, locale) {
                        return Card(
                          color: ExpansionColors.background.withValues(
                            alpha: 0.92,
                          ),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: ExpansionColors.accent,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.language,
                                  color: ExpansionColors.accent,
                                ),
                                title: Text(loc.settingsLanguage),
                                subtitle: Text(loc.settingsLanguageHint),
                              ),
                              _LanguageTile(
                                label: loc.settingsLanguageRu,
                                selected: locale.languageCode == 'ru',
                                onTap: () => sl<AppLocaleCubit>()
                                    .setLocale(const Locale('ru')),
                              ),
                              _LanguageTile(
                                label: loc.settingsLanguageEn,
                                selected: locale.languageCode == 'en',
                                onTap: () => sl<AppLocaleCubit>()
                                    .setLocale(const Locale('en')),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Gap(16),
                    BlocBuilder<GameDifficultyCubit, GameDifficulty>(
                      bloc: sl<GameDifficultyCubit>(),
                      builder: (context, difficulty) {
                        return Card(
                          color: ExpansionColors.background.withValues(
                            alpha: 0.92,
                          ),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: ExpansionColors.accent,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.tune,
                                  color: ExpansionColors.accent,
                                ),
                                title: Text(loc.settingsDifficulty),
                                subtitle: Text(loc.settingsDifficultyHint),
                              ),
                              for (final level in GameDifficulty.values)
                                DifficultyOptionTile(
                                  embedded: true,
                                  label: level.label(loc),
                                  selected: difficulty == level,
                                  onTap: () => sl<GameDifficultyCubit>()
                                      .setDifficulty(level),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Gap(16),
                    Card(
                      color: ExpansionColors.background.withValues(alpha: 0.92),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: ExpansionColors.accent,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.auto_stories_outlined,
                          color: ExpansionColors.accent,
                        ),
                        title: Text(loc.settingsReplayIntro),
                        subtitle: Text(
                          loc.settingsReplayIntroHint,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ExpansionColors.grey,
                          ),
                        ),
                        onTap: () => context.goToIntroStory(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: selected
          ? const Icon(Icons.check_circle, color: ExpansionColors.accent)
          : null,
      onTap: onTap,
    );
  }
}
