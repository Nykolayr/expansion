import 'package:equatable/equatable.dart';

import 'package:expansion/domain/entities/placed_base.dart';

class BattleLayout extends Equatable {
  const BattleLayout({
    required this.sceneId,
    required this.gridRows,
    required this.gridCols,
    required this.placements,
  });

  final int sceneId;
  final int gridRows;
  final int gridCols;
  final List<PlacedBase> placements;

  @override
  List<Object?> get props => [sceneId, gridRows, gridCols, placements];
}
