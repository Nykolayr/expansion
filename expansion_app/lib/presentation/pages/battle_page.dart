import 'package:flutter/material.dart';

import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/layout/game_screen_scaffold.dart';

/// Бой (скелет, фаза 3).
class BattlePage extends StatelessWidget {
  const BattlePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GameScreenScaffold(
      title: loc.battleTitle,
      placeholderMessage: loc.screenPlaceholderBody,
    );
  }
}
