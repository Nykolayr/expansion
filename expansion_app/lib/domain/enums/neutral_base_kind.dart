enum NeutralBaseKind {
  base,
  middleBase;

  static NeutralBaseKind? fromLegacyType(String? value) {
    if (value == null || value.isEmpty) return null;
    switch (value) {
      case 'base':
        return NeutralBaseKind.base;
      case 'midleBase':
      case 'middleBase':
        return NeutralBaseKind.middleBase;
      default:
        return NeutralBaseKind.base;
    }
  }

  String get storageKey => name;
}
