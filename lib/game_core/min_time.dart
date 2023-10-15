import 'package:expansion/domain/models/entities/base.dart';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/repository/game_repository.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/utils/value.dart';
import 'package:get/get.dart';

/// Высчитывает очки за захват всех баз противника
/// в зависимости от быстроты захвата
/// base - наша начальная база, time - сколько тиков вышло у игрока
int calculateScore(Base base, int time) {
  var maxTime = 0;
  final speedShips = TypeStatus.our.shipSpeed * speedShipsMult;
  final speedBuildShips = TypeStatus.our.speedBuildShip * (15 / delSpeedBuild);
  final bases = Get.find<GameRepository>().bases
    ..removeWhere((element) => element.index == base.index);
  sortDist(bases, base);
  var previousBase = base;
  for (var k = 0; k < bases.length; k++) {
    maxTime +=
        (distance(previousBase.coordinates, bases[k].coordinates) / speedShips +
                bases[k].maxShips / (speedBuildShips * (k + 1)))
            .round();
    previousBase = bases[k];
  }
  final score = (scoreMultiplier - 100) * (1 + (maxTime / time));
  return score.toInt();
}

void sortDist(List<Base> bases, Base base) {
  bases.sort((base1, base2) {
    final dist1 = distance(base.coordinates, base1.coordinates);
    final dist2 = distance(base.coordinates, base2.coordinates);
    return dist1.compareTo(dist2);
  });
}
