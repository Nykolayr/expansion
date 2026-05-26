/// Тип вселенной / генерации кампании.
enum UniverKind {
  classic,
  generated,
  strategic;

  static UniverKind fromStorage(String? value) {
    return UniverKind.values.asNameMap()[value] ?? UniverKind.classic;
  }

  /// Доступно в v1 клиента.
  bool get isPlayable => this == UniverKind.classic;
}
