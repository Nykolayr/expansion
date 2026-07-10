import 'package:flutter/material.dart';

import 'package:expansion/core/themes/expansion_colors.dart';

/// Карточка статистики (прогресс, профиль и т.п.).
class GameStatCard extends StatelessWidget {
  const GameStatCard({
    required this.title,
    required this.value,
    super.key,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ExpansionColors.background.withValues(alpha: 0.92),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: ExpansionColors.accent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: ExpansionColors.accent,
              ),
        ),
      ),
    );
  }
}
