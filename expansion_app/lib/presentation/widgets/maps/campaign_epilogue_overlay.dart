import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';
import 'package:expansion/presentation/widgets/splash/splash_pretext_typer.dart';

/// Эпилог кампании — печать текста как во вступлении на splash.
class CampaignEpilogueOverlay extends StatelessWidget {
  const CampaignEpilogueOverlay({
    required this.text,
    required this.onDismiss,
    super.key,
  });

  final String text;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Material(
      color: Colors.black.withValues(alpha: 0.78),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                loc.campaignEpilogueTitle,
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
                      text: text,
                      stepDuration: const Duration(milliseconds: 22),
                    ),
                  ),
                ),
              ),
              const Gap(8),
              GameLongButton(
                label: loc.campaignEpilogueDismiss,
                fontSize: 16,
                onPressed: onDismiss,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
