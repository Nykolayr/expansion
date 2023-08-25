import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/maps/scenes.dart';
import 'package:expansion/domain/repository/game_repository.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../battle/widgets/widgets.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  List<Scene> scenes = Get.find<GameRepository>().scenes;
  ScrollController controller = ScrollController();
  int current = Get.find<UserRepository>().user.mapClassic - 1;
  @override
  void initState() {
    controller.addListener(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: AppColor.darkBlue,
        height: 80,
        child: ButtonLongSimple(
          title: tr('exit_profile'),
          function: () async {},
        ),
      ),
      body: Stack(
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
            padding: EdgeInsets.only(top: 70.h, bottom: 50),
            child: GridView.builder(
              controller: controller,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // Количество элементов в ряду
                  mainAxisSpacing: 0.0, // Отступы между рядами
                  crossAxisSpacing: 0.0, // Отступы между элементами в ряду
                  mainAxisExtent: 120),
              itemCount: scenes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {},
                    child: scenes[index].build(
                      index: index,
                      context: context,
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
