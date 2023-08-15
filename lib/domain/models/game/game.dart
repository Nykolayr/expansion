import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'game.freezed.dart';
part 'game.g.dart';

@Freezed()
class Game with _$Game {
  const factory Game({
    @Default(Univer.classic) Univer univer,
    @Default(Level.average) Level level,
    @Default(true) bool isSplash,
    @Default(true) bool isHint,
  }) = _Game;
  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}

/// уровни сложности, отвечают за быстроту мышления AI, скорость кораблей,
/// скорость постройки кораблей, прочность щита, скорость пополнения ресурсов
enum Level {
  easy,
  average,
  difficult;

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

  /// количество тиков для хода врагов
  int get ticEnemy {
    switch (this) {
      case Level.easy:
        return 600;
      case Level.average:
        return 400;
      case Level.difficult:
        return 200;
    }
  }

  double get enemySpeed {
    switch (this) {
      case Level.easy:
        return 0.3;
      case Level.average:
        return 0.5;
      case Level.difficult:
        return 0.7;
    }
  }
}

enum Univer { classic, generated, strategic }
