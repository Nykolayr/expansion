import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'game.freezed.dart';
part 'game.g.dart';

@Freezed()
class Game with _$Game {
  const factory Game({
    @Default(Univer.classic) Univer univer,
    @Default(Level.average) Level level,
    @Default(true) bool isHint,
  }) = _Game;
  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}

enum Level { easy, average, difficult }

extension LevelExtention on Level {
  String get nameMenu {
    switch (this) {
      case Level.easy:
        return tr('easy');
      case Level.average:
        return tr('average');
      case Level.difficult:
        return tr('difficult');
    }
  }

  double get ratio {
    switch (this) {
      case Level.easy:
        return 0.8;
      case Level.average:
        return 1;
      case Level.difficult:
        return 1.2;
    }
  }
}

enum Univer { classic, generated }
