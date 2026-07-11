import 'package:expansion/domain/entities/battle_asteroid.dart';
import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/enums/battle_hazard_kind.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/domain/enums/battle_visual_id.dart';
import 'package:expansion/domain/enums/neutral_base_kind.dart';
import 'package:expansion/domain/enums/neutral_base_variant.dart';

/// Пути к спрайтам боя. [BattleVisualId] — канон имён; top-down PNG в `assets/images/`.
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

  /// Целевые пути (файлы появятся на арт-пассе).
  static const Map<BattleVisualId, String> targetAssetPaths = {
    BattleVisualId.hqPlayer: 'assets/images/hq_player.png',
    BattleVisualId.hqEnemy: 'assets/images/hq_enemy.png',
    BattleVisualId.baseSmall: 'assets/images/bases/base_small.png',
    BattleVisualId.baseMedium: 'assets/images/bases/base_medium.png',
    BattleVisualId.baseLarge: 'assets/images/bases/base_large.png',
    BattleVisualId.baseRich: 'assets/images/bases/base_rich.png',
    BattleVisualId.baseShielded: 'assets/images/bases/base_shielded.png',
    BattleVisualId.baseFactory: 'assets/images/bases/base_factory.png',
    BattleVisualId.baseBunker: 'assets/images/bases/base_bunker.png',
    BattleVisualId.hazardAsteroid: 'assets/images/hazards/asteroid.png',
    BattleVisualId.hazardComet: 'assets/images/hazards/comet.png',
    BattleVisualId.hazardDebris: 'assets/images/hazards/debris_cloud.png',
    BattleVisualId.hazardPulse: 'assets/images/hazards/energy_pulse.png',
    BattleVisualId.hazardDrone: 'assets/images/hazards/rogue_drone.png',
    BattleVisualId.hazardMine: 'assets/images/hazards/mine.png',
    BattleVisualId.hazardSolarWind: 'assets/images/hazards/solar_wind.png',
    BattleVisualId.hazardWormhole: 'assets/images/hazards/wormhole.png',
    BattleVisualId.fleetPlayer: 'assets/svg/our_ship.svg',
    BattleVisualId.fleetEnemy: 'assets/svg/enemy_ship.svg',
  };

  static String asteroid(int index) =>
      'assets/images/asteroids/ast${index.clamp(1, 6)}.png';

  static BattleVisualId visualIdFor(BattleBase base) {
    if (base.isCommandBase) {
      return switch (base.side) {
        BattleSide.player => BattleVisualId.hqPlayer,
        BattleSide.enemy => BattleVisualId.hqEnemy,
        BattleSide.neutral => BattleVisualId.baseSmall,
      };
    }

    return switch (base.neutralVariant) {
      NeutralBaseVariant.rich => BattleVisualId.baseRich,
      NeutralBaseVariant.shielded => BattleVisualId.baseShielded,
      NeutralBaseVariant.factory => BattleVisualId.baseFactory,
      NeutralBaseVariant.bunker => BattleVisualId.baseBunker,
      null => switch (base.neutralKind) {
          NeutralBaseKind.smallBase => BattleVisualId.baseSmall,
          NeutralBaseKind.middleBase => BattleVisualId.baseMedium,
          NeutralBaseKind.base => BattleVisualId.baseLarge,
          null => BattleVisualId.baseSmall,
        },
    };
  }

  static String hazardSprite(BattleAsteroid hazard) {
    return switch (hazard.kind) {
      BattleHazardKind.debris => _placeholderPath(BattleVisualId.hazardDebris),
      BattleHazardKind.asteroid => asteroid(hazard.visualIndex),
      BattleHazardKind.comet => _placeholderPath(BattleVisualId.hazardComet),
      BattleHazardKind.pulse => _placeholderPath(BattleVisualId.hazardPulse),
      BattleHazardKind.mine => _placeholderPath(BattleVisualId.hazardMine),
      BattleHazardKind.solarWind =>
        _placeholderPath(BattleVisualId.hazardSolarWind),
      BattleHazardKind.wormhole =>
        _placeholderPath(BattleVisualId.hazardWormhole),
    };
  }

  static String baseSprite(BattleBase base) {
    return _placeholderPath(visualIdFor(base));
  }

  static String _spritePath(BattleVisualId id) {
    return targetAssetPaths[id] ?? neutralSmall;
  }

  static String _placeholderPath(BattleVisualId id) {
    return switch (id) {
      BattleVisualId.hqPlayer => _spritePath(id),
      BattleVisualId.hqEnemy => _spritePath(id),
      BattleVisualId.baseSmall => _spritePath(id),
      BattleVisualId.baseMedium => _spritePath(id),
      BattleVisualId.baseLarge => _spritePath(id),
      BattleVisualId.baseRich => _spritePath(id),
      BattleVisualId.baseShielded => _spritePath(id),
      BattleVisualId.baseFactory => _spritePath(id),
      BattleVisualId.baseBunker => _spritePath(id),
      BattleVisualId.hazardAsteroid => _spritePath(id),
      BattleVisualId.hazardComet => _spritePath(id),
      BattleVisualId.hazardDebris => _spritePath(id),
      BattleVisualId.hazardPulse => _spritePath(id),
      BattleVisualId.hazardDrone => _spritePath(id),
      BattleVisualId.hazardMine => _spritePath(id),
      BattleVisualId.hazardSolarWind => _spritePath(id),
      BattleVisualId.hazardWormhole => _spritePath(id),
      BattleVisualId.fleetPlayer => playerFleet,
      BattleVisualId.fleetEnemy => enemyFleet,
    };
  }

  static double baseSpriteScaleFactor(BattleBase base) {
    if (base.isCommandBase) {
      return 1.15;
    }

    final id = visualIdFor(base);
    return switch (id) {
      BattleVisualId.baseSmall => 0.78,
      BattleVisualId.baseMedium => 0.9,
      BattleVisualId.baseLarge => 1.0,
      BattleVisualId.baseRich => 0.78,
      BattleVisualId.baseShielded => 0.9,
      BattleVisualId.baseFactory => 0.72,
      BattleVisualId.baseBunker => 1.08,
      _ => 0.78,
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
