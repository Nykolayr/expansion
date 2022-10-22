import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/Api/api.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/domain/models/entities/planet.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';

/// класс игровых сущностей которые загружаются из апи или ассета
///  List<Planet> - список планет, system - название системы и звезды
class GameData {
  late List<Planet> planets;
  late System system;
  int countScene = 0;
  loadMap() async {
    Map<String, dynamic> json = await Api.loadJson(countScene);
    system = System.fromJson(json["system"]);
    planets = List<Planet>.from(json["planets"].map((x) => Planet.fromJson(x)));
  }
}

/// класс для звезды
///  starname, diametr, size - положение звезды,
/// starType - тип звезды
/// name - название звездной системы
class System extends EntitySpace {
  String starName;
  StarType starType;
  double diametr;

  System({
    required super.name,
    required super.size,
    required this.starName,
    required this.starType,
    required this.diametr,
  });
  factory System.fromJson(Map<String, dynamic> json) {
    return System(
      name: tr(json["name"]),
      starType: StarType.values
          .firstWhere((e) => e.toString() == 'StarType.${json["StarType"]}'),
      size: centerStar,
      starName: json["starName"],
      diametr: json["diametr"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "StarType": StarType,
        "size": size,
        "starName": starName,
        "diametr": diametr,
      };
  @override
  Widget build() {
    return Positioned(
      top: size.height - diametr / 2,
      left: size.width - diametr / 2,
      child: Container(
        width: diametr,
        height: diametr,
        decoration: AppColor.sun,
      ),
    );
  }

  @override
  void update() {}
}

/// classB - голубые, classA - белые, classG - желтые,
/// classK - оранжевые, classM - красные
enum StarType { classB, classA, classG, classK, classM }

extension StarTypeExtention on StarType {
  BoxDecoration get boxDecoration {
    switch (this) {
      case StarType.classB:
        return AppColor.sun;
      case StarType.classA:
        return AppColor.sun;
      case StarType.classG:
        return AppColor.sun;
      case StarType.classK:
        return AppColor.sun;
      case StarType.classM:
        return AppColor.sun;
    }
  }
}
