enum GameDifficulty {
  easy,
  average,
  difficult;

  static GameDifficulty fromStorage(String? value) {
    return GameDifficulty.values.asNameMap()[value] ?? GameDifficulty.average;
  }
}
