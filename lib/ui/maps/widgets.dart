import 'package:expansion/utils/colors.dart';
import 'package:flutter/rendering.dart';

class LinePainter extends CustomPainter {
  final Offset begin;
  final Offset end;

  LinePainter({
    required this.begin,
    required this.end,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.darkYeloow
      ..strokeWidth = 3;

    canvas.drawLine(Offset(begin.dx, begin.dy), Offset(end.dx, end.dy), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
