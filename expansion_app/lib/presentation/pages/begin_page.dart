import 'package:flutter/material.dart';

import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/layout/game_screen_scaffold.dart';

/// Новая игра: сложность и вселенная (скелет, фаза 4).
class BeginPage extends StatelessWidget {
  const BeginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GameScreenScaffold(
      title: loc.beginTitle,
      placeholderMessage: loc.screenPlaceholderBody,
    );
  }
}
