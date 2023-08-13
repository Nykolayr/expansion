// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserGame _$$_UserGameFromJson(Map<String, dynamic> json) => _$_UserGame(
      id: json['id'] as String? ?? '0',
      name: json['name'] as String,
      photoURL: json['photoURL'] as String? ?? 'assets/avatar_icon.png',
      score: json['score'] as int? ?? 0,
      isBegin: json['isBegin'] as bool? ?? true,
      isRegistration: json['isRegistration'] as bool? ?? false,
    );

Map<String, dynamic> _$$_UserGameToJson(_$_UserGame instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photoURL': instance.photoURL,
      'score': instance.score,
      'isBegin': instance.isBegin,
      'isRegistration': instance.isRegistration,
    };
