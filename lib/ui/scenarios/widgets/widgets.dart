import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/types_bases.dart';
import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:popup_menu/popup_menu.dart';

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
  late PopupMenu menu;
  GlobalKey btnKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  void onClickMenu(MenuItemProvider item) {
    widget.mapBattleList[widget.y][widget.x]!.typeStatus =
        TypeStatus.values.byName(item.menuTitle);
    widget.onPut();
  }

  void onDismiss() {}

  @override
  Widget build(BuildContext context) {
    return DragTarget<BaseMap>(
      builder: (
        context,
        accepted,
        rejected,
      ) {
        return GestureDetector(
          onLongPress: () {
            if (widget.mapBattleList[widget.y][widget.x] != null &&
                !widget
                    .mapBattleList[widget.y][widget.x]!.typeBase.isMainShip) {
              popupMenu();
            }
          },
          child: Container(
            key: btnKey,
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

  void popupMenu() {
    PopupMenu(
      config: const MenuConfig(
        backgroundColor: AppColor.darkBlue,
        lineColor: AppColor.red,
      ),
      context: context,
      items: [
        for (int i = 0; i < TypeStatus.values.length - 1; i++)
          MenuItem(
            title: TypeStatus.values[i].name,
          )
      ],
      onClickMenu: onClickMenu,
      onDismiss: onDismiss,
    ).show(widgetKey: btnKey);
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
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.only(right: 7),
            decoration: baseMap!.typeStatus.boxDecor,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: baseMap!.typeBase.colorShild,
              child: Image.asset(baseMap!.typeBase.image),
            ),
          );
    return Draggable<BaseMap>(
      data: baseMap,
      feedback: child,
      child: child,
    );
  }
}
