import 'dart:math';

import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/ui/widgets/widgets.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BaseShip extends BaseObject {
  String path;
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
    required super.actionObject,
    required super.index,
  });
  factory BaseShip.fromJson(Map<String, dynamic> json) {
    TypeStatus typeStatus = TypeStatus.values
        .firstWhere((e) => e.toString() == 'TypeStatus.${json["typeStatus"]}');

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
      speedBuild: typeStatus.speedRoket,
      speedResources: typeStatus.speedResources,
      resources: 0.0,
      maxShips: json['maxShips'],
      typeStatus: typeStatus,
      size: size.toDouble(),
      path: json['path'],
      actionObject: ActionObject.no,
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
        "size": size,
        "resources": resources,
        "typeStatus": typeStatus,
        "path": path,
      };

  @override
  Widget build({
    required int index,
    required BuildContext context,
    Function(int sender)? onAccept,
  }) {
    return Positioned(
      top: coordinates.y.toDouble(),
      left: coordinates.x.toDouble(),
      child: GestureDetector(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Draggable<int>(
              data: index,
              feedback: SizedBox(
                width: size,
                height: size,
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
              child: getInfo(this),
            ),
            if (isNotMove)
              Positioned(
                child: SvgPicture.asset(
                  'assets/svg/cursor.svg',
                  width: size * 0.6,
                  colorFilter:
                      const ColorFilter.mode(AppColor.red, BlendMode.srcIn),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
