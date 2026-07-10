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
    if (embedded) {
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 12, 6),
          child: Row(
            children: [
              Expanded(child: Text(label)),
              if (selected)
                const Icon(Icons.check_circle, color: ExpansionColors.accent),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Card(
        color: ExpansionColors.background.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: selected ? ExpansionColors.accent : ExpansionColors.grey,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
            child: Row(
              children: [
                Expanded(child: Text(label)),
                if (selected)
                  const Icon(Icons.check_circle, color: ExpansionColors.accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
