import 'dart:math';
import 'dart:math' as math;

import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';

/// отдает координаты планеты 
/// в зависимости от дистанции, диаметра и градуса отклонения планеты
Size getcoordinates(double gradus, double distance, double diametr) {
  double radians = (gradus * math.pi) / 180;
  double x = centerStar.height + distance * sin(radians) - diametr / 2;
  double y = centerStar.width + distance * cos(radians) - diametr / 2;
  return Size(x, y);
}

/// отдает реальные размер в зависимости от устройства
Size getReal(Size size) {
  return Size(size.width * ratioXY.width, size.height * ratioXY.height);
}
