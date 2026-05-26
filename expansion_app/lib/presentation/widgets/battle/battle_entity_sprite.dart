import 'package:flutter/material.dart';

/// Спрайт сущности боя; при отсутствии файла — [fallback].
class BattleEntitySprite extends StatelessWidget {
  const BattleEntitySprite({
    required this.assetPath,
    required this.size,
    this.fallback,
    super.key,
  });

  final String assetPath;
  final double size;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      errorBuilder: (context, error, stackTrace) {
        return fallback ??
            Icon(
              Icons.broken_image_outlined,
              size: size * 0.7,
              color: Colors.white54,
            );
      },
    );
  }
}
