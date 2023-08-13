// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String,
      score: json['score'] as int? ?? 0,
      isBegin: json['isBegin'] as bool? ?? true,
      isRegistration: json['isRegistration'] as bool? ?? false,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'score': instance.score,
      'isBegin': instance.isBegin,
      'isRegistration': instance.isRegistration,
    };
