import 'dart:convert';

import 'package:expansion/domain/models/entities/types_bases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Класс Scene представляет сцену в игре.
/// Содержит основную информацию о сцене - id, названия на русском и английском,
/// описания на двух языках, тип сцены, список игровых карт для битвы.

class Scene {
  int id;
  String nameRu;
  String nameEn;
  String battleRu;
  String battleEn;
  String descriptionRu;
  String descriptionEn;
  TypeScene typeScene = TypeScene.first;
  List<List<BaseMap?>> mapBattleList = [];

  Scene({
    required this.id,
    required this.nameRu,
    required this.nameEn,
    required this.battleRu,
    required this.battleEn,
    required this.descriptionRu,
    required this.descriptionEn,
    required this.typeScene,
    required this.mapBattleList,
  });

  factory Scene.fromJson(Map<String, dynamic> jsonMap) {
    return Scene(
      id: jsonMap['id'] as int? ?? 0,
      nameRu: jsonMap['name_ru'] as String? ?? '',
      nameEn: jsonMap['name_en'] as String? ?? '',
      battleRu: jsonMap['battle_ru'] as String? ?? '',
      battleEn: jsonMap['battle_en'] as String? ?? '',
      descriptionRu: jsonMap['description_ru'] as String? ?? '',
      descriptionEn: jsonMap['description_en'] as String? ?? '',
      typeScene: jsonMap['type_scene'] == null
          ? TypeScene.first
          : TypeScene.values.byName(jsonMap['type_scene'] as String),
      mapBattleList: jsonMap['map_battle_list'] != null
          ? (json.decode(jsonMap['map_battle_list'] as String) as List<dynamic>)
              .map((row) {
              return (row as List<dynamic>).map((item) {
                return item != null
                    ? BaseMap.fromJson(item as Map<String, dynamic>)
                    : null;
              }).toList();
            }).toList()
          : [],
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'name_ru': nameRu,
        'name_en': nameEn,
        'battle_ru': battleRu,
        'battle_en': battleEn,
        'description_ru': descriptionRu,
        'description_en': descriptionEn,
        'type_scene': typeScene.index,
        'map_battle_list': mapBattleList
      };
}

enum TypeScene {
  first,
  second,
  third,
  fourth,
  fifth;

  double get padding {
    switch (this) {
      case TypeScene.first:
      case TypeScene.third:
      case TypeScene.fifth:
        return 0;
      case TypeScene.second:
      case TypeScene.fourth:
        return 35.h;
    }
  }

  FlyTarget get flyEven {
    switch (this) {
      case TypeScene.first:
        return FlyTarget(begin: Offset(40.w, 40.h), end: Offset(40.w, 160.h));
      case TypeScene.second:
      case TypeScene.fourth:
        return FlyTarget(begin: Offset(40.w, 75.h), end: Offset(-37.w, 40.h));
      case TypeScene.third:
        return FlyTarget(begin: Offset(40.w, 40.h), end: Offset(-37.w, 75.h));
      case TypeScene.fifth:
        return FlyTarget(begin: Offset(40.w, 40.h), end: Offset(-37.w, 75.h));
    }
  }

  FlyTarget get flyOdd {
    switch (this) {
      case TypeScene.first:
      case TypeScene.third:
        return FlyTarget(begin: Offset(42.w, 40.h), end: Offset(120.w, 77.h));
      case TypeScene.second:
      case TypeScene.fourth:
        return FlyTarget(begin: Offset(40.w, 77.h), end: Offset(120.w, 40.h));
      case TypeScene.fifth:
        return FlyTarget(begin: Offset(40.w, 40.h), end: Offset(42.w, 160.h));
    }
  }
}

/// класс для AnimatedPositioned движения объекта
class FlyTarget {
  Offset begin;
  Offset end;
  FlyTarget({required this.begin, required this.end});
}
