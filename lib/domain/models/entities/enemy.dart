import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:flutter/material.dart';

class EnemyMainShip extends EntityObject {
  EnemyMainShip({
    required super.coordinates,
    required super.description,
    required super.maxShips,
    required super.shild,
    required super.ships,
    required super.speedBuild,
    required super.speedResources,
    required super.resources,
    required super.typeStatus,
  });

  factory EnemyMainShip.fromJson(Map<String, dynamic> json) {
    return EnemyMainShip(
      coordinates: json['coordinates'],
      description: json['description'],
      maxShips: json['maxShips'],
      shild: json['shild'],
      ships: json['ships'],
      speedBuild: json['speedBuild'],
      speedResources: json['speedResources'],
      resources: json['resources'],
      typeStatus: json['typeStatus'],
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
