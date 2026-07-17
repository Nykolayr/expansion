import 'package:expansion/domain/campaign/campaign_sectors.dart';
import 'package:expansion/domain/entities/player_meta_progress.dart';
import 'package:expansion/domain/enums/meta_upgrade_type.dart';

/// Множители игрока в бою из мета-апгрейдов + темп AI по туманности миссии.
class MetaBattleBonuses {
  const MetaBattleBonuses({
    required this.fleetSpeed,
    required this.attackPower,
    required this.growthSpeed,
    required this.resourceIncome,
    required this.shieldDefense,
    required this.beginShipsBonus,
    required this.enemyTurnDivider,
  });

  factory MetaBattleBonuses.fromProgress(
    PlayerMetaProgress progress, {
    required int sceneId,
  }) {
    return MetaBattleBonuses(
      fleetSpeed: progress.multiplierFor(MetaUpgradeType.shipSpeed),
      attackPower: progress.multiplierFor(MetaUpgradeType.shipDurability),
      growthSpeed: progress.multiplierFor(MetaUpgradeType.shipBuildSpeed),
      resourceIncome:
          progress.multiplierFor(MetaUpgradeType.resourceIncomeSpeed),
      shieldDefense: progress.multiplierFor(MetaUpgradeType.shieldDurability),
      beginShipsBonus: progress.slotOf(MetaUpgradeType.beginShips).percentBonus,
      enemyTurnDivider: CampaignSectors.enemyTurnDividerForMission(sceneId),
    );
  }

  static const MetaBattleBonuses none = MetaBattleBonuses(
    fleetSpeed: 1,
    attackPower: 1,
    growthSpeed: 1,
    resourceIncome: 1,
    shieldDefense: 1,
    beginShipsBonus: 0,
    enemyTurnDivider: 1,
  );

  final double fleetSpeed;
  final double attackPower;
  final double growthSpeed;
  final double resourceIncome;
  final double shieldDefense;
  final int beginShipsBonus;
  final double enemyTurnDivider;
}
