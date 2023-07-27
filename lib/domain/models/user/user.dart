import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@Freezed()
class User with _$User {
  const factory User({
    required String name,
    @Default(0) int step,
    @Default(0) int score, // общее количество очков для достижения
    @Default(0) int upgrade, // количесство очков для апгрейда
    @Default(true) bool isBegin,
  }) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
