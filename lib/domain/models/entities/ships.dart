import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';

class Ship extends EntityObject {
  int timeCapture;
  int size;
  Ship({
    required super.coordinates,
    required super.description,
    required super.maxShips,
    required super.shild,
    required super.ships,
    required super.speedBuild,
    required super.speedResources,
    required super.resources,
    required super.typeStatus,
    required this.timeCapture,
    required this.size,
  });
  factory Ship.fromJson(Map<String, dynamic> json) {
    final int x = json['coordinates']['x'];
    final int y = json['coordinates']['y'];
    return Ship(
      coordinates: Size(coordinatListX[x] * ratioXY.width,
          coordinatListY[y] * ratioXY.height),
      description: json['description'],
      shild: json['shild'],
      speedBuild: json['speedBuild'],
      speedResources: json['speedResources'],
      maxShips: json['maxShips'],
      timeCapture: json['coordinates'],
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
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  void update() {
    // TODO: implement update
  }
}
