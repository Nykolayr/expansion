// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Planet _$PlanetFromJson(Map<String, dynamic> json) => Planet(
      name: json['name'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      planetType: $enumDecode(_$PlanetTypeEnumMap, json['planetType']),
      description: json['description'] as String,
      distanceSolar: (json['distanceSolar'] as num).toDouble(),
      diameter: (json['diameter'] as num).toDouble(),
      period: (json['period'] as num).toDouble(),
      shild: json['shild'] as int,
      maxShips: json['maxShips'] as int,
      speedBuild: (json['speedBuild'] as num).toDouble(),
      speedResources: (json['speedResources'] as num).toDouble(),
    );

Map<String, dynamic> _$PlanetToJson(Planet instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'name': instance.name,
      'planetType': _$PlanetTypeEnumMap[instance.planetType]!,
      'description': instance.description,
      'distanceSolar': instance.distanceSolar,
      'diameter': instance.diameter,
      'period': instance.period,
      'shild': instance.shild,
      'maxShips': instance.maxShips,
      'speedBuild': instance.speedBuild,
      'speedResources': instance.speedResources,
    };

const _$PlanetTypeEnumMap = {
  PlanetType.our: 'our',
  PlanetType.enemy: 'enemy',
  PlanetType.neutral: 'neutral',
  PlanetType.agressive: 'agressive',
};
