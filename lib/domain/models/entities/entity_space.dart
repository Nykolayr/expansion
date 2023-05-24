import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:flutter/material.dart';

/// Абстрактный класс объект база(наша, враг и нейтралы),  есть 4 фактора
/// speedBuild скорость изготовление кораблей - повышается постройкой
/// shild  защита - повышается постройкой
/// maxShips предел кораблей - повышается постройкой
/// resources ресурс - абстрактный, прибавляется каждую секунду,
/// прибавка зависит speedResources - повышается постройкой
/// имеет начальные координаты coordinates  x, y
/// typeObject - изначальный тип объекта,   наш, врага, нейтральная
///   inicialShips  - начальное значение кораблей на объекте
/// typeStatus - статус объекта, захвачен нами, врагами, или нейтральный
/// size - размер объекта

abstract class BaseObject extends EntitesObject {
  int index;
  String description; // описание базы
  double shild; // щит базы max до 100
  int maxShips; // максимальное количество кораблей для постройки
  double speedBuild;
  double speedResources;
  double resources;
  ActionObject actionObject;
  bool isAttack; // находится ли база под атакой

  BaseObject(
      {required super.coordinates,
      required super.typeStatus,
      required super.size,
      required super.ships,
      required this.description,
      required this.shild,
      required this.maxShips,
      required this.speedBuild,
      required this.speedResources,
      required this.resources,
      required this.actionObject,
      required this.isAttack,
      required this.index});
  Widget getText();
}
