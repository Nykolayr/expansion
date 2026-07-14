import 'package:flutter/material.dart';

import 'package:expansion/core/constants/game_assets.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';

/// Фон меню: splash + градиентный scrim (снизу сильнее для светлой планеты).
class GameMenuBackdrop extends StatelessWidget {
  const GameMenuBackdrop({
    this.fit = BoxFit.cover,
    super.key,
  });

  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          GameAssets.splashBackground,
          fit: fit,
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x40000000),
                Color(0x73000000),
                Color(0x9E000000),
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}

/// Тени для белого текста поверх фонового арта (не для боя).
class GameMenuTheme extends StatelessWidget {
  const GameMenuTheme({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        textTheme: ExpansionTextStyles.menuTextTheme(theme.textTheme),
      ),
      child: child,
    );
  }
}
