import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';

/// Абстрактный класс объект,  есть 4 фактора
/// speedBuild скорость изготовление кораблей - повышается постройкой
/// shild  защита - повышается постройкой
/// maxShips предел кораблей - повышается постройкой
/// resources ресурс - абстрактный, прибавляется каждую секунду,
/// прибавка зависит speedResources - повышается постройкой
/// имеет начальные координаты coordinates  x, y
/// typeObject - изначальный тип объекта,   наш, врага, нейтральная
///   inicialShips  - начальное значение кораблей на объекте
/// typeStatus - статус объекта, захвачен нами, врагами, или нейтральный
/// size - размер объекта

abstract class EntityObject {
  Size coordinates;
  TypeStatus typeStatus;
  String description;
  double shild;
  int maxShips;
  double speedBuild;
  double speedResources;
  int ships;
  double resources;

  EntityObject({
    required this.coordinates,
    required this.description,
    required this.shild,
    required this.maxShips,
    required this.speedBuild,
    required this.speedResources,
    required this.ships,
    required this.typeStatus,
    required this.resources,
  });

  void update();
  Widget build();
}

enum TypeStatus { our, enemy, neutral }

extension TypeStatusExtention on TypeStatus {
  Color get colorBorder {
    switch (this) {
      case TypeStatus.our:
        return AppColor.green;
      case TypeStatus.enemy:
        return AppColor.red;
      case TypeStatus.neutral:
        return AppColor.white;
    }
  }
}
