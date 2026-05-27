/// Размер нейтральной базы (legacy `TypeBase` small / midle / base).
enum NeutralBaseKind {
  smallBase,
  middleBase,
  base;

  static NeutralBaseKind? fromLegacyType(String? value) {
    if (value == null || value.isEmpty) return NeutralBaseKind.smallBase;
    switch (value) {
      case 'smallBase':
        return NeutralBaseKind.smallBase;
      case 'midleBase':
      case 'middleBase':
        return NeutralBaseKind.middleBase;
      case 'base':
        return NeutralBaseKind.base;
      default:
        return NeutralBaseKind.smallBase;
    }
  }

  String get storageKey => name;
}
