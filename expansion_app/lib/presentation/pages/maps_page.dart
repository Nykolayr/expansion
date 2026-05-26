import 'package:flutter/material.dart';

import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/layout/game_screen_scaffold.dart';

/// Карта кампании (скелет, фаза 2 — контент из локальной БД).
class MapsPage extends StatelessWidget {
  const MapsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GameScreenScaffold(
      title: loc.mapsTitle,
      placeholderMessage: loc.screenPlaceholderBody,
    );
  }
}
