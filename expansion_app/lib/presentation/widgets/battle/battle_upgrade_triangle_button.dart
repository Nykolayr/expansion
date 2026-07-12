import 'package:flutter/material.dart';

import 'package:expansion/core/audio/game_audio_service.dart';
import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/themes/expansion_colors.dart';

/// Кнопка-«треугольник»: сверху будущее значение, снизу текущее, цена внизу.
class BattleUpgradeTriangleButton extends StatelessWidget {
  const BattleUpgradeTriangleButton({
    required this.label,
    required this.currentValue,
    required this.nextValue,
    required this.cost,
    required this.enabled,
    required this.canAfford,
    required this.maxed,
    required this.onPressed,
    super.key,
  });

  final String label;
  final String currentValue;
  final String nextValue;
  final int cost;
  final bool enabled;
  final bool canAfford;
  final bool maxed;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final canTap = enabled && !maxed;
    final accent =
        maxed || !canAfford ? ExpansionColors.grey : ExpansionColors.accent;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canTap
              ? () {
                  sl<GameAudioService>().playUiClick();
                  onPressed?.call();
                }
              : null,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: ExpansionColors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                if (!maxed)
                  Text(
                    nextValue,
                    style: TextStyle(
                      color: accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                CustomPaint(
                  size: const Size(36, 22),
                  painter: _TrianglePainter(color: accent),
                ),
                Text(
                  maxed ? '—' : currentValue,
                  style: const TextStyle(
                    color: ExpansionColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  maxed ? 'MAX' : '⚙$cost',
                  style: TextStyle(
                    color: accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  _TrianglePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      path,
      Paint()..color = color.withValues(alpha: 0.85),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black54
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) =>
      oldDelegate.color != color;
}
