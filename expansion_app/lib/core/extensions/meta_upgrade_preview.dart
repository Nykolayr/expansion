import 'package:expansion/domain/entities/meta_upgrade_slot.dart';
import 'package:expansion/domain/enums/meta_upgrade_type.dart';

extension MetaUpgradePreview on MetaUpgradeSlot {
  String get currentPreview => _formatValue(percentBonus);

  String? get nextPreview =>
      isMaxed ? null : _formatValue(percentBonus + stepPercent);

  String _formatValue(int value) {
    if (type == MetaUpgradeType.beginShips) {
      return '+$value';
    }
    final multiplier = 1 + value / 100;
    if (multiplier == multiplier.roundToDouble()) {
      return '${multiplier.toInt()}×';
    }
    return '${multiplier.toStringAsFixed(2)}×';
  }
}
