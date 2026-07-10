import 'package:flutter/material.dart';

import 'package:expansion/core/themes/expansion_colors.dart';

/// Выбор уровня сложности (вступление, настройки).
class DifficultyOptionTile extends StatelessWidget {
  const DifficultyOptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
    this.embedded = false,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Внутри общей карточки (настройки) — без собственного Card.
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      title: Text(label),
      trailing: selected
          ? const Icon(Icons.check_circle, color: ExpansionColors.accent)
          : null,
      onTap: onTap,
    );

    if (embedded) return tile;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        color: ExpansionColors.background.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: selected ? ExpansionColors.accent : ExpansionColors.grey,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: tile,
      ),
    );
  }
}
