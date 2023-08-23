import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/maps/scenes.dart';
import 'package:expansion/domain/repository/game_repository.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../battle/widgets/widgets.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  List<Scene> scenes = [];
  @override
  void initState() {
    scenes = Get.find<GameRepository>().scenes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          for (int index = 0; index < 25; index++)
            scenes[index].build(index: index, context: context),
        ],
      ),
    );
  }
}
