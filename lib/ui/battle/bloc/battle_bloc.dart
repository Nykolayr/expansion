// ignore_for_file: empty_catches, avoid_print

import 'dart:isolate';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:expansion/domain/models/enemy_intelect.dart';
import 'package:expansion/domain/models/entities/asteroids.dart';
import 'package:expansion/domain/models/entities/base.dart';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/ships.dart';
import 'package:expansion/domain/repository/game_repository.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/game_core/game_loop.dart';
import 'package:expansion/game_core/min_time.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:surf_logger/surf_logger.dart';
part 'battle_event.dart';
part 'battle_state.dart';

class BattleBloc extends Bloc<BattleEvent, BattleState> {
  BattleBloc() : super(BattleState.initial()) {
    on<InitEvent>(_onInit);
    on<TicEvent>(_onIic);
    on<SendEvent>(_onSend);
    on<ArriveShipsEvent>(_onArriveShipsEvent);
    on<WinEvent>(_onWin);
    on<LostEvent>(_onLost);
    on<PauseEvent>(_onPause);
    on<PlayEvent>(_onPlay);
    on<CloseEvent>(_onClose);
    on<AddScore>(_onAddScore);
    on<ArriveAsteroidEvent>(_onArriveAsteroidEvent);
    on<BattleShipsEvent>(_onBattleShipsEvent);
    on<EndBeginEvent>(_onEndBeginEvent);
  }
  GameRepository gameData = Get.find<GameRepository>();
  int ticHold = 0;
  bool isSend = false;
  int ticEnemy = 0;
  int ticAsteroid = 0;
  int ticTime = 0;
  late Base mainBase;
  ReceivePort receivePort = ReceivePort();
  Future<void> _onBattleShipsEvent(
      BattleShipsEvent event, Emitter<BattleState> emit) async {
    try {
      final enemyShip = state.ships
          .firstWhere((element) => element.index == event.enemyIndex);
      final ourShip =
          state.ships.firstWhere((element) => element.index == event.indexShip);
      if (enemyShip.ships > ourShip.ships) {
        enemyShip.ships -= ourShip.ships;
        (enemyShip as Ship).isAttack = false;
        gameData.ships.removeWhere((element) {
          return element.index == ourShip.index;
        });
      } else {
        ourShip.ships -= enemyShip.ships;
        (ourShip as Ship).isAttack = false;
        gameData.ships.removeWhere((element) {
          return element.index == enemyShip.index;
        });
      }
      emit(state.copyWith(
        bases: gameData.bases,
        ships: gameData.ships,
      ));
    } on Exception catch (e) {
      Logger.e('BattleShipsEvent error == ', e);
    }
  }

  Future<void> _onArriveAsteroidEvent(
      ArriveAsteroidEvent event, Emitter<BattleState> emit) async {
    final ast =
        gameData.ships.where((element) => element.index == event.index).first;
    if (event.indexBase != null) {
      final base = gameData.bases[event.indexBase!];

      if (base.shild > ast.ships) {
        base.shild -= ast.ships;
      } else {
        ast.size -= base.shild;
        base
          ..shild = 0
          ..ships =
              (base.ships < ast.size.toInt()) ? 0 : base.ships - ast.ships;
      }
    }
    if (event.indexShip != null) {
      final ship = gameData.ships
          .where((element) => element.index == event.indexShip)
          .first;
      if (ship.ships < ast.ships) {
        gameData.ships.removeWhere((element) {
          return element.index == event.indexShip;
        });
      } else {
        ship.ships -= ast.ships;
      }
    }
    gameData.ships.removeWhere((element) {
      return element.index == event.index;
    });
    emit(state.copyWith(
      bases: gameData.bases,
      ships: gameData.ships,
    ));
  }

  Future<void> _onArriveShipsEvent(
      ArriveShipsEvent event, Emitter<BattleState> emit) async {
    try {
      final toBase = gameData.bases
          .where((element) => element.index == event.toIndex)
          .first;
      final ship = gameData.ships.where((element) {
        return element.index == event.index;
      }).first as Ship;

      if (event.indexShip != null) {
        final enemyShip = gameData.ships.where((element) {
          return element.index == event.index;
        }).first as Ship;
        Future.delayed(const Duration(milliseconds: 200), () {
          if (enemyShip.ships == ship.ships) {
            gameData.ships.removeWhere((element) {
              return element.index == ship.index;
            });
            gameData.ships.removeWhere((element) {
              return element.index == enemyShip.index;
            });
          }
          if (enemyShip.ships > ship.ships) {
            gameData.ships.removeWhere((element) {
              return element.index == ship.index;
            });
          } else {
            gameData.ships.removeWhere((element) {
              return element.index == enemyShip.index;
            });
          }
        });
        return;
      }
      if (toBase.typeStatus == ship.typeStatus) {
        toBase.ships += ship.ships;
        gameData.ships.removeWhere((element) {
          return element.index == ship.index;
        });
      } else {
        final shild = toBase.shild * toBase.typeStatus.shieldDurability;
        var shipCount = (ship.ships * ship.typeStatus.shipDurability).round();
        final shipBase =
            (toBase.ships * toBase.typeStatus.shipDurability).round();
        ship.isAttack = true;
        Future.delayed(const Duration(milliseconds: 200), () {
          gameData.ships.removeWhere((element) {
            return element.index == ship.index;
          });
        });
        if (shild > 0) {
          if (shild < shipCount) {
            toBase.shild = 0;
            shipCount =
                ((shipCount - shild.round()) / ship.typeStatus.shipDurability)
                    .round();
          } else {
            toBase.shild = shild - shipCount;
            shipCount = 0;
          }
        }
        if (shipBase > shipCount) {
          toBase.ships =
              ((toBase.ships - shipCount) / toBase.typeStatus.shipDurability)
                  .round();
        } else {
          toBase
            ..ships = shipCount - toBase.ships
            ..typeStatus = ship.typeStatus
            ..speedBuild = ship.typeStatus.speedBuildShip
            ..speedResources = ship.typeStatus.speedResources
            ..resources = 0;
        }
      }
      emit(state.copyWith(
        bases: gameData.bases,
        ships: gameData.ships,
      ));
    } on Exception catch (e) {
      Logger.e('_onArriveShipsEvent error == ', e);
    }
  }

  Future<void> _onSend(SendEvent event, Emitter<BattleState> emit) async {
    if (state.isLost ||
        state.isWin ||
        state.isPause ||
        event.toIndex == event.fromIndex) return;
    final toIndex = event.toIndex;
    final fromIndex = event.fromIndex;
    final toBase = gameData.bases[toIndex];
    final fromBase = gameData.bases[fromIndex];
    final to = toBase.coordinates;
    final from = fromBase.coordinates;
    final betweenBase = getBase(fromBase.coordinates, toBase.coordinates);
    if (betweenBase != null) {
      await betweenBase.showIsNotMove();
      return;
    }
    if (fromBase.ships > 1) {
      gameData.ships.add(Ship(
        index: Random().nextInt(1000000),
        fromIndex: fromIndex,
        toIndex: toIndex,
        isAttack: false,
        target: PointFly(Point(to.y + toBase.size / 2, to.x + toBase.size / 2)),
        fly: PointFly(
            Point(from.y + fromBase.size / 2, from.x + fromBase.size / 2)),
        ships: fromBase.ships,
        coordinates: Point(from.y, from.x + fromBase.size / 2),
        typeStatus: fromBase.typeStatus,
        distance: 0,
        distanceCurrent: 0,
        size: shipSize,
      ));
      fromBase.ships = 0;
    }
    emit(state.copyWith(
      bases: gameData.bases,
      ships: gameData.ships,
    ));
  }

  Future<void> _onInit(InitEvent event, Emitter<BattleState> emit) async {
    await gameData.loadMap();
    for (final item in gameData.bases) {
      if (item.typeStatus == TypeStatus.our) mainBase = item;
      item.update();
    }

    emit(state.copyWith(
      bases: gameData.bases,
      ships: gameData.ships,
    ));

    await Isolate.spawn(mainLoop, receivePort.sendPort);

    receivePort.listen((message) {
      add(TicEvent());
    });
  }

  Future<void> _onIic(TicEvent event, Emitter<BattleState> emit) async {
    if (state.isLost || state.isWin || state.isPause) return;
    checkWinLose();
    if (ticHold == maxHoldTic) {
      ticHold = 0;
      return;
    }

    if (ticEnemy ==
        (Get.find<UserRepository>().game.level.ticEnemy *
            (Get.find<UserRepository>().upEnemy.tic().toInt() - 1))) {
      await setStateEnemy(this);
      ticEnemy = 0;
      // add(WinEvent());
    }
    if (ticAsteroid == maxAsteroidTic) {
      final index = Random().nextInt(1000000);

      gameData.ships.add(Asteroid.fromRandom(index));
      emit(state.copyWith(
        ships: gameData.ships,
      ));
      ticAsteroid = 0;
    }
    ticAsteroid++;
    ticHold++;
    ticEnemy++;
    ticTime++;
    for (final item in gameData.bases) {
      item.update();
    }
    for (final item in gameData.ships) {
      item.update();
    }
    emit(state.copyWith(bases: gameData.bases, ships: gameData.ships));
  }

  Future<void> _onLost(LostEvent event, Emitter<BattleState> emit) async =>
      emit(state.copyWith(isWin: true, isPause: true));

  Future<void> _onEndBeginEvent(
      EndBeginEvent event, Emitter<BattleState> emit) async {
    emit(state.copyWith(isBegin: false));
    add(PlayEvent());
  }

  Future<void> _onWin(WinEvent event, Emitter<BattleState> emit) async =>
      emit(state.copyWith(
          isWin: true,
          isPause: true,
          score: calculateScore(mainBase, ticTime)));

  Future<void> _onPause(PauseEvent event, Emitter<BattleState> emit) async =>
      emit(state.copyWith(isPause: true));

  Future<void> _onPlay(PlayEvent event, Emitter<BattleState> emit) async =>
      emit(state.copyWith(isPause: false));

  Future<void> _onClose(CloseEvent event, Emitter<BattleState> emit) async =>
      receivePort.close();
  Future<void> _onAddScore(AddScore event, Emitter<BattleState> emit) async =>
      Get.find<UserRepository>()
          .setScoreClassic(calculateScore(mainBase, ticTime));
  void checkWinLose() {
    var basesEnemy = 0;
    var basesOur = 0;
    for (final base in gameData.bases) {
      switch (base.typeStatus) {
        case TypeStatus.enemy:
          basesEnemy++;
        case TypeStatus.our:
          basesOur++;
        case TypeStatus.neutral:
        case TypeStatus.asteroid:
      }
    }
    if (basesOur == 0) add(LostEvent());
    if (basesEnemy == 0) {
      add(WinEvent());
    }
  }
}

/// проверяет есть ли база на пути между базой с point1 и базой point2
/// возращает базу которая на пути, если нет, то возращает null
Base? getBase(Point point1, Point point2) {
  final gameData = Get.find<GameRepository>();
  var bases = gameData.bases;
  bases = bases
      .where((element) =>
          element.coordinates != point1 && element.coordinates != point2)
      .toList();
  // Расстояние между точками point1 и point2
  final distance =
      sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2));

  // Направление движения корабля
  final directionX = (point2.x - point1.x) / distance;
  final directionY = (point2.y - point1.y) / distance;

  var x = point1.x.toDouble();
  var y = point1.y.toDouble();

  // Имитируем движение корабля с заданным шагом
  const stepSize = 0.1; // Задаем размер шага
  var traveledDistance = 0.0;
  while (traveledDistance < distance) {
    // Перемещаем корабль на шаг в направлении к point2
    x += directionX * stepSize;
    y += directionY * stepSize;
    // Проверяем, пересекается ли корабль с каким-либо объектом Base
    for (final base in bases) {
      final centersDistance =
          sqrt(pow(base.coordinates.x - x, 2) + pow(base.coordinates.y - y, 2));
      final totalRadius = base.size / 2 + shipSize / 2;

      if (centersDistance <= totalRadius) {
        return base; // Корабль задел базу
      }
    }

    traveledDistance += stepSize; // Увеличиваем пройденное расстояние
  }

  return null; // Корабль успешно достиг точки point2 без пересечений с Base
}

double distance(Point p1, Point p2) {
  final dx = p2.x - p1.x;
  final dy = p2.y - p1.y;
  return sqrt(dx * dx + dy * dy);
}

/// вспомогательрный объект имитирующий корабль
class MoveObj {
  Point coordinates;
  final double size;

  MoveObj(this.coordinates, this.size);
}
