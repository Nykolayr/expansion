enum PlacementRole {
  playerMain,
  enemyMain,
  neutral;

  String get storageKey {
    switch (this) {
      case PlacementRole.playerMain:
        return 'player_main';
      case PlacementRole.enemyMain:
        return 'enemy_main';
      case PlacementRole.neutral:
        return 'neutral';
    }
  }

  static PlacementRole fromStorage(String value) {
    switch (value) {
      case 'player_main':
        return PlacementRole.playerMain;
      case 'enemy_main':
        return PlacementRole.enemyMain;
      default:
        return PlacementRole.neutral;
    }
  }
}
