import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Base extends EntityObject {
  SizeBase sizeBase;
  int timeCapture;
  double speedBuildShips;
  Base(
      {required super.coordinates,
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
      required super.actionObject});

  factory Base.fromJson(Map<String, dynamic> json) {
    final int x = json['coordinates']['x'];
    final int y = json['coordinates']['y'];
    SizeBase sizeBase = SizeBase.values
        .firstWhere((e) => e.toString() == 'SizeBase.${json["typeNeutral"]}');
    final size = sizeBase.add.size;
    return Base(
      coordinates: Size((stepX * x - size / 2) * ratioXY.width,
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
    // required ActionObject actionObject,
    required Function() click,
    required Function(int sender) onAccept,
  }) {
    return Positioned(
      top: coordinates.height,
      left: coordinates.width,
      child: GestureDetector(
        onTap: click,
        child: Stack(
          alignment: Alignment.center,
          children: [
            DragTarget<int>(
              builder: (
                BuildContext context,
                List<dynamic> accepted,
                List<dynamic> rejected,
              ) {
                return Container(
                  padding: const EdgeInsets.all(7),
                  height: sizeBase.add.size,
                  width: sizeBase.add.size,
                  child: Image.asset(
                      '${sizeBase.add.pictire}${typeStatus.name}_base.png'),
                );
              },
              onAccept: (int sender) => onAccept(sender),
            ),
            Positioned(
              bottom: 5,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                color: typeStatus.color,
                child: Text(
                  ships.toString(),
                  style: TextStyle(
                    color: typeStatus.colorText,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            (actionObject == ActionObject.no)
                ? const SizedBox.shrink()
                : Container(
                    height: sizeBase.add.size,
                    width: sizeBase.add.size,
                    padding: const EdgeInsets.all(15),
                    child: SvgPicture.asset(
                      'assets/svg/cursor.svg',
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void update() {
    if (typeStatus == TypeStatus.neutral) return;
    speedBuildShips += speedBuild / 2;
    if (speedBuildShips > maxbuildShips) {
      if (ships < maxShips) {
        ships++;
        speedBuildShips = 0;
      }
    }
  }

  @override
  Widget getText() {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Text('''
Описание: $description. 
Статус: ${typeStatus.desc}.  Имеет щит: $shild. 
Кораблей: $ships. Максимальное количество кораблей: $maxShips. 
Скорость производства: $speedBuild.   
''', textAlign: TextAlign.center),
    );
  }
}

enum SizeBase { base, midleBase }

extension AddExtention on SizeBase {
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
