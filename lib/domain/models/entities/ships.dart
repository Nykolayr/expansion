import 'package:expansion/domain/models/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Ship extends EntitesObject {
  int speed = 1;
  Size target;
  Ship({
    required this.speed,
    required this.target,
    required super.ships,
    required super.coordinates,
    required super.typeStatus,
  });

  @override
  void update() {}

  @override
  Widget build(
      {required int index,
      required BuildContext context,
      Function()? click,
      Function(int sender)? onAccept}) {}
}
