import 'package:flutter/material.dart';

/// абстрактный класс космический объект
/// начальные координаты, имя,
/// 2 метода апдэйт и виджет

abstract class EntitySpace {
  String name;
  Size size;

  EntitySpace({required this.name, required this.size});

  void update();
  Widget build();
}
