import 'dart:math';

import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/ui/widgets/widgets.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';

class Base extends BaseObject {
  SizeBase sizeBase;
  int timeCapture;
  double speedBuildShips;
  Base({
    required super.coordinates,
    required super.description,
    required super.maxShips,
    required super.shild,
    required super.ships,
    required super.speedBuild,
    required super.speedResources,
    required super.resources,
    required super.typeStatus,
    required this.sizeBase,
    required this.timeCapture,
    required this.speedBuildShips,
    required super.actionObject,
    required super.size,
    required super.index,
  });

  factory Base.fromJson(Map<String, dynamic> json) {
    final int x = json['coordinates']['x'];
    final int y = json['coordinates']['y'];
    SizeBase sizeBase = SizeBase.values
        .firstWhere((e) => e.toString() == 'SizeBase.${json["typeNeutral"]}');
    final double size = sizeBase.add.size;
    return Base(
      coordinates: Point((stepX * x - size / 2) * ratioXY.width,
          (stepY * y - size / 2) * ratioXY.height),
      ships: sizeBase.add.maxShips,
      description: sizeBase.add.description,
      sizeBase: sizeBase,
      timeCapture: sizeBase.add.timeCapture,
      maxShips: sizeBase.add.maxShips,
      shild: sizeBase.add.shild,
      speedBuild: sizeBase.add.speedBuild,
      speedResources: sizeBase.add.speedResources,
      resources: 0.0,
      typeStatus: TypeStatus.values.firstWhere(
          (e) => e.toString() == 'TypeStatus.${json["typeStatus"]}'),
      speedBuildShips: 0,
      actionObject: ActionObject.no,
      size: size,
      index: 0,
    );
  }
  Map<String, dynamic> toJson() => {
        "coordinates": coordinates,
        "description": description,
        "maxShips": maxShips,
        "shild": shild,
        "ships": ships,
        "speedBuild": speedBuild,
        "speedResources": speedResources,
        "SizeBase": sizeBase,
        "resources": resources,
        "typeStatus": typeStatus,
      };

  @override
  Widget build({
    required int index,
    required BuildContext context,
    Function()? click,
    Function(int sender)? onAccept,
  }) {
    return Positioned(
      top: coordinates.y.toDouble(),
      left: coordinates.x.toDouble(),
      child: GestureDetector(
        onTap: click,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Draggable<int>(
              data: index,
              feedback: const SizedBox(
                width: 60,
                height: 60,
              ),
              child: DragTarget<int>(
                builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                ) {
                  return Container(
                    padding: const EdgeInsets.all(2),
                    height: sizeBase.add.size.toDouble(),
                    width: sizeBase.add.size.toDouble(),
                    decoration: typeStatus.boxDecor,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: shild > 0 ? AppColor.shildBox : null,
                      child: Image.asset('${sizeBase.add.pictire}base.png'),
                    ),
                  );
                },
                onAccept: (int sender) {
                  if (gameRepository.gameData.bases[sender].typeStatus ==
                      TypeStatus.our) onAccept!(sender);
                },
              ),
            ),
            Positioned(
              bottom: 5,
              child: getInfo(this),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void update() {
    if (typeStatus == TypeStatus.neutral) return;
    speedBuildShips += speedBuild;
    if (speedBuildShips > maxbuildShips) {
      if (ships < maxShips) {
        ships++;
        speedBuildShips = 0;
      }
    }
  }
}

enum SizeBase {
  base,
  midleBase;

  BaseAdd get add {
    switch (this) {
      case SizeBase.base:
        return BaseAdd(
          description: "Нейтральный объект",
          pictire: 'assets/images/',
          maxShips: 100,
          shild: 0.0,
          speedBuild: 1.0,
          speedResources: 1.0,
          size: 60,
          timeCapture: 100,
        );
      case SizeBase.midleBase:
        return BaseAdd(
          description: "Нейтральный средний объект",
          pictire: 'assets/images/',
          maxShips: 130,
          shild: 0.0,
          speedBuild: 1.0,
          speedResources: 1.0,
          size: 80,
          timeCapture: 100,
        );
    }
  }
}

/// дополнительный базовый класс для base для  enum
class BaseAdd {
  String pictire;
  String description;
  int maxShips;
  double shild;
  double speedBuild;
  double speedResources;
  double size;
  int timeCapture;

  BaseAdd({
    required this.description,
    required this.pictire,
    required this.maxShips,
    required this.shild,
    required this.speedBuild,
    required this.speedResources,
    required this.size,
    required this.timeCapture,
  });
}
