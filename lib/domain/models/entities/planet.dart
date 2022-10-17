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
  String description;
  double distanceSolar;
  double diameter;
  double period;
  int shild;
  int maxShips;
  double speedBuild;
  double speedResources;

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
  });

  factory Planet.fromJson(Map<String, dynamic> json) => _$PlanetFromJson(json);
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

enum PlanetType { our, enemy, neutral, agressive }

extension PlanetTypeExtention on PlanetType {
  String get nameMenu {
    switch (this) {
      case PlanetType.our:
        return tr('easy');
      case PlanetType.enemy:
        return tr('easy');
      case PlanetType.neutral:
        return tr('easy');
      case PlanetType.agressive:
        return tr('easy');
    }
  }
}
