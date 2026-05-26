import 'package:expansion/domain/entities/campaign_scene.dart';
import 'package:expansion/domain/enums/scene_node_kind.dart';

class CampaignSceneRow {
  CampaignSceneRow({
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

  factory CampaignSceneRow.fromMap(Map<String, Object?> map) {
    return CampaignSceneRow(
      id: map['id']! as int,
      displayOrder: map['display_order']! as int,
      nameRu: map['name_ru']! as String,
      nameEn: map['name_en']! as String,
      descriptionRu: map['description_ru']! as String,
      descriptionEn: map['description_en']! as String,
      battleRu: map['battle_ru']! as String,
      battleEn: map['battle_en']! as String,
      nodeKind: SceneNodeKind.values.byName(map['node_kind']! as String),
      gridRows: map['grid_rows']! as int,
      gridCols: map['grid_cols']! as int,
    );
  }

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

  Map<String, Object?> toMap() => {
        'id': id,
        'display_order': displayOrder,
        'name_ru': nameRu,
        'name_en': nameEn,
        'description_ru': descriptionRu,
        'description_en': descriptionEn,
        'battle_ru': battleRu,
        'battle_en': battleEn,
        'node_kind': nodeKind.storageKey,
        'grid_rows': gridRows,
        'grid_cols': gridCols,
      };

  CampaignScene toEntity() => CampaignScene(
        id: id,
        displayOrder: displayOrder,
        nameRu: nameRu,
        nameEn: nameEn,
        descriptionRu: descriptionRu,
        descriptionEn: descriptionEn,
        battleRu: battleRu,
        battleEn: battleEn,
        nodeKind: nodeKind,
        gridRows: gridRows,
        gridCols: gridCols,
      );
}
