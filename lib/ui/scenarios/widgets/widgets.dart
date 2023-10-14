import 'package:expansion/domain/models/entities/types_bases.dart';
import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CellScenarios extends StatefulWidget {
  final int x;
  final int y;
  final List<List<BaseMap?>> mapBattleList;
  final void Function() onPut;
  const CellScenarios(
      {required this.x,
      required this.y,
      required this.mapBattleList,
      required this.onPut,
      super.key});
  @override
  State<CellScenarios> createState() => _CellScenariosState();
}

class _CellScenariosState extends State<CellScenarios> {
  @override
  Widget build(BuildContext context) {
    return DragTarget<BaseMap>(
      builder: (
        context,
        accepted,
        rejected,
      ) {
        return Container(
          width: 65,
          height: 65,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(
            color: AppColor.white,
            width: 1.w,
          )),
          child: Center(
            child: BaseDrag(
              baseMap: widget.mapBattleList[widget.y][widget.x],
            ),
          ),
        );
      },
      onAccept: (sender) {
        final senderMap = BaseMap(
            typeBase: sender.typeBase,
            y: widget.y,
            x: widget.x,
            typeStatus: sender.typeStatus);

        if (sender.x != -1) {
          widget.mapBattleList[sender.y][sender.x] = null;
        }
        widget.mapBattleList[widget.y][widget.x] = senderMap;
        widget.onPut();
      },
    );
  }
}

class BaseDrag extends StatelessWidget {
  final BaseMap? baseMap;
  const BaseDrag({required this.baseMap, super.key});

  @override
  Widget build(BuildContext context) {
    final child = (baseMap == null)
        ? const SizedBox.shrink()
        : Container(
            width: 65,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(right: 7),
            child: Image.asset(baseMap!.typeBase.image),
          );
    return Draggable<BaseMap>(
      data: baseMap,
      feedback: child,
      child: child,
    );
  }
}
