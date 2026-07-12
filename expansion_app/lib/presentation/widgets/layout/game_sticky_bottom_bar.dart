import 'package:flutter/material.dart';

import 'package:expansion/core/themes/expansion_colors.dart';

/// Панель действий поверх экрана — всегда доступна при скролле.
class GameStickyBottomBar extends StatelessWidget {
  const GameStickyBottomBar({
    required this.child,
    super.key,
  });

  final Widget child;

  /// Нижний отступ для [ListView]/[SingleChildScrollView] под панель.
  static double scrollPadding(BuildContext context) {
    return _baseHeight + MediaQuery.viewInsetsOf(context).bottom;
  }

  static const double _baseHeight = 220;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16,
      shadowColor: Colors.black54,
      color: ExpansionColors.background.withValues(alpha: 0.96),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: child,
        ),
      ),
    );
  }
}
