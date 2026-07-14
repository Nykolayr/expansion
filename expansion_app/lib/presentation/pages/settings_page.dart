import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/audio/game_audio_service.dart';
import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/extensions/game_difficulty_l10n.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/enums/game_difficulty.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/settings/app_locale_cubit.dart';
import 'package:expansion/presentation/bloc/settings/game_difficulty_cubit.dart';
import 'package:expansion/presentation/bloc/splash/splash_cubit.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/dialogs/game_feedback_dialog.dart';
import 'package:expansion/presentation/widgets/forms/difficulty_option_tile.dart';
import 'package:expansion/presentation/widgets/layout/game_menu_backdrop.dart';
import 'package:expansion/presentation/widgets/monetization/game_banner_ad_slot.dart';

/// Настройки (язык, звук, справка).
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _soundEnabled = true;

  @override
  void initState() {
    super.initState();
    _soundEnabled = sl<GameAudioService>().soundEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const GameMenuBackdrop(),
          GameMenuTheme(
            child: Column(
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
                              const Divider(height: 1),
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
                              const Divider(height: 1),
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
                      child: SwitchListTile(
                        secondary: const Icon(
                          Icons.volume_up_outlined,
                          color: ExpansionColors.accent,
                        ),
                        title: Text(loc.settingsSound),
                        subtitle: Text(
                          loc.settingsSoundHint,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ExpansionColors.grey,
                          ),
                        ),
                        value: _soundEnabled,
                        onChanged: (value) async {
                          await sl<GameAudioService>().setSoundEnabled(value);
                          setState(() => _soundEnabled = value);
                        },
                      ),
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
                          Icons.favorite_outline,
                          color: ExpansionColors.accent,
                        ),
                        title: Text(loc.settingsDonate),
                        subtitle: Text(
                          loc.settingsDonateHint,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ExpansionColors.grey,
                          ),
                        ),
                        onTap: () => context.goToDonate(),
                      ),
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
                          Icons.chat_bubble_outline,
                          color: ExpansionColors.accent,
                        ),
                        title: Text(loc.settingsFeedback),
                        subtitle: Text(
                          loc.settingsFeedbackHint,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ExpansionColors.grey,
                          ),
                        ),
                        onTap: () => showGameFeedbackDialog(context),
                      ),
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
                          Icons.help_outline,
                          color: ExpansionColors.accent,
                        ),
                        title: Text(loc.settingsHelp),
                        onTap: () => context.goToHelp(),
                      ),
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
                        onTap: () async {
                          await sl<SplashCubit>().requestIntroReplay();
                          if (!context.mounted) return;
                          context.goToSplash();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const GameBannerAdSlot(),
            ],
          ),
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 12, 6),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            if (selected)
              const Icon(Icons.check_circle, color: ExpansionColors.accent),
          ],
        ),
      ),
    );
  }
}
