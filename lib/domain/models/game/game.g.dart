// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Game _$$_GameFromJson(Map<String, dynamic> json) => _$_Game(
      univer: $enumDecodeNullable(_$UniverEnumMap, json['univer']) ??
          Univer.classic,
      level:
          $enumDecodeNullable(_$LevelEnumMap, json['level']) ?? Level.average,
      isHint: json['isHint'] as bool? ?? true,
    );

Map<String, dynamic> _$$_GameToJson(_$_Game instance) => <String, dynamic>{
      'univer': _$UniverEnumMap[instance.univer]!,
      'level': _$LevelEnumMap[instance.level]!,
      'isHint': instance.isHint,
    };

const _$UniverEnumMap = {
  Univer.classic: 'classic',
  Univer.generated: 'generated',
};

const _$LevelEnumMap = {
  Level.easy: 'easy',
  Level.average: 'average',
  Level.difficult: 'difficult',
};
