import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/domain/enums/neutral_base_kind.dart';

/// Пути к спрайтам боя (legacy `assets/images/`, `assets/svg/`).
abstract final class BattleAssets {
  static const String playerMain = 'assets/images/our.png';
  static const String enemyMain = 'assets/images/enemy.png';

  static const String neutralSmall = 'assets/images/bases/base1.png';
  static const String neutralMiddle = 'assets/images/bases/base2.png';
  static const String neutralLarge = 'assets/images/bases/base3.png';

  static const String playerFleet = 'assets/svg/our_ship.svg';
  static const String enemyFleet = 'assets/svg/enemy_ship.svg';

  static const String battleWinArt = 'assets/images/win.png';
  static const String battleDefeatArt = 'assets/images/lost.png';

  static String asteroid(int index) =>
      'assets/images/asteroids/ast${index.clamp(1, 6)}.png';

  static String baseSprite(BattleBase base) {
    if (base.side == BattleSide.neutral) {
      return _neutralSprite(base.neutralKind);
    }
    if (base.isCommandBase) {
      return switch (base.side) {
        BattleSide.player => playerMain,
        BattleSide.enemy => enemyMain,
        BattleSide.neutral => neutralSmall,
      };
    }
    return _neutralSprite(base.neutralKind);
  }

  static String _neutralSprite(NeutralBaseKind? kind) {
    return switch (kind) {
      NeutralBaseKind.smallBase => neutralSmall,
      NeutralBaseKind.middleBase => neutralMiddle,
      NeutralBaseKind.base => neutralLarge,
      null => neutralSmall,
    };
  }

  static double baseSpriteScaleFactor(BattleBase base) {
    if (base.isCommandBase) {
      return 1.15;
    }
    return switch (base.neutralKind) {
      NeutralBaseKind.smallBase => 0.78,
      NeutralBaseKind.middleBase => 0.9,
      NeutralBaseKind.base => 1.0,
      null => 0.78,
    };
  }

  static String fleetSprite(BattleSide side) {
    return switch (side) {
      BattleSide.player => playerFleet,
      BattleSide.enemy => enemyFleet,
      BattleSide.neutral => playerFleet,
    };
  }

  static String explosionFrame(int frameIndex) {
    final n = frameIndex.clamp(1, 9);
    return 'assets/images/explosion/explosion_${n.toString().padLeft(2, '0')}.png';
  }
}
