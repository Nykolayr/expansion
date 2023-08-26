import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/ships.dart';
import 'package:expansion/domain/models/maps/scenes.dart';
import 'package:expansion/domain/models/user/user.dart';
import 'package:expansion/domain/repository/game_repository.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/routers/routers.dart';
import 'package:expansion/ui/maps/bloc/maps_bloc.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rect_getter/rect_getter.dart';
import '../battle/widgets/widgets.dart';

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
    controller.addListener(() {});
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
        color: AppColor.darkBlue,
        height: 80,
        child: ButtonLongSimple(
          title: tr('expansion'),
          function: () => nextMissions(),
        ),
      ),
      body: BlocConsumer<MapsBloc, MapsState>(
        bloc: bloc,
        listener: (context, state) async {
          if (state.isNext) {
            Future.delayed(const Duration(milliseconds: 500), () async {
              // router.go('/battle');
              router.pop();
            });
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SizedBox(
                height: deviceSize.height,
                child: Image.asset(
                  'assets/images/fonMap1.png',
                  fit: BoxFit.fill,
                ),
              ),
              appButtonBack(tr("maps")),
              Padding(
                padding: EdgeInsets.only(top: top, bottom: 50),
                child: GridView.builder(
                  controller: controller,
                  physics: state.isBegin
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5, // Количество элементов в ряду
                      mainAxisSpacing: 0.0, // Отступы между рядами
                      crossAxisSpacing: 0.0, // Отступы между элементами в ряду
                      mainAxisExtent: 120),
                  itemCount: scenes.length,
                  itemBuilder: (context, index) {
                    var globalKey = RectGetter.createGlobalKey();
                    try {
                      if (index == current &&
                          state.isBegin &&
                          !state.isNext &&
                          !state.isMove) {
                        Future.delayed(const Duration(milliseconds: 100),
                            () async {
                          Rect? rect = RectGetter.getRectFromKey(globalKey);

                          to = Point(
                            rect!.center.dx - 35.w,
                            rect.center.dy +
                                scenes[index].typeScene.padding -
                                35.h,
                          );
                        });
                      }
                      if (index == current - 1 &&
                          state.isBegin &&
                          !state.isNext &&
                          !state.isMove) {
                        Future.delayed(const Duration(milliseconds: 100),
                            () async {
                          Rect? rect = RectGetter.getRectFromKey(globalKey);

                          from = Point(
                            rect!.center.dx + 10.w,
                            rect.center.dy +
                                scenes[index].typeScene.padding -
                                30.h,
                          );
                        });
                      }
                      // ignore: empty_catches
                    } catch (e) {}
                    return RectGetter(
                      key: globalKey,
                      child: GestureDetector(
                          onTap: () {
                            if (current != index || !user.isBegin) return;
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
                  duration: const Duration(seconds: 4),
                  child: Transform.rotate(
                    angle: angleToPoint(from, to),
                    child: Container(
                      height: 35.h,
                      width: 35.w,
                      padding: const EdgeInsets.all(2),
                      decoration: TypeStatus.our.boxDecor
                          .copyWith(color: AppColor.green),
                      child: Image.asset(
                        "assets/images/our.png",
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

  nextMissions() async {
    if (bloc.state.isBegin) return;

    bloc.add(MapsBeginEvent());
    double scrollTo = (current ~/ 5) * 120.h;
    controller.jumpTo(scrollTo);
    await Future.delayed(const Duration(milliseconds: 300));
    bloc.add(MapsShowEvent());
    await Future.delayed(const Duration(milliseconds: 100));
    bloc.add(MapsMoveEvent());
    bloc.add(MapsEndEvent());
  }
}
