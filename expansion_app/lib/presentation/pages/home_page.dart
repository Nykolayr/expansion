import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/l10n/app_localizations.dart';

/// Заглушка до переноса splash/карт/боя из legacy.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.rocket_launch_outlined,
                  size: 72,
                  color: ExpansionColors.accent,
                ),
                const Gap(24),
                Text(
                  loc.homeTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: ExpansionColors.accent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(16),
                Text(
                  loc.homeMessage,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
