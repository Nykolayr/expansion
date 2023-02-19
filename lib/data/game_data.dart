import 'package:expansion/Api/api.dart';
import 'package:expansion/domain/models/entities/base.dart';

/// класс игровых сущностей которые загружаются из апи или ассета
///  List<Planet> - список планет, system - название системы и звезды
class GameData {
  late List<Base> planets;

  int countScene = 0;
  loadMap() async {
    Map<String, dynamic> json = await Api.loadJson(countScene);
    planets = List<Base>.from(json["neutral"].map((x) => Base.fromJson(x)));
  }
}
