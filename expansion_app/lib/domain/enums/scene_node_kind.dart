/// Позиция узла в ряду карты (траектории анимации, legacy `TypeScene`).
enum SceneNodeKind {
  first,
  second,
  third,
  fourth,
  fifth;

  static SceneNodeKind forColumnIndex(int columnInRow) {
    return SceneNodeKind.values[columnInRow.clamp(0, 4)];
  }

  String get storageKey => name;
}
