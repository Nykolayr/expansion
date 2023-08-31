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
import 'package:rect_getter/rect_getter.dart';
import 'package:surf_logger/surf_logger.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  List<Scene> scenes = Get.find<GameRepository>().scenes;
  UserGame user = Get.find<UserRepository>().user;
  ScrollController controller = ScrollController();
  int current = Get.find<UserRepository>().user.mapClassic - 1;
  late MapsBloc bloc;
  Point from = const Point(0, 0);
  Point to = const Point(0, 0);
  double top = 70.h;
  @override
  void initState() {
    bloc = context.read<MapsBloc>();
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
                      crossAxisCount: 5, // Количество элементов в ряду
                      mainAxisExtent: 120),
                  itemCount: scenes.length,
                  itemBuilder: (context, index) {
                    final globalKey = RectGetter.createGlobalKey();
                    final id = scenes[index].id;
                    try {
                      if (id == current &&
                          state.isBegin &&
                          !state.isNext &&
                          !state.isMove) {
                        Future.delayed(const Duration(milliseconds: 100),
                            () async {
                          final rect = RectGetter.getRectFromKey(globalKey);
                          final dx = (scenes[id].typeScene == TypeScene.fifth ||
                                  scenes[id].typeScene == TypeScene.first)
                              ? 20.w
                              : 35.w;
                          to = Point(
                            rect!.center.dx - dx,
                            rect.center.dy +
                                scenes[id].typeScene.padding -
                                35.h,
                          );
                        });
                      }
                      if (id == current - 1 &&
                          state.isBegin &&
                          !state.isNext &&
                          !state.isMove) {
                        Future.delayed(const Duration(milliseconds: 100),
                            () async {
                          final rect = RectGetter.getRectFromKey(globalKey);
                          final dx = (scenes[id].typeScene == TypeScene.fifth ||
                                  scenes[id].typeScene == TypeScene.first)
                              ? -20.w
                              : 10.w;
                          from = Point(
                            rect!.center.dx + dx,
                            rect.center.dy +
                                scenes[id].typeScene.padding -
                                30.h,
                          );
                        });
                      }
                    } on Exception catch (e) {
                      Logger.e('RectGetter error == ', e);
                    }
                    return RectGetter(
                      key: globalKey,
                      child: GestureDetector(
                          onTap: () {
                            if (current != id || !user.isBegin) return;
                            nextMissions();
                          },
                          child: scenes[index].build(
                            index: index,
                            context: context,
                          )),
                    );
                  },
                ),
              ),
              if (state.isShow)
                AnimatedPositioned(
                  top: !state.isMove ? from.y.toDouble() : to.y.toDouble(),
                  left: !state.isMove ? from.x.toDouble() : to.x.toDouble(),
                  duration: const Duration(seconds: 3),
                  child: Transform.rotate(
                    angle: angleToPoint(from, to),
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
    final scrollTo = (current ~/ 5 - 1) * 120.h;
    controller.jumpTo(scrollTo);
    await Future.delayed(const Duration(milliseconds: 300));
    bloc.add(MapsShowEvent());
    await Future.delayed(const Duration(milliseconds: 100));
    bloc
      ..add(MapsMoveEvent())
      ..add(MapsEndEvent());
  }
}
