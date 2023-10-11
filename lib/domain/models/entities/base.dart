import 'dart:math';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Base extends BaseObject {
  SizeBase sizeBase;

  Base({
    required super.coordinates,
    required super.maxShips,
    required super.shild,
    required super.ships,
    required super.speedBuild,
    required super.speedResources,
    required super.resources,
    required super.typeStatus,
    required this.sizeBase,
    required super.size,
    required super.index,
  });

  factory Base.fromJson(Map<String, dynamic> json) {
    final x = (json['coordinates'] as Map<String, dynamic>)['x'] as int;
    final y = (json['coordinates'] as Map<String, dynamic>)['y'] as int;
    final sizeBase = SizeBase.values
        .firstWhere((e) => e.toString() == 'SizeBase.${json["typeNeutral"]}');
    final size = sizeBase.add.size;
    return Base(
      coordinates: Point((stepX * x - size / 2).w, (stepY * y - size / 2).h),
      ships: sizeBase.add.maxShips,
      sizeBase: sizeBase,
      maxShips: sizeBase.add.maxShips,
      shild: sizeBase.add.shild,
      speedBuild: sizeBase.add.speedBuild,
      speedResources: sizeBase.add.speedResources,
      resources: 0,
      typeStatus: TypeStatus.values.firstWhere(
          (e) => e.toString() == 'TypeStatus.${json["typeStatus"]}'),
      size: size,
      index: 0,
    );
  }
  Map<String, dynamic> toJson() => {
        'coordinates': coordinates,
        'maxShips': maxShips,
        'shild': shild,
        'ships': ships,
        'speedBuild': speedBuild,
        'speedResources': speedResources,
        'SizeBase': sizeBase,
        'resources': resources,
        'typeStatus': typeStatus,
      };
}

enum SizeBase {
  smallBase,
  midleBase,
  base;

  BaseAdd get add {
    switch (this) {
      case SizeBase.midleBase:
        return BaseAdd(
          pictire: 'assets/images/bases/base1.png',
          maxShips: 120,
          shild: 0,
          speedBuild: 0,
          speedResources: 0,
          size: 75,
        );
      case SizeBase.smallBase:
        return BaseAdd(
          pictire: 'assets/images/bases/base2.png',
          maxShips: 100,
          shild: 0,
          speedBuild: 0,
          speedResources: 0,
          size: 60,
        );
      case SizeBase.base:
        return BaseAdd(
          pictire: 'assets/images/bases/base3.png',
          maxShips: 150,
          shild: 0,
          speedBuild: 0,
          speedResources: 0,
          size: 90,
        );
    }
  }
}

/// дополнительный базовый класс для base для  enum
class BaseAdd {
  String pictire;
  int maxShips;
  double shild;
  double speedBuild;
  double speedResources;
  double size;

  BaseAdd({
    required this.pictire,
    required this.maxShips,
    required this.shild,
    required this.speedBuild,
    required this.speedResources,
    required this.size,
  });
}
