import 'package:expansion/domain/entities/player_meta_progress.dart';
import 'package:expansion/domain/enums/meta_upgrade_type.dart';

/// Множители игрока в бою из мета-апгрейдов.
class MetaBattleBonuses {
  const MetaBattleBonuses({
    required this.fleetSpeed,
    required this.attackPower,
    required this.growthSpeed,
    required this.shieldDefense,
    required this.beginShipsBonus,
    required this.enemyTurnDivider,
  });

  factory MetaBattleBonuses.fromProgress(PlayerMetaProgress progress) {
    final enemyDivider =
        1 + progress.enemyPowerLevel * 0.08; // чужие чаще ходят

    return MetaBattleBonuses(
      fleetSpeed: progress.multiplierFor(MetaUpgradeType.shipSpeed),
      attackPower: progress.multiplierFor(MetaUpgradeType.shipDurability),
      growthSpeed: progress.multiplierFor(MetaUpgradeType.shipBuildSpeed),
      shieldDefense: progress.multiplierFor(MetaUpgradeType.shieldDurability),
      beginShipsBonus: progress.slotOf(MetaUpgradeType.beginShips).percentBonus,
      enemyTurnDivider: enemyDivider,
    );
  }

  static const MetaBattleBonuses none = MetaBattleBonuses(
    fleetSpeed: 1,
    attackPower: 1,
    growthSpeed: 1,
    shieldDefense: 1,
    beginShipsBonus: 0,
    enemyTurnDivider: 1,
  );

  final double fleetSpeed;
  final double attackPower;
  final double growthSpeed;
  final double shieldDefense;
  final int beginShipsBonus;
  final double enemyTurnDivider;
}
