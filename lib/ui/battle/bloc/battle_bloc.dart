import 'dart:isolate';

import 'package:equatable/equatable.dart';
import 'package:expansion/data/game_data.dart';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
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
  }
  GameData gameData = gameRepository.gameData;
  int ticHold = 0;
  bool isSend = false;

  _onSend(SendEvent event, Emitter<BattleState> emit) async {
    int toIndex = event.index;
    ActionObject action = ActionObject.attack;
    if (state.toIndex == event.index) {
      toIndex = -1;
    }
    if (state.objects[toIndex].typeStatus == TypeStatus.our) {
      action = ActionObject.support;
    }
    emit(state.copyWith(
      index: toIndex,
      action: action,
    ));
  }

  _onPress(PressEvent event, Emitter<BattleState> emit) async {
    int index = event.index;
    if (state.index == event.index) {
      index = -1;
    }
    emit(state.copyWith(index: index, action: ActionObject.tap));
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

    ticHold++;
    for (var item in gameData.objects) {
      item.update();
    }
    emit(state.copyWith(objects: gameData.objects));
  }
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
