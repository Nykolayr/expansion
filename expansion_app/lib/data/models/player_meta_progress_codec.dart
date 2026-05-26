import 'dart:convert';

import 'package:expansion/domain/entities/meta_upgrade_slot.dart';
import 'package:expansion/domain/entities/player_meta_progress.dart';
import 'package:expansion/domain/enums/meta_upgrade_type.dart';

abstract final class PlayerMetaProgressCodec {
  static String encode(PlayerMetaProgress progress) {
    return jsonEncode({
      'enemyPowerLevel': progress.enemyPowerLevel,
      'slots': progress.slots
          .map(
            (s) => {
              'type': s.type.name,
              'level': s.level,
              'percentBonus': s.percentBonus,
              'nextCost': s.nextCost,
              'stepPercent': s.stepPercent,
            },
          )
          .toList(),
    });
  }

  static PlayerMetaProgress decode(String? raw) {
    if (raw == null || raw.isEmpty) return PlayerMetaProgress.fresh();
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final slotsJson = map['slots'] as List<dynamic>;
      final slots = slotsJson.map((item) {
        final m = item as Map<String, dynamic>;
        return MetaUpgradeSlot(
          type: MetaUpgradeType.values.byName(m['type'] as String),
          level: m['level'] as int,
          percentBonus: m['percentBonus'] as int,
          nextCost: m['nextCost'] as int,
          stepPercent: m['stepPercent'] as int,
        );
      }).toList();
      return PlayerMetaProgress(
        slots: slots,
        enemyPowerLevel: map['enemyPowerLevel'] as int? ?? 0,
      );
    } catch (_) {
      return PlayerMetaProgress.fresh();
    }
  }
}
