import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/domain/entities/guest_profile.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/services/auth_post_login_service.dart';

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
      builder: (_) => ProgressMergeDialog(local: local, server: server),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(loc.authMergeTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(loc.authMergeBody),
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
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(loc.beginResetCancel),
        ),
      ],
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

    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.centerLeft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const Gap(8),
          Text(loc.authMergeMissionScore(mission, score)),
        ],
      ),
    );
  }
}
