import 'package:flutter/material.dart';

import 'package:expansion/core/themes/expansion_colors.dart';

/// Кнопка паузы — иконка в тонкой жёлтой окружности (без заливки).
class BattlePauseButton extends StatelessWidget {
  const BattlePauseButton({
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final String tooltip;
  final VoidCallback? onPressed;

  static const double _size = 40;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: _size,
        minHeight: _size,
      ),
      icon: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: ExpansionColors.accent,
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.pause_rounded,
          color: ExpansionColors.accent,
          size: 24,
        ),
      ),
    );
  }
}
