import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/utils/value.dart';

/// Высчитывает очки за захват всех баз противника
/// в зависимости от быстроты захвата
/// base - наша начальная база, time - сколько тиков вышло у игрока
int calculateScore(BaseObject base, int time) {
  int maxTime = 0;
  double speedShips = TypeStatus.our.shipSpeed * speedShipsMult;
  double speedBuildShips = TypeStatus.our.speedBuildShip * (15 / delSpeedBuild);
  List<BaseObject> bases = gameRepository.gameData.bases;
  bases.removeWhere((element) => element.index == base.index);
  sortDist(bases, base);
  BaseObject previousBase = base;
  for (int k = 0; k < bases.length; k++) {
    maxTime +=
        (distance(previousBase.coordinates, bases[k].coordinates) / speedShips +
                bases[k].maxShips / (speedBuildShips * (k + 1)))
            .round();
    previousBase = bases[k];
  }
  double score = (scoreMultiplier - 100) * (1 + (maxTime / time));
  return score.toInt();
}

void sortDist(List<BaseObject> bases, BaseObject base) {
  bases.sort((base1, base2) {
    double dist1 = distance(base.coordinates, base1.coordinates);
    double dist2 = distance(base.coordinates, base2.coordinates);
    return dist1.compareTo(dist2);
  });
}
