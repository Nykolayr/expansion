import 'package:flutter/material.dart';

import 'package:expansion/core/themes/expansion_colors.dart';

/// Линия жеста «от базы к цели».
class BattleDragLinePainter extends CustomPainter {
  BattleDragLinePainter({
    required this.from,
    required this.to,
  });

  final Offset from;
  final Offset to;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ExpansionColors.accent.withValues(alpha: 0.85)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(from, to, paint);

    final dot = Paint()..color = ExpansionColors.accent;
    canvas.drawCircle(from, 6, dot);
    canvas.drawCircle(to, 5, dot..color = Colors.white70);
  }

  @override
  bool shouldRepaint(covariant BattleDragLinePainter oldDelegate) =>
      oldDelegate.from != from || oldDelegate.to != to;
}
