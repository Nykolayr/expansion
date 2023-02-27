import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
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
  ActionObject actionObject;

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
    required this.actionObject,
  });

  void update();
  Widget build({
    required int index,
    // required ActionObject actionObject,
    required Function() click,
    required Function(int sender) onAccept,
  });
  Widget getText();
}

enum TypeStatus { our, enemy, neutral }

extension TypeStatusExtention on TypeStatus {
  String get desc {
    switch (this) {
      case TypeStatus.our:
        return 'Этот объект наш';
      case TypeStatus.enemy:
        return 'Этот объект вражеский';
      case TypeStatus.neutral:
        return 'Этот объект нейтральный';
    }
  }

  Color get color {
    switch (this) {
      case TypeStatus.our:
        return AppColor.green;
      case TypeStatus.enemy:
        return AppColor.red;
      case TypeStatus.neutral:
        return AppColor.white;
    }
  }

  Color get colorText {
    switch (this) {
      case TypeStatus.our:
        return AppColor.white;
      case TypeStatus.enemy:
        return AppColor.white;
      case TypeStatus.neutral:
        return AppColor.black;
    }
  }
}
