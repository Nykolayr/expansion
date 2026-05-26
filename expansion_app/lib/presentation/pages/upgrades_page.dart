import 'package:flutter/material.dart';

import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/layout/game_screen_scaffold.dart';

/// Мета-апгрейды между миссиями (скелет, фаза 4).
class UpgradesPage extends StatelessWidget {
  const UpgradesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GameScreenScaffold(
      title: loc.upgradesTitle,
      placeholderMessage: loc.screenPlaceholderBody,
    );
  }
}
