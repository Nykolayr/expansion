import 'package:flutter/material.dart';

import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';

/// Широкая кнопка «Начать игру» на splash (обёртка [GameLongButton]).
class SplashLongButton extends StatelessWidget {
  const SplashLongButton({
    required this.title,
    required this.onPressed,
    super.key,
  });

  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GameLongButton(label: title, onPressed: onPressed);
  }
}
