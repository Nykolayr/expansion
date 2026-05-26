import 'package:flutter/material.dart';

import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/layout/game_screen_scaffold.dart';

/// Профиль игрока (скелет, фаза 5).
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GameScreenScaffold(
      title: loc.profileTitle,
      placeholderMessage: loc.screenPlaceholderBody,
    );
  }
}
