import 'dart:convert';

import 'package:expansion/domain/entities/grid_position.dart';
import 'package:expansion/domain/entities/placed_base.dart';
import 'package:expansion/domain/enums/neutral_base_kind.dart';
import 'package:expansion/domain/enums/placement_role.dart';

class BattlePlacementRow {
  BattlePlacementRow({
    required this.sceneId,
    required this.role,
    required this.x,
    required this.y,
    this.neutralKind,
    this.statsJson,
  });

  factory BattlePlacementRow.fromMap(Map<String, Object?> map) {
    final kind = map['neutral_kind'] as String?;
    return BattlePlacementRow(
      sceneId: map['scene_id']! as int,
      role: PlacementRole.fromStorage(map['role']! as String),
      x: map['x']! as int,
      y: map['y']! as int,
      neutralKind: kind == null
          ? null
          : NeutralBaseKind.values.byName(kind),
      statsJson: map['stats_json'] as String?,
    );
  }

  final int sceneId;
  final PlacementRole role;
  final int x;
  final int y;
  final NeutralBaseKind? neutralKind;
  final String? statsJson;

  Map<String, Object?> toMap() => {
        'scene_id': sceneId,
        'role': role.storageKey,
        'x': x,
        'y': y,
        'neutral_kind': neutralKind?.storageKey,
        'stats_json': statsJson,
      };

  PlacedBase toEntity() => PlacedBase(
        sceneId: sceneId,
        role: role,
        position: GridPosition(x: x, y: y),
        neutralKind: neutralKind,
        statsJson: statsJson,
      );
}

/// Сериализация блока главной базы из legacy JSON (без path/size).
String encodeMainBaseStats(Map<String, dynamic> json) {
  final copy = Map<String, dynamic>.from(json)
    ..remove('coordinates')
    ..remove('path')
    ..remove('size');
  return jsonEncode(copy);
}
