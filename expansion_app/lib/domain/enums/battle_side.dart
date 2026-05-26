enum BattleSide {
  player,
  enemy,
  neutral;

  bool get isPlayer => this == BattleSide.player;
  bool get isEnemy => this == BattleSide.enemy;
  bool get isNeutral => this == BattleSide.neutral;
}
