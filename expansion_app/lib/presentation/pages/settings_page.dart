import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/constants/game_assets.dart';
import 'package:expansion/core/extensions/navigation_context.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';

/// Настройки (пока минимальный набор; расширять по мере переноса legacy).
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
          Image.asset(
            GameAssets.splashBackground,
            fit: BoxFit.cover,
          ),
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
                        title: Text(
                          loc.settingsReplayIntro,
                          style: theme.textTheme.bodyLarge,
                        ),
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
