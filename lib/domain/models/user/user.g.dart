// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      name: json['name'] as String,
      step: json['step'] as int? ?? 0,
      score: json['score'] as int? ?? 0,
      upgrade: json['upgrade'] as int? ?? 0,
      isBegin: json['isBegin'] as bool? ?? true,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'name': instance.name,
      'step': instance.step,
      'score': instance.score,
      'upgrade': instance.upgrade,
      'isBegin': instance.isBegin,
    };
