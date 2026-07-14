import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/layout/game_menu_backdrop.dart';
import 'package:expansion/presentation/widgets/splash/splash_pretext_typer.dart';

/// Отдельный экран вступительной истории (из настроек).
class IntroStoryPage extends StatelessWidget {
  const IntroStoryPage({super.key});

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
                GameScreenBackBar(title: loc.introStoryTitle),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Card(
                    color: ExpansionColors.background.withValues(alpha: 0.94),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: ExpansionColors.accent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SplashPretextTyper(
                        text: loc.splashPretext,
                        stepDuration: const Duration(milliseconds: 24),
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(16),
            ],
          ),
          ),
        ],
      ),
    );
  }
}
