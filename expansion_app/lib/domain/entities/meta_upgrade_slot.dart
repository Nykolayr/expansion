import 'package:equatable/equatable.dart';

import 'package:expansion/domain/enums/meta_upgrade_type.dart';

class MetaUpgradeSlot extends Equatable {
  const MetaUpgradeSlot({
    required this.type,
    required this.level,
    required this.percentBonus,
    required this.nextCost,
    required this.stepPercent,
  });

  final MetaUpgradeType type;
  final int level;
  final int percentBonus;
  final int nextCost;
  final int stepPercent;

  static const int maxLevel = 5;

  bool get isMaxed => level >= maxLevel;

  double get multiplier => 1 + percentBonus / 100;

  MetaUpgradeSlot copyWith({
    int? level,
    int? percentBonus,
    int? nextCost,
  }) {
    return MetaUpgradeSlot(
      type: type,
      level: level ?? this.level,
      percentBonus: percentBonus ?? this.percentBonus,
      nextCost: nextCost ?? this.nextCost,
      stepPercent: stepPercent,
    );
  }

  @override
  List<Object?> get props => [type, level, percentBonus, nextCost, stepPercent];
}
