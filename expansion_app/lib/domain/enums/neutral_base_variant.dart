/// Спец-профиль захватываемой базы (поверх размера small/middle/large).
enum NeutralBaseVariant {
  rich,
  shielded,
  factory,
  bunker;

  static NeutralBaseVariant? fromLegacy(String? value) {
    if (value == null || value.isEmpty) return null;
    return switch (value) {
      'rich' => NeutralBaseVariant.rich,
      'shielded' => NeutralBaseVariant.shielded,
      'factory' => NeutralBaseVariant.factory,
      'bunker' => NeutralBaseVariant.bunker,
      _ => null,
    };
  }

  String get storageKey => name;
}
