import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';

class NeutralBase extends EntityObject {
  NeutralBase({
    required super.coordinates,
    required super.description,
    required super.inicialShips,
    required super.maxShips,
    required super.shild,
    required super.ships,
    required super.speedBuild,
    required super.speedResources,
    required super.resources,
    required super.typeObject,
    required super.typeStatus,
  });

  factory NeutralBase.fromJson(Map<String, dynamic> json) {
    return NeutralBase(
      coordinates: Size(json['coordinates']['x'] * ratioXY.width,
          json['coordinates']['y'] * ratioXY.height),
      description: json['description'],
      inicialShips: json['inicialShips'],
      maxShips: json['maxShips'],
      shild: json['shild'],
      ships: json['inicialShips'],
      speedBuild: json['speedBuild'],
      speedResources: json['speedResources'],
      typeObject: TypeObject.values.firstWhere(
          (e) => e.toString() == 'TypeObject.${json["typeObject"]}'),
      resources: json['resources'],
      typeStatus: TypeStatus.values.firstWhere(
          (e) => e.toString() == 'TypeStatus.${json["TypeStatus"]}'),
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
    retrun 
  }

  @override
  void update() {
    // TODO: implement update
  }
}
