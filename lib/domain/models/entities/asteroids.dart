import 'dart:math';
import 'package:flutter/material.dart';

class AmorphousCircle extends StatefulWidget {
  const AmorphousCircle({super.key});

  @override
  AmorphousCircleState createState() => AmorphousCircleState();
}

class AmorphousCircleState extends State<AmorphousCircle> {
  List<Offset> points = [];

  @override
  void initState() {
    super.initState();
    generatePoints();
  }

  void generatePoints() {
    const double radius = 10.0; // Радиус окружности
    const int numPoints = 500; // Количество точек

    points.clear();
    final random = Random();

    for (int i = 0; i < numPoints; i++) {
      // Случайные координаты внутри окружности
      final double angle = random.nextDouble() * pi * 2;
      final double x = cos(angle) * radius;
      final double y = sin(angle) * radius;

      // Случайное смещение каждой точки
      final double offsetX = random.nextDouble() * 20 - 10;
      final double offsetY = random.nextDouble() * 20 - 10;

      points.add(Offset(x + offsetX, y + offsetY));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.skewY(0.3)..rotateZ(-pi / 12.0),
      child: CustomPaint(
        painter: CirclePainter(points),
        size: const Size(12, 12),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final List<Offset> points;

  CirclePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;

    for (var point in points) {
      final offset = center + point;
      canvas.drawCircle(offset, 1.0, paint);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}
