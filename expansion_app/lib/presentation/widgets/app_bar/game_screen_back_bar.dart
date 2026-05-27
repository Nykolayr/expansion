import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:expansion/core/themes/expansion_text_styles.dart';

/// Верхняя панель с «назад» на игровых экранах (legacy `appButtonBack`).
class GameScreenBackBar extends StatelessWidget {
  const GameScreenBackBar({
    required this.title,
    this.onBack,
    super.key,
  });

  final String title;

  /// Если null — [context.pop].
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              color: Theme.of(context).colorScheme.primary,
              onPressed: onBack ?? () => context.pop(),
            ),
            Expanded(
              child: Text(
                title,
                style: ExpansionTextStyles.titleAccent(context, 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
