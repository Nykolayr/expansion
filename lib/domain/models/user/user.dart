import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@Freezed()

/// Класс игрока
class UserGame with _$UserGame {
  const factory UserGame({
    required String name, // имя игрока,
    @Default('0') String id, // id игрока
    @Default('assets/avatar_icon.png') String photoURL, // фото игрока
    @Default(0) int score, // общее количество очков для достижения
    @Default(1) int mapClassic, // номер карты в компании классика
    @Default(true) bool isBegin, // было ли вступление
    @Default(false) bool isRegistration, // была ли регистрация
  }) = _UserGame;
  factory UserGame.init() => const UserGame(
        name: 'Гость',
      );
  factory UserGame.fromJson(Map<String, dynamic> json) =>
      _$UserGameFromJson(json);
}
