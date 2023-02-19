import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';

class Base extends EntityObject {
  SizeBase sizeBase;
  int timeCapture;
  Base({
    required super.coordinates,
    required super.description,
    required super.maxShips,
    required super.shild,
    required super.ships,
    required super.speedBuild,
    required super.speedResources,
    required super.resources,
    required super.typeStatus,
    required this.sizeBase,
    required this.timeCapture,
  });

  factory Base.fromJson(Map<String, dynamic> json) {
    final int x = json['coordinates']['x'];
    final int y = json['coordinates']['y'];

    SizeBase sizeBase = SizeBase.values
        .firstWhere((e) => e.toString() == 'SizeBase.${json["sizeBase"]}');
    return Base(
      coordinates: Size(coordinatListX[x] * ratioXY.width,
          coordinatListY[y] * ratioXY.height),
      ships: sizeBase.add.maxShips,
      description: sizeBase.add.description,
      sizeBase: sizeBase,
      timeCapture: sizeBase.add.timeCapture,
      maxShips: sizeBase.add.maxShips,
      shild: sizeBase.add.shild,
      speedBuild: sizeBase.add.speedBuild,
      speedResources: sizeBase.add.speedResources,
      resources: 0.0,
      typeStatus: TypeStatus.values.firstWhere(
          (e) => e.toString() == 'TypeStatus.${json["typeStatus"]}'),
    );
  }
  Map<String, dynamic> toJson() => {
        "coordinates": coordinates,
        "description": description,
        "maxShips": maxShips,
        "shild": shild,
        "ships": ships,
        "speedBuild": speedBuild,
        "speedResources": speedResources,
        "SizeBase": sizeBase,
        "resources": resources,
        "typeStatus": typeStatus,
      };

  @override
  Widget build() {
    return Positioned(
      top: coordinates.height,
      left: coordinates.width,
      child: Container(
        padding: const EdgeInsets.all(7),
        height: sizeBase.add.size,
        width: sizeBase.add.size,
        child:
            Image.asset('${sizeBase.add.pictire}${typeStatus.name}_base.png'),
      ),
    );
  }

  @override
  void update() {
    // TODO: implement update
  }
}

enum SizeBase { base, midleBase }

extension AddExtention on SizeBase {
  BaseAdd get add {
    switch (this) {
      case SizeBase.base:
        return BaseAdd(
          description: "Нейтральный объект",
          pictire: 'assets/images/',
          maxShips: 100,
          shild: 0.0,
          speedBuild: 1.0,
          speedResources: 1.0,
          size: 60,
          timeCapture: 100,
        );
      case SizeBase.midleBase:
        return BaseAdd(
          description: "Нейтральный средний объект",
          pictire: 'assets/images/',
          maxShips: 130,
          shild: 0.0,
          speedBuild: 1.0,
          speedResources: 1.0,
          size: 80,
          timeCapture: 100,
        );
    }
  }
}

/// дополнительный базовый класс для base для  enum
class BaseAdd {
  String pictire;
  String description;
  int maxShips;
  double shild;
  double speedBuild;
  double speedResources;
  double size;
  int timeCapture;

  BaseAdd({
    required this.description,
    required this.pictire,
    required this.maxShips,
    required this.shild,
    required this.speedBuild,
    required this.speedResources,
    required this.size,
    required this.timeCapture,
  });
}
