import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:flutter/material.dart';

class EnemyMainShip extends EntityObject {
  EnemyMainShip({
    required super.coordinates,
    required super.description,
    required super.inicialShips,
    required super.maxShips,
    required super.shild,
    required super.ships,
    required super.speedBuild,
    required super.speedResources,
    required super.typeObject,
    required super.resources,
    required super.typeStatus,
  });

  factory EnemyMainShip.fromJson(Map<String, dynamic> json) {
    return EnemyMainShip(
      coordinates: json['coordinates'],
      description: json['description'],
      inicialShips: json['inicialShips'],
      maxShips: json['maxShips'],
      shild: json['shild'],
      ships: json['ships'],
      speedBuild: json['speedBuild'],
      speedResources: json['speedResources'],
      typeObject: json['typeObject'],
      resources: json['resources'],
      typeStatus: json['typeStatus'],
    );
  }
  Map<String, dynamic> toJson() => {
        "coordinates": coordinates,
        "description": description,
        "inicialShips": inicialShips,
        "maxShips": maxShips,
        "shild": shild,
        "ships": ships,
        "speedBuild": speedBuild,
        "speedResources": speedResources,
        "typeObject": typeObject,
        "resources": resources,
        "typeStatus": typeStatus,
      };

  @override
  Widget build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  void update() {
    // TODO: implement update
  }
}
