import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/l10n/app_localizations.dart';

/// Плашка на splash: скачаны новые миссии (OTA).
class NewMissionsBanner extends StatelessWidget {
  const NewMissionsBanner({
    required this.onOpenMaps,
    required this.onDismiss,
    super.key,
  });

  final VoidCallback onOpenMaps;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Material(
      elevation: 8,
      color: ExpansionColors.background.withValues(alpha: 0.94),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.newMissionsBannerTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ExpansionColors.accent,
                    ),
                textAlign: TextAlign.center,
              ),
              const Gap(6),
              Text(
                loc.newMissionsBannerBody,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Gap(12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDismiss,
                      child: Text(loc.newMissionsBannerDismiss),
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: FilledButton(
                      onPressed: onOpenMaps,
                      style: FilledButton.styleFrom(
                        backgroundColor: ExpansionColors.accent,
                        foregroundColor: ExpansionColors.black,
                      ),
                      child: Text(loc.newMissionsBannerAction),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
