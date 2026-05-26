import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/layout/game_screen_scaffold.dart';

/// Бой (фаза 3 — геймплей). Пока принимает [sceneId] из маршрута.
class BattlePage extends StatelessWidget {
  const BattlePage({super.key, this.sceneId});

  final int? sceneId;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final id = sceneId ??
        (GoRouterState.of(context).extra is int
            ? GoRouterState.of(context).extra! as int
            : null);

    final message = id == null
        ? loc.screenPlaceholderBody
        : loc.battleScenePlaceholder(id);

    return GameScreenScaffold(
      title: loc.battleTitle,
      placeholderMessage: message,
    );
  }
}
