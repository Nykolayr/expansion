import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@Freezed()

/// Класс игрока
class UserGame with _$UserGame {
  const factory UserGame({
    @Default('0') String id, // id игрока
    required String name, // имя игрока
    @Default('assets/avatar_icon.png') String photoURL, // фото игрока
    @Default(0) int score, // общее количество очков для достижения
    @Default(1) int mapClassic, // номер карты в компании классика
    @Default(true) bool isBegin, // было ли вступление
    @Default(false) bool isRegistration, // было ли регистрация
  }) = _UserGame;
  factory UserGame.init() => const UserGame(
        id: '0',
        name: 'Гость',
        photoURL: 'assets/avatar_icon.png',
        score: 0,
        isBegin: true,
        isRegistration: false,
      );
  factory UserGame.fromJson(Map<String, dynamic> json) =>
      _$UserGameFromJson(json);
}
