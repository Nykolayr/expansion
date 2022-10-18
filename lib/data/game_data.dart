import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/Api/api.dart';
import 'package:expansion/domain/models/entities/planet.dart';

/// класс игровых сущностей которые загружаются из апи или ассета
///  List<Planet> - список планет, system - название системы и звезды
class GameData {
  late List<Planet> planets;
  late System system;
  int countScene = 0;
  loadMap() async {
    Map<String, dynamic> json = await Api.loadJson(countScene);
    system = System.fromJson(json["system"]);
    planets = List<Planet>.from(json["planets"].map((x) => Planet.fromJson(x)));
    print('===== ${planets.length} == ${planets.first.toJson()}');
    print('=====  ${system.toJson()}');
  }
}

/// класс звездной системы, имя, имя звезды и размер звезды
class System {
  String name;
  String starName;
  double size;
  System({required this.name, required this.starName, required this.size});
  factory System.fromJson(Map<String, dynamic> json) => System(
      name: tr(json["name"]),
      starName: tr(json["starName"]),
      size: json["size"]);
  Map<String, dynamic> toJson() => {
        "name": name,
        "starName": starName,
        "size": size,
      };
}
