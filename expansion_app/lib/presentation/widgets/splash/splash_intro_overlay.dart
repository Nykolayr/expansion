import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/splash/splash_cubit.dart';
import 'package:expansion/presentation/widgets/splash/splash_pretext_typer.dart';

/// Полноэкранное вступление — не внизу под заголовком, чтобы его было видно.
class SplashIntroOverlay extends StatelessWidget {
  const SplashIntroOverlay({
    required this.onSkip,
    super.key,
  });

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Material(
      color: Colors.black.withValues(alpha: 0.72),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                loc.introStoryTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: ExpansionColors.accent,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const Gap(12),
              Expanded(
                child: Card(
                  elevation: 12,
                  color: ExpansionColors.background.withValues(alpha: 0.98),
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
                      onProgress: sl<SplashCubit>().onTypingProgress,
                      onComplete: sl<SplashCubit>().markIntroTypingComplete,
                    ),
                  ),
                ),
              ),
              const Gap(8),
              TextButton(
                onPressed: onSkip,
                style: TextButton.styleFrom(
                  foregroundColor: ExpansionColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  loc.battleTutorialSkip,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ExpansionColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
