import 'dart:math';
import 'package:expansion/domain/models/entities/base.dart';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// вспомагательный класс базы для маркирования на карте битвы
/// применяется при создании карты уровня с расположенными на ней
/// базами с этим классом, из которого перед битвой
/// создаются базы для отображения на поле битвы
/// x, y - координаты базы на поле 5*8
/// typeBase - тип базы (корабли матки и базы разного размера)
/// typeStatus - статус базы (наша, врага, нейтральная)
class BaseMap {
  int x;
  int y;
  TypeBase typeBase;
  TypeStatus typeStatus;
  BaseMap(
      {required this.x,
      required this.y,
      required this.typeBase,
      required this.typeStatus});
  factory BaseMap.fromJson(Map<String, dynamic> json) {
    final x = (json['coordinates'] as Map<String, dynamic>)['x'] as int;
    final y = (json['coordinates'] as Map<String, dynamic>)['y'] as int;
    return BaseMap(
      x: x,
      y: y,
      typeBase: TypeBase.values.byName(json['typeBase'] as String),
      typeStatus: TypeStatus.values.byName(json['typeStatus'] as String),
    );
  }
  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'typeBase': typeBase.name,
        'typeStatus': typeStatus.name
      };
}

enum TypeBase {
  ourMainShip,
  enemyMainShip,
  smallBase,
  midleBase,
  base;

  TypeStatus get status {
    switch (this) {
      case TypeBase.ourMainShip:
        return TypeStatus.our;
      case TypeBase.enemyMainShip:
        return TypeStatus.enemy;
      case TypeBase.smallBase:
      case TypeBase.midleBase:
      case TypeBase.base:
        return TypeStatus.neutral;
    }
  }

  String get image {
    switch (this) {
      case TypeBase.ourMainShip:
        return 'assets/images/our.png';
      case TypeBase.enemyMainShip:
        return 'assets/images/enemy.png';
      case TypeBase.smallBase:
        return 'assets/images/bases/base1.png';
      case TypeBase.midleBase:
        return 'assets/images/bases/base2.png';
      case TypeBase.base:
        return 'assets/images/bases/base3.png';
    }
  }

  Base getBase(
    int x,
    int y,
    double? shild,
    int? ships,
    int? maxShips,
    TypeStatus? typeStatus,
    double? size,
  ) {
    switch (this) {
      case TypeBase.ourMainShip:
        {
          final sizeThis = size ?? 100;
          return Base(
            coordinates: Point(
                (stepX * x - sizeThis / 2).w, (stepY * y - sizeThis / 2).h),
            shild: shild ?? 100,
            ships: ships ?? 100,
            speedBuild: 0,
            speedResources: 0,
            resources: 0,
            typeStatus: TypeStatus.our,
            image: 'assets/images/our.png',
            index: 0,
            maxShips: maxShips ?? 200,
            size: sizeThis,
          );
        }
      case TypeBase.enemyMainShip:
        {
          final sizeThis = size ?? 100;
          return Base(
            coordinates: Point(
                (stepX * x - sizeThis / 2).w, (stepY * y - sizeThis / 2).h),
            shild: shild ?? 100,
            ships: ships ?? 100,
            speedBuild: 0,
            speedResources: 0,
            resources: 0,
            typeStatus: typeStatus ?? TypeStatus.enemy,
            image: 'assets/images/enemy.png',
            index: 0,
            maxShips: maxShips ?? 200,
            size: sizeThis,
          );
        }
      case TypeBase.smallBase:
        {
          const sizeThis = 60.0;
          return Base(
            coordinates: Point(
                (stepX * x - sizeThis / 2).w, (stepY * y - sizeThis / 2).h),
            shild: 0,
            ships: 100,
            speedBuild: 0,
            speedResources: 0,
            resources: 0,
            typeStatus: typeStatus ?? TypeStatus.neutral,
            image: 'assets/images/bases/base1.png',
            index: 0,
            maxShips: 100,
            size: sizeThis,
          );
        }
      case TypeBase.midleBase:
        {
          const sizeThis = 70.0;
          return Base(
            coordinates: Point(
                (stepX * x - sizeThis / 2).w, (stepY * y - sizeThis / 2).h),
            shild: 0,
            ships: 120,
            speedBuild: 0,
            speedResources: 0,
            resources: 0,
            typeStatus: typeStatus ?? TypeStatus.neutral,
            image: 'assets/images/bases/base2.png',
            index: 0,
            maxShips: 120,
            size: sizeThis,
          );
        }
      case TypeBase.base:
        {
          const sizeThis = 80.0;
          return Base(
            coordinates: Point(
                (stepX * x - sizeThis / 2).w, (stepY * y - sizeThis / 2).h),
            shild: 0,
            ships: 140,
            speedBuild: 0,
            speedResources: 0,
            resources: 0,
            typeStatus: typeStatus ?? TypeStatus.neutral,
            image: 'assets/images/bases/base3.png',
            index: 0,
            maxShips: 140,
            size: sizeThis,
          );
        }
    }
  }
}
