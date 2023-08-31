import 'dart:math';

import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/domain/repository/game_repository.dart';
import 'package:expansion/ui/widgets/widgets.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BaseShip extends BaseObject {
  String path;
  BaseShip({
    required super.coordinates,
    required super.maxShips,
    required super.shild,
    required super.ships,
    required super.speedBuild,
    required super.speedResources,
    required super.resources,
    required super.typeStatus,
    required super.size,
    required this.path,
    required super.index,
  });
  factory BaseShip.fromJson(Map<String, dynamic> json) {
    final typeStatus = TypeStatus.values
        .firstWhere((e) => e.toString() == 'TypeStatus.${json["typeStatus"]}');

    final x = (json['coordinates'] as Map<String, dynamic>)['x'] as int;
    final y = (json['coordinates'] as Map<String, dynamic>)['y'] as int;
    final size = json['size'] as int;
    final pozY =
        (y == 1) ? (80 - size / 2) : (deviceSize.height - 80 - size / 2);
    return BaseShip(
      coordinates: Point((stepX * x - size / 2).w, pozY.h),
      shild: json['shild'] as double,
      ships: typeStatus.beginShips,
      speedBuild: typeStatus.speedBuildShip,
      speedResources: typeStatus.speedResources,
      resources: 0,
      maxShips: json['maxShips'] as int,
      typeStatus: typeStatus,
      size: size.toDouble(),
      path: json['path'] as String,
      index: 0,
    );
  }
  Map<String, dynamic> toJson() => {
        'coordinates': coordinates,
        'maxShips': maxShips,
        'shild': shild,
        'ships': ships,
        'speedBuild': speedBuild,
        'speedResources': speedResources,
        'size': size,
        'resources': resources,
        'typeStatus': typeStatus,
        'path': path,
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
                  context,
                  accepted,
                  rejected,
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
                onAccept: (sender) {
                  if (Get.find<GameRepository>().bases[sender].typeStatus ==
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
