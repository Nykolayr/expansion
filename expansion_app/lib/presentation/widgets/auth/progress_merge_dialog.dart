import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';
import 'package:expansion/domain/entities/guest_profile.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/services/auth_post_login_service.dart';
import 'package:expansion/presentation/widgets/buttons/game_compact_skew_button.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';

class ProgressMergeDialog extends StatelessWidget {
  const ProgressMergeDialog({
    required this.local,
    required this.server,
    super.key,
  });

  final GuestProfile local;
  final GuestProfile server;

  static Future<ProgressMergeChoice?> show(
    BuildContext context, {
    required GuestProfile local,
    required GuestProfile server,
  }) {
    return showDialog<ProgressMergeChoice>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) => ProgressMergeDialog(local: local, server: server),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 10,
        color: ExpansionColors.background.withValues(alpha: 0.96),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: ExpansionColors.accent, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                loc.authMergeTitle,
                textAlign: TextAlign.center,
                style: ExpansionTextStyles.bodyAccent(context, 20),
              ),
              const Gap(12),
              Text(
                loc.authMergeBody,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Gap(16),
              _MergeCard(
                title: loc.authMergeLocal,
                mission: local.mapClassic,
                score: local.scoreClassic,
                onTap: () =>
                    Navigator.of(context).pop(ProgressMergeChoice.keepLocal),
              ),
              const Gap(12),
              _MergeCard(
                title: loc.authMergeServer,
                mission: server.mapClassic,
                score: server.scoreClassic,
                onTap: () =>
                    Navigator.of(context).pop(ProgressMergeChoice.keepServer),
              ),
              const Gap(16),
              Center(
                child: GameCompactSkewButton(
                  label: loc.beginResetCancel,
                  fullWidth: true,
                  fontSize: 15,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MergeCard extends StatelessWidget {
  const _MergeCard({
    required this.title,
    required this.mission,
    required this.score,
    required this.onTap,
  });

  final String title;
  final int mission;
  final int score;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const Gap(8),
          Text(loc.authMergeMissionScore(mission, score)),
          const Gap(12),
          Center(
            child: GameLongButton(
              label: title,
              fontSize: 16,
              onPressed: onTap,
            ),
          ),
        ],
      ),
    );
  }
}
