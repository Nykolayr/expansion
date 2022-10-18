import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'planet.g.dart';

/// Класс Планета  у каждой планеты  есть 4 фактора
/// (скорость изготовление кораблей - повышается постройкой техники)
/// защита - повышается постройкой
/// предел кораблей - который можно построить зависит от (тип планеты (кислород. метан) + размер планеты
/// ресурс - абстрактный, прибавляется каждую секунду, прибавка зависит от зависит от размера планеты,
/// имеет начальное положение x, y
/// тип - наша, врага, нейтральная, агрессивная
///   distanceSolar  - дистанция до звезды
/// diameter - диаметр планеты
///  period -  период обращения вокруг звезды
@JsonSerializable()
class Planet extends EntitySpace {
  PlanetType planetType;
  PlanetStatus planetStatus;
  String description;
  double distanceSolar;
  double diameter;
  double period;
  int shild;
  double speedBuild;
  double speedResources;
  int ships;
  int maxShips;

  Planet({
    required super.name,
    required super.x,
    required super.y,
    required this.planetType,
    required this.description,
    required this.distanceSolar,
    required this.diameter,
    required this.period,
    required this.shild,
    required this.maxShips,
    required this.speedBuild,
    required this.speedResources,
    required this.planetStatus,
    required this.ships,
  });

  factory Planet.fromJson(Map<String, dynamic> json) {
    json["name"] = tr(json["name"]);
    json["shild"] = 100;
    json["maxShips"] = 100;
    json["speedBuild"] = 100.0;
    json["speedResources"] = 100.0;
    json["ships"] = 100;
    return _$PlanetFromJson(json);
  }
  Map<String, dynamic> toJson() => _$PlanetToJson(this);

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

enum PlanetStatus { our, enemy, neutral, agressive }

extension PlanetStatusExtention on PlanetStatus {
  String get nameMenu {
    switch (this) {
      case PlanetStatus.our:
        return tr('our');
      case PlanetStatus.enemy:
        return tr('enemy');
      case PlanetStatus.neutral:
        return tr('neutral');
      case PlanetStatus.agressive:
        return tr('agressive');
    }
  }
}

enum PlanetType { earthType, gasGiant, iceGiant, mesoplanet, ironPlanet }

extension PlanetTypeExtention on PlanetType {
  String get nameMenu {
    switch (this) {
      case PlanetType.earthType:
        return tr('earth_Type');
      case PlanetType.gasGiant:
        return tr('gas_Giant');
      case PlanetType.iceGiant:
        return tr('ice_Giant');
      case PlanetType.mesoplanet:
        return tr('mesoplanet');
      case PlanetType.ironPlanet:
        return tr('iron_Planet');
    }
  }
}
