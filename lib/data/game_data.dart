import 'package:expansion/Api/api.dart';
import 'package:expansion/domain/models/entities/base.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/domain/models/entities/ships.dart';

/// класс игровых сущностей которые загружаются из апи или ассета
///  List<Planet> - список планет, system - название системы и звезды
class GameData {
  List<EntityObject> objects = [];
  int countScene = 0;
  loadMap() async {
    Map<String, dynamic> json = await Api.loadJson(countScene);
    List<Base> planets =
        List<Base>.from(json["neutral"].map((x) => Base.fromJson(x)));
    Ship enemyMainShip = Ship.fromJson(json["mainShipEnemy"]);
    Ship ourMainShip = Ship.fromJson(json["mainShipOur"]);
    objects.addAll(planets);
    objects.add(enemyMainShip);
    objects.add(ourMainShip);
  }
}
