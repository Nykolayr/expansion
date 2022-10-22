// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

System _$SystemFromJson(Map<String, dynamic> json) => System(
      name: json['name'] as String,
      starName: json['starName'] as String,
      diametr: (json['diametr'] as num).toDouble(),
    );

Map<String, dynamic> _$SystemToJson(System instance) => <String, dynamic>{
      'name': instance.name,
      'starName': instance.starName,
      'diametr': instance.diametr,
    };
