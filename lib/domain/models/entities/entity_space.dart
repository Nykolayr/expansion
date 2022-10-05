import 'package:flutter/material.dart';

/// абстрактный класс космический объект
/// начальные координаты, имя,
/// 2 метода апдэйт и виджет

abstract class EntitySpace {
  double x;
  double y;
  String name;

  EntitySpace({required this.name, required this.x, required this.y});

  void update();
  Widget build();
}
