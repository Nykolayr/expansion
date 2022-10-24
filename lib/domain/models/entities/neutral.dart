import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';

class NeutralBase extends EntityObject {
  TypeNeutral typeNeutral;
  int timeCapture;
  NeutralBase({
    required super.coordinates,
    required super.description,
    required super.maxShips,
    required super.shild,
    required super.ships,
    required super.speedBuild,
    required super.speedResources,
    required super.resources,
    required super.typeStatus,
    required this.typeNeutral,
    required this.timeCapture,
  });

  factory NeutralBase.fromJson(Map<String, dynamic> json) {
    final int x = json['coordinates']['x'];
    final int y = json['coordinates']['y'];

    TypeNeutral typeNeutral = TypeNeutral.values.firstWhere(
        (e) => e.toString() == 'TypeNeutral.${json["typeNeutral"]}');
    return NeutralBase(
      coordinates: Size(coordinatListX[x] * ratioXY.width,
          coordinatListY[y] * ratioXY.height),
      ships: typeNeutral.add.maxShips,
      description: typeNeutral.add.description,
      typeNeutral: typeNeutral,
      timeCapture: typeNeutral.add.timeCapture,
      maxShips: typeNeutral.add.maxShips,
      shild: typeNeutral.add.shild,
      speedBuild: typeNeutral.add.speedBuild,
      speedResources: typeNeutral.add.speedResources,
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
        "typeNeutral": typeNeutral,
        "resources": resources,
        "typeStatus": typeStatus,
      };

  @override
  Widget build() {
    return Positioned(
      top: coordinates.height ,
      left: coordinates.width - typeNeutral.add.size / 2,
      child: Container(
        padding: const EdgeInsets.all(7),
        height: typeNeutral.add.size,
        width: typeNeutral.add.size,
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: typeStatus.colorBorder,
            ),
            borderRadius: BorderRadius.circular(typeNeutral.add.size)),
        child: Image(
          image: AssetImage(
            typeNeutral.add.pictire,
          ),
        ),
      ),
    );
  }

  @override
  void update() {
    // TODO: implement update
  }
}

enum TypeNeutral { base, midleBase }

extension AddExtention on TypeNeutral {
  BaseAdd get add {
    switch (this) {
      case TypeNeutral.base:
        return BaseAdd(
          description: "Нейтральный объект",
          pictire: 'assets/images/neutral.png',
          maxShips: 100,
          shild: 0.0,
          speedBuild: 1.0,
          speedResources: 1.0,
          size: 60,
          timeCapture: 100,
        );
      case TypeNeutral.midleBase:
        return BaseAdd(
          description: "Нейтральный средний объект",
          pictire: 'assets/images/neutral.png',
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
