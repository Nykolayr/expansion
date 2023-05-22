import 'dart:math';

import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/ui/widgets/widgets.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BaseShip extends BaseObject {
  String path;
  double speedBuildShips;
  BaseShip({
    required super.coordinates,
    required super.description,
    required super.maxShips,
    required super.shild,
    required super.ships,
    required super.speedBuild,
    required super.speedResources,
    required super.resources,
    required super.typeStatus,
    required super.size,
    required this.path,
    required this.speedBuildShips,
    required super.actionObject,
    required super.isAttack,
  });
  factory BaseShip.fromJson(Map<String, dynamic> json) {
    final int x = json['coordinates']['x'];
    final int y = json['coordinates']['y'];
    final size = json['size'];
    final num pozY = (y == 1)
        ? (80 - size / 2)
        : (standardDeviceSize.height - 130 - size / 2);
    return BaseShip(
      coordinates:
          Point((stepX * x - size / 2) * ratioXY.width, pozY * ratioXY.height),
      description: json['description'],
      shild: json['shild'],
      ships: json['ships'],
      speedBuild: json['speedBuild'],
      speedResources: json['speedResources'],
      resources: 0.0,
      maxShips: json['maxShips'],
      typeStatus: TypeStatus.values.firstWhere(
          (e) => e.toString() == 'TypeStatus.${json["typeStatus"]}'),
      size: size.toDouble(),
      path: json['path'],
      speedBuildShips: 0,
      actionObject: ActionObject.no,
      isAttack: false,
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
        "size": size,
        "resources": resources,
        "typeStatus": typeStatus,
        "path": path,
      };

  @override
  Widget build({
    required int index,
    required BuildContext context,
    Function()? click,
    Function(int sender)? onAccept,
  }) {
    BattleBloc battleBloc = context.read<BattleBloc>();
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
                    decoration: typeStatus.boxDecor,
                    height: size,
                    width: size,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: shild > 0 ? AppColor.shildBox : null,
                      child: Image.asset(path),
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
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                color: typeStatus.color,
                child: Text(
                  ships.toString(),
                  style: TextStyle(
                    color: typeStatus.colorText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (index == battleBloc.state.index)
              Container(
                height: size.toDouble() * 0.8,
                width: size.toDouble() * 0.8,
                padding: const EdgeInsets.all(17),
                child: SvgPicture.asset(
                  'assets/svg/cursor.svg',
                  colorFilter: ColorFilter.mode(
                      battleBloc.state.action.colorCrossFire, BlendMode.srcIn),
                ),
              ),
            if (isAttack) IconRotate(size: size - 30),
          ],
        ),
      ),
    );
  }

  @override
  void update() {
    speedBuildShips += speedBuild / 3;
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
Описание: $description. Статус: ${typeStatus.desc}.  
Имеет щит: $shild, кораблей: $ships. 
Максимальное количество кораблей: $maxShips. 
Скорость производства: $speedBuild.   
''', textAlign: TextAlign.center),
    );
  }
}
