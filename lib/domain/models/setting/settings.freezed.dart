// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Settings _$SettingsFromJson(Map<String, dynamic> json) {
  return _Settings.fromJson(json);
}

/// @nodoc
mixin _$Settings {
  bool get isMusic => throw _privateConstructorUsedError;
  bool get isSound => throw _privateConstructorUsedError;
  Lang get lang => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SettingsCopyWith<Settings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsCopyWith<$Res> {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) then) =
      _$SettingsCopyWithImpl<$Res, Settings>;
  @useResult
  $Res call({bool isMusic, bool isSound, Lang lang});
}

/// @nodoc
class _$SettingsCopyWithImpl<$Res, $Val extends Settings>
    implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isMusic = null,
    Object? isSound = null,
    Object? lang = null,
  }) {
    return _then(_value.copyWith(
      isMusic: null == isMusic
          ? _value.isMusic
          : isMusic // ignore: cast_nullable_to_non_nullable
              as bool,
      isSound: null == isSound
          ? _value.isSound
          : isSound // ignore: cast_nullable_to_non_nullable
              as bool,
      lang: null == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as Lang,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SettingsCopyWith<$Res> implements $SettingsCopyWith<$Res> {
  factory _$$_SettingsCopyWith(
          _$_Settings value, $Res Function(_$_Settings) then) =
      __$$_SettingsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isMusic, bool isSound, Lang lang});
}

/// @nodoc
class __$$_SettingsCopyWithImpl<$Res>
    extends _$SettingsCopyWithImpl<$Res, _$_Settings>
    implements _$$_SettingsCopyWith<$Res> {
  __$$_SettingsCopyWithImpl(
      _$_Settings _value, $Res Function(_$_Settings) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isMusic = null,
    Object? isSound = null,
    Object? lang = null,
  }) {
    return _then(_$_Settings(
      isMusic: null == isMusic
          ? _value.isMusic
          : isMusic // ignore: cast_nullable_to_non_nullable
              as bool,
      isSound: null == isSound
          ? _value.isSound
          : isSound // ignore: cast_nullable_to_non_nullable
              as bool,
      lang: null == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as Lang,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Settings extends _Settings {
  const _$_Settings(
      {this.isMusic = true, this.isSound = true, this.lang = Lang.ru})
      : super._();

  factory _$_Settings.fromJson(Map<String, dynamic> json) =>
      _$$_SettingsFromJson(json);

  @override
  @JsonKey()
  final bool isMusic;
  @override
  @JsonKey()
  final bool isSound;
  @override
  @JsonKey()
  final Lang lang;

  @override
  String toString() {
    return 'Settings(isMusic: $isMusic, isSound: $isSound, lang: $lang)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Settings &&
            (identical(other.isMusic, isMusic) || other.isMusic == isMusic) &&
            (identical(other.isSound, isSound) || other.isSound == isSound) &&
            (identical(other.lang, lang) || other.lang == lang));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, isMusic, isSound, lang);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SettingsCopyWith<_$_Settings> get copyWith =>
      __$$_SettingsCopyWithImpl<_$_Settings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SettingsToJson(
      this,
    );
  }
}

abstract class _Settings extends Settings {
  const factory _Settings(
      {final bool isMusic, final bool isSound, final Lang lang}) = _$_Settings;
  const _Settings._() : super._();

  factory _Settings.fromJson(Map<String, dynamic> json) = _$_Settings.fromJson;

  @override
  bool get isMusic;
  @override
  bool get isSound;
  @override
  Lang get lang;
  @override
  @JsonKey(ignore: true)
  _$$_SettingsCopyWith<_$_Settings> get copyWith =>
      throw _privateConstructorUsedError;
}
