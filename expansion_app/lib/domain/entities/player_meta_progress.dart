import 'package:equatable/equatable.dart';

import 'package:expansion/domain/entities/meta_upgrade_slot.dart';
import 'package:expansion/domain/enums/meta_upgrade_type.dart';

class PlayerMetaProgress extends Equatable {
  const PlayerMetaProgress({
    required this.slots,
    this.enemyPowerLevel = 0,
  });

  const PlayerMetaProgress.initial()
      : slots = const [],
        enemyPowerLevel = 0;

  factory PlayerMetaProgress.fresh() {
    return PlayerMetaProgress(
      slots: [
        _slot(MetaUpgradeType.shipSpeed, step: 10),
        _slot(MetaUpgradeType.shipDurability, step: 5),
        _slot(MetaUpgradeType.shipBuildSpeed, step: 10),
        _slot(MetaUpgradeType.resourceIncomeSpeed, step: 10),
        _slot(MetaUpgradeType.shieldDurability, step: 15),
        const MetaUpgradeSlot(
          type: MetaUpgradeType.beginShips,
          level: 0,
          percentBonus: 0,
          nextCost: 180,
          stepPercent: 10,
        ),
      ],
    );
  }

  final List<MetaUpgradeSlot> slots;

  /// Счётчик побед (статистика / sync). Темп AI в бою — по туманности миссии
  /// ([CampaignSectors.enemyTurnDividerForMission]), не от этого поля.
  final int enemyPowerLevel;

  MetaUpgradeSlot slotOf(MetaUpgradeType type) =>
      slots.firstWhere((s) => s.type == type);

  double multiplierFor(MetaUpgradeType type) => slotOf(type).multiplier;

  PlayerMetaProgress copyWith({
    List<MetaUpgradeSlot>? slots,
    int? enemyPowerLevel,
  }) {
    return PlayerMetaProgress(
      slots: slots ?? this.slots,
      enemyPowerLevel: enemyPowerLevel ?? this.enemyPowerLevel,
    );
  }

  PlayerMetaProgress? applyUpgrade(MetaUpgradeType type, int availableScore) {
    final index = slots.indexWhere((s) => s.type == type);
    if (index < 0) return null;

    final slot = slots[index];
    if (slot.isMaxed || availableScore < slot.nextCost) return null;

    final updated = slot.copyWith(
      level: slot.level + 1,
      percentBonus: slot.percentBonus + slot.stepPercent,
      nextCost: slot.nextCost * 2,
    );

    final newSlots = List<MetaUpgradeSlot>.from(slots)..[index] = updated;
    return copyWith(slots: newSlots);
  }

  PlayerMetaProgress afterVictory() {
    return copyWith(enemyPowerLevel: enemyPowerLevel + 1);
  }

  static MetaUpgradeSlot _slot(MetaUpgradeType type, {required int step}) {
        return MetaUpgradeSlot(
      type: type,
      level: 0,
      percentBonus: 0,
      nextCost: 180,
      stepPercent: step,
    );
  }

  @override
  List<Object?> get props => [slots, enemyPowerLevel];
}
