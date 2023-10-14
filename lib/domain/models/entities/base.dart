import 'dart:math';

import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/utils/value.dart';

/// Абстрактный класс объект база(наша, враг и нейтралы),  есть 4 фактора
/// speedBuild скорость изготовление кораблей - повышается постройкой
/// shild  защита - повышается постройкой
/// maxShips предел кораблей - повышается постройкой
/// resources ресурс - абстрактный, прибавляется каждую секунду,
/// прибавка зависит speedResources - повышается постройкой
/// имеет начальные координаты coordinates  x, y
///   inicialShips  - начальное значение кораблей на объекте
/// typeStatus - статус объекта, захвачен нами, врагами, или нейтральный
/// size - размер объекта

class Base extends EntitesObject {
  double shild; // щит базы max до 100
  double resources; // количество ресурсов на базе
  int maxShips; // максимальное количество кораблей для постройки
  double speedBuild; // скорость постройки
  double speedResources; // скорость ресурсов
  int roundShip = 0; // количество кораблей
  bool isNotMove = false;
  String image; // путь к изображению
  // int size; // размер базы

  Base({
    required super.coordinates,
    required this.maxShips,
    required this.shild,
    required super.ships,
    required this.speedBuild,
    required this.speedResources,
    required this.resources,
    required super.typeStatus,
    required super.size,
    required super.index,
    required this.image,
    this.isNotMove = false,
  });

  factory Base.fromJson(Map<String, dynamic> json) {
    final x = (json['coordinates'] as Map<String, dynamic>)['x'] as int;
    final y = (json['coordinates'] as Map<String, dynamic>)['y'] as int;

    return Base(
      coordinates: Point(x, y),
      ships: json['ships'] as int,
      maxShips: json['maxShips'] as int,
      typeStatus: TypeStatus.values.firstWhere(
          (e) => e.toString() == 'TypeStatus.${json["typeStatus"]}'),
      image: json['path'] as String,
      shild: json['shild'] as double,
      speedBuild: json['speedBuild'] as double,
      speedResources: json['speedResources'] as double,
      resources: json['resources'] as double,
      size: json['size'] as double,
      index: json['index'] as int,
    );
  }
  Map<String, dynamic> toJson() => {
        'coordinates': coordinates,
        'maxShips': maxShips,
        'shild': shild,
        'ships': ships,
        'speedBuild': speedBuild,
        'speedResources': speedResources,
        'resources': resources,
        'typeStatus': typeStatus,
        'size': size,
        'index': index,
        'image': image,
      };

  Future<void> showIsNotMove() async {
    isNotMove = true;
    await Future.delayed(const Duration(milliseconds: 500));
    isNotMove = false;
    await Future.delayed(const Duration(milliseconds: 500));
    isNotMove = true;
    await Future.delayed(const Duration(milliseconds: 500));
    isNotMove = false;
  }

  void upShild() {
    final levelShild = (shild / typeStatus.minShild).round();
    resources -= 100 * (1 << levelShild);
    shild += typeStatus.minShild;
  }

  void upSpeedBuild() {
    final levelSpeed = (speedBuild / typeStatus.speedBuildShip).round();
    resources -= 100 * (1 << levelSpeed);
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
