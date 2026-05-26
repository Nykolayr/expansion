import 'package:equatable/equatable.dart';

import 'package:expansion/domain/enums/scene_node_kind.dart';

class CampaignScene extends Equatable {
  const CampaignScene({
    required this.id,
    required this.displayOrder,
    required this.nameRu,
    required this.nameEn,
    required this.descriptionRu,
    required this.descriptionEn,
    required this.battleRu,
    required this.battleEn,
    required this.nodeKind,
    required this.gridRows,
    required this.gridCols,
  });

  final int id;
  final int displayOrder;
  final String nameRu;
  final String nameEn;
  final String descriptionRu;
  final String descriptionEn;
  final String battleRu;
  final String battleEn;
  final SceneNodeKind nodeKind;
  final int gridRows;
  final int gridCols;

  @override
  List<Object?> get props => [
        id,
        displayOrder,
        nameRu,
        nameEn,
        descriptionRu,
        descriptionEn,
        battleRu,
        battleEn,
        nodeKind,
        gridRows,
        gridCols,
      ];
}
