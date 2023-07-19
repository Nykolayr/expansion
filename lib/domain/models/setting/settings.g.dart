// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Settings _$$_SettingsFromJson(Map<String, dynamic> json) => _$_Settings(
      isMusic: json['isMusic'] as bool? ?? true,
      isSound: json['isSound'] as bool? ?? true,
      isIntroduction: json['isIntroduction'] as bool? ?? true,
      lang: $enumDecodeNullable(_$LangEnumMap, json['lang']) ?? Lang.ru,
    );

Map<String, dynamic> _$$_SettingsToJson(_$_Settings instance) =>
    <String, dynamic>{
      'isMusic': instance.isMusic,
      'isSound': instance.isSound,
      'isIntroduction': instance.isIntroduction,
      'lang': _$LangEnumMap[instance.lang]!,
    };

const _$LangEnumMap = {
  Lang.ru: 'ru',
  Lang.en: 'en',
};
