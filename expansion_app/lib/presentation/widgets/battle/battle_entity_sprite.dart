import 'package:flutter/material.dart';

import 'package:expansion/core/logging/app_log.dart';

/// PNG-спрайт сущности боя (базы, астероиды). Без фона — только альфа PNG.
class BattleEntitySprite extends StatelessWidget {
  const BattleEntitySprite({
    required this.assetPath,
    required this.size,
    super.key,
  });

  final String assetPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        gaplessPlayback: true,
        excludeFromSemantics: true,
        isAntiAlias: true,
        errorBuilder: (context, error, stackTrace) {
          AppLog.error(
            'battle sprite missing: $assetPath',
            error: error,
            stackTrace: stackTrace,
          );
          return SizedBox(
            width: size,
            height: size,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.redAccent, width: 2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.image_not_supported, color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}
