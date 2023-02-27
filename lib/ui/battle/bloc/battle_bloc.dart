import 'dart:isolate';

import 'package:equatable/equatable.dart';
import 'package:expansion/data/game_data.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/game_core/game_loop.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'battle_event.dart';
part 'battle_state.dart';

class BattleBloc extends Bloc<BattleEvent, BattleState> {
  BattleBloc() : super(Battleinit()) {
    on<InitEvent>(_onInit);
    on<TicEvent>(_onIic);
    on<PressEvent>(_onPress);
    on<SendEvent>(_onSend);
  }
  GameData gameData = gameRepository.gameData;
  int selectObject = -1;
  int ticHold = 0;
  bool isSend = false;

  _onSend(SendEvent event, Emitter<BattleState> emit) async {
    emit(Battleinit());
    if (selectObject != event.index) {
      selectObject = event.index;
    }

    emit(BattleChange.copyWith(gameData.objects, selectObject));
  }

  _onPress(PressEvent event, Emitter<BattleState> emit) async {
    emit(Battleinit());
    if (selectObject == event.index) {
      selectObject = -1;
    } else {
      selectObject = event.index;
    }
    emit(BattleChange.copyWith(gameData.objects, selectObject));
  }

  _onInit(InitEvent event, Emitter<BattleState> emit) async {
    await gameData.loadMap();
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(mainLoop, receivePort.sendPort);
    receivePort.listen((message) {
      add(TicEvent());
    });
  }

  _onIic(TicEvent event, Emitter<BattleState> emit) async {
    if (ticHold == maxHoldTic) {
      ticHold = 0;
      return;
    }
    emit(Battleinit());
    ticHold++;
    for (var item in gameData.objects) {
      item.update();
    }
    emit(BattleChange.copyWith(gameData.objects, selectObject));
  }
}

enum ActionObject { tap, attack, support, no }

extension Actionextension on ActionObject {
  Color get colorCrossFire {
    switch (this) {
      case ActionObject.no:
        return AppColor.darkYeloow;
      case ActionObject.tap:
        return AppColor.darkYeloow;
      case ActionObject.attack:
        return AppColor.red;
      case ActionObject.support:
        return AppColor.darkGreen;
    }
  }
}
