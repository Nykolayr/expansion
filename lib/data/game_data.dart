import 'package:expansion/Api/api.dart';
import 'package:expansion/domain/models/entities/base.dart';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/base_ships.dart';
import 'package:expansion/domain/models/entities/ships.dart';

/// класс игровых сущностей которые загружаются из апи или ассета
///  List<Planet> - список планет, system - название системы и звезды
class GameData {
  List<EntitesObject> bases = [];
  List<Ship> ships = [];
  int countScene = 0;
  loadMap() async {
    Map<String, dynamic> json = await Api.loadJson(countScene);
    List<Base> planets =
        List<Base>.from(json["neutral"].map((x) => Base.fromJson(x)));
    BaseShip enemyMainShip = BaseShip.fromJson(json["mainShipEnemy"]);
    BaseShip ourMainShip = BaseShip.fromJson(json["mainShipOur"]);
    bases.addAll(planets);
    bases.add(enemyMainShip);
    bases.add(ourMainShip);
  }
}
