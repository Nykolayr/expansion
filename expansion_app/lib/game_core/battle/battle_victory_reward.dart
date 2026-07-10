/// Разбивка очков за победу в миссии.
class BattleVictoryReward {
  const BattleVictoryReward({
    required this.basePoints,
    required this.missionBonus,
  });

  final int basePoints;
  final int missionBonus;

  int get total => basePoints + missionBonus;
}

/// Формулы награды (v0 — итерации по playtest-checklist).
abstract final class BattleRewardCalculator {
  static const int basePoints = 40;

  static BattleVictoryReward forMission(int sceneId) {
    final missionBonus = sceneId * 12;
    return BattleVictoryReward(
      basePoints: basePoints,
      missionBonus: missionBonus,
    );
  }
}
