import 'dart:convert';

import 'package:expansion/domain/models/entities/types_bases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Scene {
  int id = 0;
  String nameRu = '';
  String nameEn = '';
  String battleRu = '';
  String battleEn = '';
  String descriptionRu = '';
  String descriptionEn = '';
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
      nameRu: jsonMap['nameRu'] as String? ?? '',
      nameEn: jsonMap['nameEn'] as String? ?? '',
      battleRu: jsonMap['battleRu'] as String? ?? '',
      battleEn: jsonMap['battleEn'] as String? ?? '',
      descriptionRu: jsonMap['descriptionRu'] as String? ?? '',
      descriptionEn: jsonMap['descriptionEn'] as String? ?? '',
      typeScene: jsonMap['typeScene'] == null
          ? TypeScene.first
          : TypeScene.values.byName(jsonMap['typeScene'] as String),
      mapBattleList: jsonMap['mapBattleList'] != null
          ? (json.decode(jsonMap['mapBattleList'] as String) as List<dynamic>)
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
        'nameRu': nameRu,
        'nameEn': nameEn,
        'battleRu': battleRu,
        'battleEn': battleEn,
        'descriptionRu': descriptionRu,
        'descriptionEn': descriptionEn,
        'typeScene': typeScene.name,
        'mapBattleList': json.encode(mapBattleList.map((row) {
          return row.map((item) => item?.toJson()).toList();
        }).toList()),
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
