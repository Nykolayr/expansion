import 'package:expansion/domain/models/entities/entities.dart';

import '../../../utils/value.dart';

/// Абстрактный класс объект база(наша, враг и нейтралы),  есть 4 фактора
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

abstract class BaseObject extends EntitesObject {
  String description; // описание базы
  double shild; // щит базы max до 100
  double resources; // количество ресурсов на базе
  int maxShips; // максимальное количество кораблей для постройки
  double speedBuild;
  double speedResources;
  int roundShip = 0;
  bool isNotMove = false;

  BaseObject({
    required super.coordinates,
    required super.typeStatus,
    required super.size,
    required super.ships,
    required this.description,
    required this.shild,
    required this.maxShips,
    required this.speedBuild,
    required this.speedResources,
    required this.resources,
    required super.index,
  });

  Future showIsNotMove() async {
    isNotMove = true;
    await Future.delayed(const Duration(milliseconds: 500));
    isNotMove = false;
    await Future.delayed(const Duration(milliseconds: 500));
    isNotMove = true;
    await Future.delayed(const Duration(milliseconds: 500));
    isNotMove = false;
  }

  void upShild() {
    int levelShild = (shild / typeStatus.minShild).round();
    resources -= 100 * (1 << (levelShild));
    shild += typeStatus.minShild;
  }

  void upSpeedBuild() {
    int levelSpeed = (speedBuild / typeStatus.speedBuildShip).round();
    resources -= 100 * (1 << (levelSpeed));
    speedBuild += typeStatus.speedBuildShip / 3;
  }

  @override
  void update() {
    if (typeStatus == TypeStatus.neutral || typeStatus == TypeStatus.asteroid) {
      return;
    }
    if (ships < maxShips) {
      roundShip++;
      if (roundShip == delSpeedBuild) {
        roundShip = 0;
        ships++;
      }
    }
    resources += speedResources / 8;
  }
}
