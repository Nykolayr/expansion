import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@Freezed()

/// Класс игрока
class User with _$User {
  const factory User({
    @Default(0) int id, // id игрока
    @Default('Гость') String name, // имя игрока
    @Default(0) int score, // общее количество очков для достижения
    @Default(true) bool isBegin, // было ли вступление
    @Default(false) bool isRegistration, // было ли регистрация
  }) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
