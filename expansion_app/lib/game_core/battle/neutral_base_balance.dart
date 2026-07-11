import 'package:expansion/domain/enums/neutral_base_kind.dart';
import 'package:expansion/domain/enums/neutral_base_variant.dart';

/// Стартовые параметры нейтральных баз по размеру и спец-варианту.
///
/// Базовые small / middle / large отличаются **только лимитом** кораблей.
/// Спец-варианты ([NeutralBaseVariant]) — другие пропорции и завышенные значения.
abstract final class NeutralBaseBalance {
  static const double standardSpeedBuild = 0.1;
  static const double standardSpeedResources = 0.15;

  static const int smallMaxShips = 30;
  static const int middleMaxShips = 50;
  static const int largeMaxShips = 80;

  static const int smallStartShips = 20;
  static const int middleStartShips = 40;
  static const int largeStartShips = 60;
  static NeutralBaseProfile profileFor({
    required NeutralBaseKind kind,
    NeutralBaseVariant? variant,
  }) {
    final base = _baseForKind(kind);
    return _applyVariant(base, kind, variant);
  }

  static NeutralBaseProfile fromJsonMap(Map<String, dynamic> map) {
    final kindName = map['neutralKind'] as String?;
    final kind = kindName == null
        ? NeutralBaseKind.smallBase
        : NeutralBaseKind.values.byName(kindName);
    final variant = NeutralBaseVariant.fromLegacy(map['variant'] as String?);
    var profile = profileFor(kind: kind, variant: variant);

    profile = profile.copyWith(
      ships: _intOverride(map['ships']) ?? _intOverride(map['inicialShips']),
      shield: _doubleOverride(map['shild']) ?? _doubleOverride(map['shield']),
      maxShips: _intOverride(map['maxShips']),
      speedBuild: _doubleOverride(map['speedBuild']),
      speedResources: _doubleOverride(map['speedResources']),
    );

    return profile;
  }

  static Map<String, dynamic> encodePlacement({
    required NeutralBaseKind kind,
    NeutralBaseVariant? variant,
    Map<String, dynamic> overrides = const {},
  }) {
    var profile = profileFor(kind: kind, variant: variant);
    profile = profile.copyWith(
      ships: _intOverride(overrides['ships']) ??
          _intOverride(overrides['inicialShips']),
      shield: _doubleOverride(overrides['shild']) ??
          _doubleOverride(overrides['shield']),
      maxShips: _intOverride(overrides['maxShips']),
      speedBuild: _doubleOverride(overrides['speedBuild']),
      speedResources: _doubleOverride(overrides['speedResources']),
    );

    return profile.toJson(kind: kind, variant: variant);
  }

  static NeutralBaseProfile _baseForKind(NeutralBaseKind kind) {
    return switch (kind) {
      NeutralBaseKind.smallBase => const NeutralBaseProfile(
          ships: smallStartShips,
          shield: 0,
          maxShips: smallMaxShips,
          speedBuild: standardSpeedBuild,
          speedResources: standardSpeedResources,
        ),
      NeutralBaseKind.middleBase => const NeutralBaseProfile(
          ships: middleStartShips,
          shield: 0,
          maxShips: middleMaxShips,
          speedBuild: standardSpeedBuild,
          speedResources: standardSpeedResources,
        ),
      NeutralBaseKind.base => const NeutralBaseProfile(
          ships: largeStartShips,
          shield: 0,
          maxShips: largeMaxShips,
          speedBuild: standardSpeedBuild,
          speedResources: standardSpeedResources,
        ),
    };
  }

  static NeutralBaseProfile _applyVariant(
    NeutralBaseProfile base,
    NeutralBaseKind kind,
    NeutralBaseVariant? variant,
  ) {
    if (variant == null) return base;

    return switch (variant) {
      NeutralBaseVariant.rich => base.copyWith(
          speedResources: base.speedResources * 1.6,
        ),
      NeutralBaseVariant.shielded => base.copyWith(
          shield: switch (kind) {
            NeutralBaseKind.smallBase => 30,
            NeutralBaseKind.middleBase => 40,
            NeutralBaseKind.base => 50,
          },
        ),
      NeutralBaseVariant.factory => base.copyWith(
          ships: (base.ships * 0.7).round().clamp(1, 999),
          speedBuild: base.speedBuild * 1.4,
        ),
      NeutralBaseVariant.bunker => base.copyWith(
          maxShips: (base.maxShips * 1.4).round(),
          speedBuild: base.speedBuild * 0.75,
        ),
    };
  }

  static int? _intOverride(Object? value) {
    if (value is int) return value;
    if (value is num) return value.round();
    return null;
  }

  static double? _doubleOverride(Object? value) {
    if (value is num) return value.toDouble();
    return null;
  }
}

/// Числовой профиль нейтральной базы для боя и сида SQLite.
class NeutralBaseProfile {
  const NeutralBaseProfile({
    required this.ships,
    required this.shield,
    required this.maxShips,
    required this.speedBuild,
    required this.speedResources,
  });

  final int ships;
  final double shield;
  final int maxShips;
  final double speedBuild;
  final double speedResources;

  NeutralBaseProfile copyWith({
    int? ships,
    double? shield,
    int? maxShips,
    double? speedBuild,
    double? speedResources,
  }) {
    return NeutralBaseProfile(
      ships: ships ?? this.ships,
      shield: shield ?? this.shield,
      maxShips: maxShips ?? this.maxShips,
      speedBuild: speedBuild ?? this.speedBuild,
      speedResources: speedResources ?? this.speedResources,
    );
  }

  Map<String, dynamic> toJson({
    required NeutralBaseKind kind,
    NeutralBaseVariant? variant,
  }) {
    return {
      'ships': ships,
      'shild': shield,
      'maxShips': maxShips,
      'speedBuild': speedBuild,
      'speedResources': speedResources,
      'neutralKind': kind.name,
      if (variant != null) 'variant': variant.storageKey,
    };
  }
}
