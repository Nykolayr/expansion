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
import 'package:expansion/ui/maps/widgets.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:render_metrics/render_metrics.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final scenes = List<Scene>.from(Get.find<GameRepository>().scenes.toList());
  UserGame user = Get.find<UserRepository>().user;
  ScrollController controller = ScrollController();
  int current = Get.find<UserRepository>().user.mapClassic - 1;
  final renderManager = RenderParametersManager<dynamic>();
  late MapsBloc bloc;
  Point from = const Point(0, 0);
  Point to = const Point(0, 0);
  double top = 70.h;
  @override
  void initState() {
    bloc = context.read<MapsBloc>();
    Future.delayed(const Duration(milliseconds: 100), () async {
      final scrollTo = ((current - 1) ~/ 5 - 2) * 120.h;
      if (scrollTo < controller.offset || scrollTo > 239.h) {
        controller.jumpTo(scrollTo);
      }
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
                    return RenderMetricsObject(
                      id: index,
                      manager: renderManager,
                      child: GestureDetector(
                        onTap: () {
                          if (current != id || !user.isBegin) return;
                          nextMissions();
                        },
                        child: SceneView(index: index, scene: scenes[index]),
                      ),
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
    final scrollTo = ((current - 1) ~/ 5 - 2) * 120.h;

    if (scrollTo > controller.offset) {
      controller.jumpTo(scrollTo);
      await Future.delayed(const Duration(milliseconds: 400));
    }
    final index = scenes.indexWhere((element) => element.id == current - 1);
    final isOddLine = (index ~/ 5).isEven;
    final fly = isOddLine
        ? scenes[index].typeScene.flyOdd
        : scenes[index].typeScene.flyEven;
    await Future.delayed(const Duration(milliseconds: 100));
    final rect = renderManager.getRenderData(index)!.center;
    from = Point(rect.x + fly.begin.dx - 60.w, rect.y + fly.begin.dy - 80.h);
    to = Point(rect.x + fly.end.dx - 60.w, rect.y + fly.end.dy - 80.h);
    await Future.delayed(const Duration(milliseconds: 300));
    bloc.add(MapsShowEvent());
    await Future.delayed(const Duration(milliseconds: 100));
    bloc
      ..add(MapsMoveEvent())
      ..add(MapsEndEvent());
  }
}
