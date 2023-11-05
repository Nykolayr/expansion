import 'package:expansion/data/base_data.dart';
import 'package:expansion/domain/models/maps/scenes.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:surf_logger/surf_logger.dart';

/// репозитарий для управления игровыми сценами и картами для битвы

class MapsRepository extends GetxController {
  List<Scene> scenes = [];

  MapsRepository._privateConstructor();
  static final MapsRepository _instance = MapsRepository._privateConstructor();

  factory MapsRepository() {
    return _instance;
  }

  Future<void> init() async {
    Logger.d('begin');
    // scenes = await BaseData().loadScenesBase();
    // scenes = await BaseData().loadScenesJson2();
    await BaseData().loadAllUsers();
    return;
  }
}
