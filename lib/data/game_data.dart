import 'package:expansion/Api/api.dart';
import 'package:expansion/domain/models/entities/neutral.dart';

/// класс игровых сущностей которые загружаются из апи или ассета
///  List<Planet> - список планет, system - название системы и звезды
class GameData {
  late List<NeutralBase> planets;

  int countScene = 0;
  loadMap() async {
    Map<String, dynamic> json = await Api.loadJson(countScene);
    planets = List<NeutralBase>.from(
        json["neutral"].map((x) => NeutralBase.fromJson(x)));
  }
}
