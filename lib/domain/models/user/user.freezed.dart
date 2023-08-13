// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserGame _$UserGameFromJson(Map<String, dynamic> json) {
  return _UserGame.fromJson(json);
}

/// @nodoc
mixin _$UserGame {
  String get id => throw _privateConstructorUsedError; // id игрока
  String get name => throw _privateConstructorUsedError; // имя игрока
  String get photoURL => throw _privateConstructorUsedError; // фото игрока
  int get score =>
      throw _privateConstructorUsedError; // общее количество очков для достижения
  bool get isBegin => throw _privateConstructorUsedError; // было ли вступление
  bool get isRegistration => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserGameCopyWith<UserGame> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserGameCopyWith<$Res> {
  factory $UserGameCopyWith(UserGame value, $Res Function(UserGame) then) =
      _$UserGameCopyWithImpl<$Res, UserGame>;
  @useResult
  $Res call(
      {String id,
      String name,
      String photoURL,
      int score,
      bool isBegin,
      bool isRegistration});
}

/// @nodoc
class _$UserGameCopyWithImpl<$Res, $Val extends UserGame>
    implements $UserGameCopyWith<$Res> {
  _$UserGameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? photoURL = null,
    Object? score = null,
    Object? isBegin = null,
    Object? isRegistration = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      photoURL: null == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      isBegin: null == isBegin
          ? _value.isBegin
          : isBegin // ignore: cast_nullable_to_non_nullable
              as bool,
      isRegistration: null == isRegistration
          ? _value.isRegistration
          : isRegistration // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserGameCopyWith<$Res> implements $UserGameCopyWith<$Res> {
  factory _$$_UserGameCopyWith(
          _$_UserGame value, $Res Function(_$_UserGame) then) =
      __$$_UserGameCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String photoURL,
      int score,
      bool isBegin,
      bool isRegistration});
}

/// @nodoc
class __$$_UserGameCopyWithImpl<$Res>
    extends _$UserGameCopyWithImpl<$Res, _$_UserGame>
    implements _$$_UserGameCopyWith<$Res> {
  __$$_UserGameCopyWithImpl(
      _$_UserGame _value, $Res Function(_$_UserGame) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? photoURL = null,
    Object? score = null,
    Object? isBegin = null,
    Object? isRegistration = null,
  }) {
    return _then(_$_UserGame(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      photoURL: null == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      isBegin: null == isBegin
          ? _value.isBegin
          : isBegin // ignore: cast_nullable_to_non_nullable
              as bool,
      isRegistration: null == isRegistration
          ? _value.isRegistration
          : isRegistration // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserGame implements _UserGame {
  const _$_UserGame(
      {this.id = '0',
      required this.name,
      this.photoURL = 'assets/avatar_icon.png',
      this.score = 0,
      this.isBegin = true,
      this.isRegistration = false});

  factory _$_UserGame.fromJson(Map<String, dynamic> json) =>
      _$$_UserGameFromJson(json);

  @override
  @JsonKey()
  final String id;
// id игрока
  @override
  final String name;
// имя игрока
  @override
  @JsonKey()
  final String photoURL;
// фото игрока
  @override
  @JsonKey()
  final int score;
// общее количество очков для достижения
  @override
  @JsonKey()
  final bool isBegin;
// было ли вступление
  @override
  @JsonKey()
  final bool isRegistration;

  @override
  String toString() {
    return 'UserGame(id: $id, name: $name, photoURL: $photoURL, score: $score, isBegin: $isBegin, isRegistration: $isRegistration)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserGame &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.photoURL, photoURL) ||
                other.photoURL == photoURL) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.isBegin, isBegin) || other.isBegin == isBegin) &&
            (identical(other.isRegistration, isRegistration) ||
                other.isRegistration == isRegistration));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, photoURL, score, isBegin, isRegistration);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserGameCopyWith<_$_UserGame> get copyWith =>
      __$$_UserGameCopyWithImpl<_$_UserGame>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserGameToJson(
      this,
    );
  }
}

abstract class _UserGame implements UserGame {
  const factory _UserGame(
      {final String id,
      required final String name,
      final String photoURL,
      final int score,
      final bool isBegin,
      final bool isRegistration}) = _$_UserGame;

  factory _UserGame.fromJson(Map<String, dynamic> json) = _$_UserGame.fromJson;

  @override
  String get id;
  @override // id игрока
  String get name;
  @override // имя игрока
  String get photoURL;
  @override // фото игрока
  int get score;
  @override // общее количество очков для достижения
  bool get isBegin;
  @override // было ли вступление
  bool get isRegistration;
  @override
  @JsonKey(ignore: true)
  _$$_UserGameCopyWith<_$_UserGame> get copyWith =>
      throw _privateConstructorUsedError;
}
