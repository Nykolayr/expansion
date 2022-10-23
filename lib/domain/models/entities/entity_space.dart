import 'package:easy_localization/easy_localization.dart';
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

abstract class EntityObject {
  Size coordinates;
  TypeObject typeObject;
  TypeStatus typeStatus;
  String description;
  double shild;
  double maxShips;
  double speedBuild;
  double speedResources;
  int inicialShips;
  int ships;
  double resources;

  EntityObject({
    required this.coordinates,
    required this.typeObject,
    required this.description,
    required this.shild,
    required this.maxShips,
    required this.speedBuild,
    required this.speedResources,
    required this.ships,
    required this.inicialShips,
    required this.typeStatus,
    required this.resources,
  });

  void update();
  Widget build();
}

enum TypeObject { ourObject, enemyObject, baseObject }

extension TypeObjectExtention on TypeObject {
  String get nameMenu {
    switch (this) {
      case TypeObject.ourObject:
        return tr('our');
      case TypeObject.enemyObject:
        return tr('enemy');
      case TypeObject.baseObject:
        return tr('neutral');
    }
  }
}

enum TypeStatus { our, enemy, neutral }

extension TypeStatusExtention on TypeStatus {
  String get nameMenu {
    switch (this) {
      case TypeStatus.our:
        return tr('our');
      case TypeStatus.enemy:
        return tr('enemy');
      case TypeStatus.neutral:
        return tr('neutral');
    }
  }
}
