import 'dart:ui' as ui;

import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

/// функция загрузки картинки из assets для canvas
Future<ui.Image> loadImage(String asset) async {
  final data = await rootBundle.load(asset);
  final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  final fi = await codec.getNextFrame();
  return fi.image;
}
