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
    };

const _$PlanetTypeEnumMap = {
  PlanetType.our: 'our',
  PlanetType.enemy: 'enemy',
  PlanetType.neutral: 'neutral',
  PlanetType.agressive: 'agressive',
};
