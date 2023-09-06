import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/ships.dart';
import 'package:expansion/domain/models/maps/scenes.dart';
import 'package:expansion/domain/models/user/user.dart';
import 'package:expansion/domain/repository/game_repository.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/routers/routers.dart';
import 'package:expansion/ui/battle/widgets/widgets.dart';
import 'package:expansion/ui/maps/bloc/maps_bloc.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surf_logger/surf_logger.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final scenes = List<Scene>.from(Get.find<GameRepository>().scenes.toList());
  UserGame user = Get.find<UserRepository>().user;
  ScrollController controller = ScrollController();
  final current = Get.find<UserRepository>().user.mapClassic - 1;
  late MapsBloc bloc;
  FlyTarget fly = FlyTarget(from: const Point(0, 0), to: const Point(0, 0));
  double top = 70.h;
  @override
  void initState() {
    bloc = context.read<MapsBloc>();
    final scrollTo = ((current - 1) ~/ 5) * 120.h;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (scrollTo > 100.h) controller.jumpTo(scrollTo);
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 15.h),
        color: AppColor.darkBlue,
        height: 160.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
                context.locale != const Locale('ru')
                    ? scenes[current].descriptionRu
                    : scenes[current].descriptionEn,
                style: AppText.baseBody16),
            ButtonLongSimple(
              title: tr('expansion'),
              function: nextMissions,
            ),
          ],
        ),
      ),
      body: BlocConsumer<MapsBloc, MapsState>(
        bloc: bloc,
        listener: (context, state) async {
          if (state.isNext) {
            Future.delayed(const Duration(milliseconds: 500), () async {
              router.go('/battle');
            });
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SizedBox(
                width: deviceSize.width,
                child: Image.asset(
                  'assets/images/fonMap1.png',
                  fit: BoxFit.fill,
                ),
              ),
              appButtonBack(tr('maps')),
              Padding(
                padding: EdgeInsets.only(top: top),
                child: GridView.builder(
                  controller: controller,
                  physics: state.isBegin
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5, mainAxisExtent: 120),
                  itemCount: scenes.length,
                  itemBuilder: (context, index) {
                    final id = scenes[index].id;
                    if (id == current &&
                        state.isBegin &&
                        !state.isNext &&
                        !state.isMove) {
                      final isOddLine = ((current - 1) ~/ 5).isEven;

                      Logger.d(
                          'to ==  $index == $id == ${current - 1} == ${scenes[current - 1].typeScene} } ');
                      fly = isOddLine
                          ? scenes[current - 1].typeScene.flyOdd
                          : scenes[current - 1].typeScene.flyEven;
                      Logger.d(
                          'index from == $isOddLine == ${fly.from} == ${fly.to}  ');
                    }
                    return GestureDetector(
                      onTap: () {
                        if (current != id || !user.isBegin) return;
                        nextMissions();
                      },
                      child: scenes[index].build(
                        index: index,
                        context: context,
                      ),
                    );
                  },
                ),
              ),
              if (state.isShow)
                AnimatedPositioned(
                  top: !state.isMove
                      ? fly.from.y.toDouble()
                      : fly.to.y.toDouble(),
                  left: !state.isMove
                      ? fly.from.x.toDouble()
                      : fly.to.x.toDouble(),
                  duration: const Duration(seconds: 3),
                  child: Transform.rotate(
                    angle: angleToPoint(fly.from, fly.to),
                    child: Container(
                      height: 35.h,
                      width: 35.w,
                      padding: const EdgeInsets.all(2),
                      decoration: TypeStatus.our.boxDecor
                          .copyWith(color: AppColor.green),
                      child: Image.asset(
                        'assets/images/our.png',
                        width: 35.w,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> nextMissions() async {
    if (bloc.state.isBegin) return;
    bloc.add(MapsBeginEvent());
    final scrollTo = ((current - 1) ~/ 5) * 120.h;

    Logger.d(' scrollTo == $scrollTo');
    if (scrollTo > 100.h) controller.jumpTo(scrollTo);
    await Future.delayed(const Duration(milliseconds: 300));
    bloc.add(MapsShowEvent());
    await Future.delayed(const Duration(milliseconds: 100));
    bloc
      ..add(MapsMoveEvent())
      ..add(MapsEndEvent());
  }
}
