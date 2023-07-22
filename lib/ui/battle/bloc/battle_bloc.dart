// ignore_for_file: empty_catches, avoid_print

import 'dart:isolate';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:expansion/data/game_data.dart';
import 'package:expansion/domain/models/enemy_intelect.dart';
import 'package:expansion/domain/models/entities/asteroids.dart';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/domain/models/entities/ships.dart';
import 'package:expansion/game_core/game_loop.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'battle_event.dart';
part 'battle_state.dart';

class BattleBloc extends Bloc<BattleEvent, BattleState> {
  BattleBloc() : super(BattleState.initial()) {
    on<InitEvent>(_onInit);
    on<TicEvent>(_onIic);
    on<PressEvent>(_onPress);
    on<SendEvent>(_onSend);
    on<ArriveShipsEvent>(_onArriveShipsEvent);
    on<WinEvent>(_onWin);
    on<LostEvent>(_onLost);
    on<PauseEvent>(_onPause);
    on<PlayEvent>(_onPlay);
    on<CloseEvent>(_onClose);
    on<ArriveAsteroidEvent>(_onArriveAsteroidEvent);
    on<BattleShipsEvent>(_onBattleShipsEvent);
  }
  GameData gameData = gameRepository.gameData;
  int ticHold = 0;
  bool isSend = false;
  int ticEnemy = 0;
  int ticAsteroid = 0;
  ReceivePort receivePort = ReceivePort();
  _onBattleShipsEvent(BattleShipsEvent event, Emitter<BattleState> emit) async {
    try {
      EntitesObject enemyShip = state.ships
          .firstWhere((element) => element.index == event.enemyIndex);
      EntitesObject ourShip =
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
    } catch (e) {
      print('BattleShipsEvent error == $e');
    }
  }

  _onArriveAsteroidEvent(
      ArriveAsteroidEvent event, Emitter<BattleState> emit) async {
    EntitesObject ast =
        gameData.ships.where((element) => element.index == event.index).first;
    if (event.indexBase != null) {
      BaseObject base = gameData.bases[event.indexBase!];

      if (base.shild > ast.ships) {
        base.shild -= ast.ships;
      } else {
        ast.size -= base.shild;
        base.shild = 0;
        base.ships =
            (base.ships < ast.size.toInt()) ? 0 : base.ships - ast.ships;
      }
    }
    if (event.indexShip != null) {
      EntitesObject ship = gameData.ships
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

  _onArriveShipsEvent(ArriveShipsEvent event, Emitter<BattleState> emit) async {
    try {
      BaseObject toBase = gameData.bases
          .where((element) => element.index == event.toIndex)
          .first;
      Ship ship = gameData.ships.where((element) {
        return element.index == event.index;
      }).first as Ship;

      if (event.indexShip != null) {
        Ship enemyShip = gameData.ships.where((element) {
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
        int shipCount = ship.ships;
        ship.isAttack = true;
        Future.delayed(const Duration(milliseconds: 200), () {
          gameData.ships.removeWhere((element) {
            return element.index == ship.index;
          });
        });
        if (toBase.shild > 0) {
          if (toBase.shild < shipCount) {
            toBase.shild = 0;
            shipCount = shipCount - toBase.shild.toInt();
          } else {
            toBase.shild = toBase.shild - shipCount;
            shipCount = 0;
          }
        }
        if (toBase.ships > shipCount) {
          toBase.ships = toBase.ships - shipCount;
        } else {
          toBase.ships = shipCount - toBase.ships;
          toBase.typeStatus = ship.typeStatus;
          toBase.speedBuild = ship.typeStatus.speedRoket;
          toBase.speedResources = ship.typeStatus.speedResources;
          toBase.resources = 0;
        }
      }
      emit(state.copyWith(
        bases: gameData.bases,
        ships: gameData.ships,
      ));
    } catch (e) {}
  }

  _onSend(SendEvent event, Emitter<BattleState> emit) async {
    if (state.isLost ||
        state.isWin ||
        state.isPause ||
        event.toIndex == event.fromIndex) return;
    int toIndex = event.toIndex;
    int fromIndex = event.fromIndex;
    ActionObject action = ActionObject.attack;
    if (state.bases[toIndex].typeStatus == state.bases[fromIndex].typeStatus) {
      action = ActionObject.support;
    }
    BaseObject toBase = state.bases[toIndex];
    BaseObject fromBase = state.bases[fromIndex];
    Point to = toBase.coordinates;
    Point from = fromBase.coordinates;
    int ships = fromBase.ships;
    BaseObject? betweenBase = getBase(fromBase.coordinates, toBase.coordinates);
    if (betweenBase != null) {
      await betweenBase.showIsNotMove();
      return;
    }
    if (ships > 1) {
      gameData.ships.add(Ship(
        index: Random().nextInt(1000000),
        fromIndex: fromIndex,
        toIndex: toIndex,
        speed: ourSpeed,
        isAttack: false,
        target: PointFly(Point(to.y + toBase.size / 2, to.x + toBase.size / 2)),
        fly: PointFly(
            Point(from.y + fromBase.size / 2, from.x + fromBase.size / 2)),
        ships: ships,
        coordinates: Point(from.y, from.x + fromBase.size / 2),
        typeStatus: fromBase.typeStatus,
        distance: 0,
        distanceCurrent: 0,
        size: 40,
      ));
    }
    fromBase.ships = 0;
    emit(state.copyWith(
      bases: gameData.bases,
      ships: gameData.ships,
      index: -1,
      toIndex: toIndex,
      action: action,
    ));
  }

  _onPress(PressEvent event, Emitter<BattleState> emit) async {
    emit(state.copyWith(index: event.index, action: ActionObject.tap));
  }

  _onInit(InitEvent event, Emitter<BattleState> emit) async {
    await gameData.loadMap();
    for (var item in gameData.bases) {
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

  _onIic(TicEvent event, Emitter<BattleState> emit) async {
    if (state.isLost || state.isWin || state.isPause) return;
    if (ticHold == maxHoldTic) {
      ticHold = 0;
      return;
    }

    if (ticEnemy == maxEnemyTic) {
      setStateEnemy(this);
      ticEnemy = 0;
    }
    if (ticAsteroid == maxAsteroidTic) {
      int index = Random().nextInt(1000000);

      gameData.ships.add(Asteroid.fromRandom(index));
      emit(state.copyWith(
        ships: gameData.ships,
      ));
      ticAsteroid = 0;
    }
    ticAsteroid++;
    ticHold++;
    ticEnemy++;
    for (var item in gameData.bases) {
      item.update();
    }
    for (var item in gameData.ships) {
      item.update();
    }
    emit(state.copyWith(bases: gameData.bases, ships: gameData.ships));
  }

  _onLost(LostEvent event, Emitter<BattleState> emit) async =>
      emit(state.copyWith(isLost: true));

  _onWin(WinEvent event, Emitter<BattleState> emit) async =>
      emit(state.copyWith(isWin: true));

  _onPause(PauseEvent event, Emitter<BattleState> emit) async =>
      emit(state.copyWith(isPause: true));

  _onPlay(PlayEvent event, Emitter<BattleState> emit) async =>
      emit(state.copyWith(isPause: false));

  _onClose(CloseEvent event, Emitter<BattleState> emit) async =>
      receivePort.close();
}

enum ActionObject {
  tap,
  attack,
  support,
  no;

  Color get colorCrossFire {
    switch (this) {
      case ActionObject.no:
        return Colors.transparent;
      case ActionObject.tap:
        return AppColor.darkYeloow;
      case ActionObject.attack:
        return AppColor.red;
      case ActionObject.support:
        return AppColor.darkGreen;
    }
  }
}

/// проверяет есть ли база на пути между базой с point1 и базой point2
/// возращает базу которая на пути, если нет, то возращает null
BaseObject? getBase(Point point1, Point point2) {
  double shipSize = 30;
  GameData gameData = gameRepository.gameData;
  List<BaseObject> bases = gameData.bases;
  bases = bases
      .where((element) =>
          element.coordinates != point1 && element.coordinates != point2)
      .toList();
  // Расстояние между точками point1 и point2
  double distance =
      sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2));

  // Направление движения корабля
  double directionX = (point2.x - point1.x) / distance;
  double directionY = (point2.y - point1.y) / distance;

  double x = point1.x.toDouble();
  double y = point1.y.toDouble();

  // Имитируем движение корабля с заданным шагом
  double stepSize = 0.1; // Задаем размер шага
  double traveledDistance = 0;

  while (traveledDistance < distance) {
    // Перемещаем корабль на шаг в направлении к point2
    x += directionX * stepSize;
    y += directionY * stepSize;

    // Проверяем, пересекается ли корабль с каким-либо объектом Base
    for (BaseObject base in bases) {
      double centersDistance =
          sqrt(pow(base.coordinates.x - x, 2) + pow(base.coordinates.y - y, 2));
      double totalRadius = base.size / 2 + shipSize / 2;

      if (centersDistance <= totalRadius) {
        return base; // Корабль задел базу
      }
    }

    traveledDistance += stepSize; // Увеличиваем пройденное расстояние
  }

  return null; // Корабль успешно достиг точки point2 без пересечений с Base
}

double distance(Point p1, Point p2) {
  num dx = p2.x - p1.x;
  num dy = p2.y - p1.y;
  return sqrt(dx * dx + dy * dy);
}

/// вспомогательрный объект имитирующий корабль
class MoveObj {
  Point coordinates;
  final double size;

  MoveObj(this.coordinates, this.size);
}
