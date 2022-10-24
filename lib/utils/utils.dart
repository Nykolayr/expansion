import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';

/// отдает реальные размер в зависимости от устройства
Size getReal(Size size) {
  return Size(size.width * ratioXY.width, size.height * ratioXY.height);
}
