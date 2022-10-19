import 'dart:math';
import 'dart:math' as math;

import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';

Size getcoordinates(int gradus, double distance) {
  double radians = (gradus * math.pi) / 180;
  if (gradus == 360) gradus = 0;
  double x = center.width + distance * cos(radians) + 180;
  double y = center.height + distance * sin(radians) - 210;
  return Size(x, y);
}
