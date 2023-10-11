import 'package:expansion/domain/models/entities/asteroids.dart';
import 'package:expansion/domain/models/entities/base.dart';
import 'package:expansion/domain/models/entities/base_ships.dart';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/ships.dart';
import 'package:expansion/domain/repository/game_repository.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/ui/widgets/animations_sprites.dart';
import 'package:expansion/ui/widgets/widgets.dart';
import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

/// вид корабля, верстка
class ShipView extends StatelessWidget {
  final Ship ship;
  const ShipView({required this.ship, super.key});

  @override
  Widget build(BuildContext context) {
    if (ship.coordinates == ship.target.coordinates && !ship.isAttack) {
      context
          .read<BattleBloc>()
          .add(ArriveShipsEvent(ship.index, ship.toIndex, ship.indexShip));
    }
    if (ship.isAttack && !ship.isSend && ship.indexShip != null) {
      ship.isSend = true;
      context
          .read<BattleBloc>()
          .add(BattleShipsEvent(ship.indexShip!, ship.index));
    }
    return Positioned(
      top: ship.coordinates.x - ship.size / 2,
      left: ship.coordinates.y - ship.size / 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (ship.isAttack)
            IconRotate(size: ship.size)
          else
            Transform.rotate(
              angle: ship.angle,
              child: Container(
                height: ship.size,
                width: ship.size,
                padding: const EdgeInsets.all(4),
                decoration: ship.typeStatus.boxDecor,
                child: SvgPicture.asset(
                  ship.typeStatus.shipImage,
                  colorFilter:
                      ColorFilter.mode(ship.typeStatus.color, BlendMode.srcIn),
                  width: 40.w,
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                color: ship.typeStatus.color,
              ),
              child: Text(
                ship.ships.toString(),
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// вид корабля матки, верстка
class BaseShipView extends StatelessWidget {
  final int index;
  final BaseShip baseShip;
  final Function(int index)? onAccept;

  const BaseShipView(
      {required this.index, required this.baseShip, this.onAccept, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: baseShip.coordinates.y.toDouble(),
      left: baseShip.coordinates.x.toDouble(),
      child: GestureDetector(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Draggable<int>(
              data: index,
              feedback: SizedBox(
                width: baseShip.size,
                height: baseShip.size,
              ),
              child: DragTarget<int>(
                builder: (
                  context,
                  accepted,
                  rejected,
                ) {
                  return Container(
                    padding: const EdgeInsets.all(2),
                    decoration: baseShip.typeStatus.boxDecor,
                    height: baseShip.size,
                    width: baseShip.size,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: baseShip.shild > 0 ? AppColor.shildBox : null,
                      child: Image.asset(baseShip.path),
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
              child: getInfo(baseShip),
            ),
            if (baseShip.isNotMove)
              Positioned(
                child: SvgPicture.asset(
                  'assets/svg/cursor.svg',
                  width: baseShip.size * 0.6,
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

/// вид базы, верстка
class BaseView extends StatelessWidget {
  final int index;
  final Base base;
  final Function(int index)? onAccept;

  const BaseView(
      {required this.index, required this.base, this.onAccept, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: base.coordinates.y.toDouble(),
      left: base.coordinates.x.toDouble(),
      child: Draggable<int>(
        data: index,
        feedback: SizedBox(
          width: base.size,
          height: base.size,
        ),
        child: DragTarget<int>(
          builder: (
            context,
            accepted,
            rejected,
          ) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  height: base.sizeBase.add.size,
                  width: base.sizeBase.add.size,
                  decoration: base.typeStatus.boxDecor,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: base.shild > 0 ? AppColor.shildBox : null,
                    child: Image.asset(base.sizeBase.add.pictire),
                  ),
                ),
                getInfo(base),
                if (base.isNotMove)
                  Positioned(
                    child: SvgPicture.asset(
                      'assets/svg/cursor.svg',
                      width: base.size * 0.6,
                      colorFilter:
                          const ColorFilter.mode(AppColor.red, BlendMode.srcIn),
                    ),
                  ),
              ],
            );
          },
          onAccept: (sender) {
            if (Get.find<GameRepository>().bases[sender].typeStatus ==
                TypeStatus.our) onAccept!(sender);
          },
        ),
      ),
    );
  }
}

/// вид астероида, верстка
class AsteroidView extends StatelessWidget {
  final Asteroid asteroid;

  const AsteroidView({required this.asteroid, super.key});

  @override
  Widget build(BuildContext context) {
    if (asteroid.coordinates == asteroid.target.coordinates &&
        !asteroid.isAttack) {
      context.read<BattleBloc>().add(ArriveAsteroidEvent(
          asteroid.index, asteroid.indexBase, asteroid.indexShip));
    }
    if (asteroid.isAttack && !asteroid.isSend) {
      asteroid.isSend = true;
      Future.delayed(const Duration(seconds: 1), () {
        context.read<BattleBloc>().add(ArriveAsteroidEvent(
            asteroid.index, asteroid.indexBase, asteroid.indexShip));
      });
    }
    final animation = ImageAnimation(
      animationsGame: AnimationsGame.explosion,
      numberOfImages: 9,
      duration: 200,
      size: asteroid.size,
    );

    return Positioned(
      top: asteroid.coordinates.x - asteroid.size / 2,
      left: asteroid.coordinates.y - asteroid.size / 2,
      child: asteroid.isAttack
          ? animation
          : Image.asset(
              asteroid.imagePath,
              width: asteroid.size,
            ),
    );
  }
}
