// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Game _$GameFromJson(Map<String, dynamic> json) {
  return _Game.fromJson(json);
}

/// @nodoc
mixin _$Game {
  Univer get univer => throw _privateConstructorUsedError;
  Level get level => throw _privateConstructorUsedError;
  bool get isSplash => throw _privateConstructorUsedError;
  bool get isHint => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GameCopyWith<Game> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameCopyWith<$Res> {
  factory $GameCopyWith(Game value, $Res Function(Game) then) =
      _$GameCopyWithImpl<$Res, Game>;
  @useResult
  $Res call({Univer univer, Level level, bool isSplash, bool isHint});
}

/// @nodoc
class _$GameCopyWithImpl<$Res, $Val extends Game>
    implements $GameCopyWith<$Res> {
  _$GameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? univer = null,
    Object? level = null,
    Object? isSplash = null,
    Object? isHint = null,
  }) {
    return _then(_value.copyWith(
      univer: null == univer
          ? _value.univer
          : univer // ignore: cast_nullable_to_non_nullable
              as Univer,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as Level,
      isSplash: null == isSplash
          ? _value.isSplash
          : isSplash // ignore: cast_nullable_to_non_nullable
              as bool,
      isHint: null == isHint
          ? _value.isHint
          : isHint // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GameCopyWith<$Res> implements $GameCopyWith<$Res> {
  factory _$$_GameCopyWith(_$_Game value, $Res Function(_$_Game) then) =
      __$$_GameCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Univer univer, Level level, bool isSplash, bool isHint});
}

/// @nodoc
class __$$_GameCopyWithImpl<$Res> extends _$GameCopyWithImpl<$Res, _$_Game>
    implements _$$_GameCopyWith<$Res> {
  __$$_GameCopyWithImpl(_$_Game _value, $Res Function(_$_Game) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? univer = null,
    Object? level = null,
    Object? isSplash = null,
    Object? isHint = null,
  }) {
    return _then(_$_Game(
      univer: null == univer
          ? _value.univer
          : univer // ignore: cast_nullable_to_non_nullable
              as Univer,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as Level,
      isSplash: null == isSplash
          ? _value.isSplash
          : isSplash // ignore: cast_nullable_to_non_nullable
              as bool,
      isHint: null == isHint
          ? _value.isHint
          : isHint // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Game implements _Game {
  const _$_Game(
      {this.univer = Univer.classic,
      this.level = Level.average,
      this.isSplash = true,
      this.isHint = true});

  factory _$_Game.fromJson(Map<String, dynamic> json) => _$$_GameFromJson(json);

  @override
  @JsonKey()
  final Univer univer;
  @override
  @JsonKey()
  final Level level;
  @override
  @JsonKey()
  final bool isSplash;
  @override
  @JsonKey()
  final bool isHint;

  @override
  String toString() {
    return 'Game(univer: $univer, level: $level, isSplash: $isSplash, isHint: $isHint)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Game &&
            (identical(other.univer, univer) || other.univer == univer) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.isSplash, isSplash) ||
                other.isSplash == isSplash) &&
            (identical(other.isHint, isHint) || other.isHint == isHint));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, univer, level, isSplash, isHint);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GameCopyWith<_$_Game> get copyWith =>
      __$$_GameCopyWithImpl<_$_Game>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GameToJson(
      this,
    );
  }
}

abstract class _Game implements Game {
  const factory _Game(
      {final Univer univer,
      final Level level,
      final bool isSplash,
      final bool isHint}) = _$_Game;

  factory _Game.fromJson(Map<String, dynamic> json) = _$_Game.fromJson;

  @override
  Univer get univer;
  @override
  Level get level;
  @override
  bool get isSplash;
  @override
  bool get isHint;
  @override
  @JsonKey(ignore: true)
  _$$_GameCopyWith<_$_Game> get copyWith => throw _privateConstructorUsedError;
}
