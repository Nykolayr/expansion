import 'package:equatable/equatable.dart';

import 'package:expansion/domain/entities/grid_position.dart';
import 'package:expansion/domain/enums/neutral_base_kind.dart';
import 'package:expansion/domain/enums/placement_role.dart';

class PlacedBase extends Equatable {
  const PlacedBase({
    required this.sceneId,
    required this.role,
    required this.position,
    this.neutralKind,
    this.statsJson,
  });

  final int sceneId;
  final PlacementRole role;
  final GridPosition position;
  final NeutralBaseKind? neutralKind;

  /// Параметры главных баз (щит, корабли…) — JSON для фазы боя.
  final String? statsJson;

  @override
  List<Object?> get props => [sceneId, role, position, neutralKind, statsJson];
}
