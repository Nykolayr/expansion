import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/domain/enums/neutral_base_kind.dart';

/// Пути к спрайтам боя (legacy `assets/images/`, скопированы в bundle).
abstract final class BattleAssets {
  static const String playerMain = 'assets/images/our.png';
  static const String enemyMain = 'assets/images/enemy.png';

  static const String neutralBase = 'assets/images/bases/base3.png';
  static const String neutralMiddle = 'assets/images/bases/base2.png';
  static const String neutralSmall = 'assets/images/bases/base1.png';

  static String asteroid(int index) =>
      'assets/images/asteroids/ast${index.clamp(1, 6)}.png';

  static String baseSprite(BattleBase base) {
    switch (base.side) {
      case BattleSide.player:
        return playerMain;
      case BattleSide.enemy:
        return enemyMain;
      case BattleSide.neutral:
        return switch (base.neutralKind) {
          NeutralBaseKind.middleBase => neutralMiddle,
          NeutralBaseKind.base => neutralBase,
          null => neutralSmall,
        };
    }
  }

  static String fleetSprite(BattleSide side) {
    return switch (side) {
      BattleSide.player => playerMain,
      BattleSide.enemy => enemyMain,
      BattleSide.neutral => neutralSmall,
    };
  }
}
