import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/utils.dart';

import 'package:flutter/material.dart';

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
class Planet extends EntitySpace {
  PlanetType planetType;
  PlanetStatus planetStatus;
  String description;
  double distanceSolar;
  double diameter;
  double period;
  double shild;
  double speedBuild;
  double speedResources;
  int ships;
  int maxShips;
  double gradus;

  Planet({
    required super.name,
    required super.size,
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
    required this.gradus,
  });

  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      name: tr(json["name"]),
      planetType: PlanetType.values.firstWhere(
          (e) => e.toString() == 'PlanetType.${json["planetType"]}'),
      planetStatus: PlanetStatus.values.firstWhere(
          (e) => e.toString() == 'PlanetStatus.${json["planetStatus"]}'),
      description: json["description"],
      distanceSolar: json["distanceSolar"],
      diameter: json["diameter"],
      period: json["period"],
      gradus: json["gradus"],
      size: getcoordinates(
          json["gradus"], json["distanceSolar"], json["distanceSolar"]),
      shild: 100,
      maxShips: 100,
      speedBuild: 100.0,
      speedResources: 100.0,
      ships: 0,
    );
  }
  Map<String, dynamic> toJson() => {
        "name": name,
        "planetType": planetType.name,
        "planetStatus": planetStatus.name,
        "description": description,
        "distanceSolar": distanceSolar,
        "diameter": diameter,
        "period": period,
        "shgradusild": gradus,
        "size": size,
        "shild": shild,
        "ships": ships,
        "maxShips": maxShips,
        "speedBuild": speedBuild,
        "speedResources": speedResources,
      };

  @override
  Widget build() {
    return Positioned(
      top: size.width,
      left: size.height,
      child: Column(
        children: [
          Container(
            width: diameter,
            height: diameter,
            decoration: planetStatus.boxDecoration,
          ),
          Text(
            name,
            style: AppText.baseBody.copyWith(
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void update() {
    gradus += 0.3 / period;
    if (gradus > 360) gradus = 0;
    size = getcoordinates(gradus, distanceSolar, diameter);
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

  BoxDecoration get boxDecoration {
    switch (this) {
      case PlanetStatus.our:
        return AppColor.ourPlanet;
      case PlanetStatus.enemy:
        return AppColor.enemyPlanet;
      case PlanetStatus.neutral:
        return AppColor.neutralPlanet;
      case PlanetStatus.agressive:
        return AppColor.agressivePlanet;
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
