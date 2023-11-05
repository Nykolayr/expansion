import 'package:expansion/domain/models/entities/types_bases.dart';
import 'package:expansion/ui/scenarios/bloc/scenarios_bloc.dart';
import 'package:expansion/ui/scenarios/widgets/widgets.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScenariosPage extends StatefulWidget {
  const ScenariosPage({super.key});

  @override
  State<ScenariosPage> createState() => _ScenariosPageState();
}

class _ScenariosPageState extends State<ScenariosPage> {
  double aspectRatio = deviceSize.width / deviceSize.height;
  bool isOurMain = false;
  bool isEnemyMain = false;
  final List<List<BaseMap?>> mapBattleList =
      List.generate(columnBattle, (i) => List.generate(rowBattle, (j) => null));
  void onPut() {
    isOurMain = mapBattleList.any((row) =>
        row.any((baseMap) => baseMap?.typeBase == TypeBase.ourMainShip));
    isEnemyMain = mapBattleList.any((row) =>
        row.any((baseMap) => baseMap?.typeBase == TypeBase.enemyMainShip));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ScenariosBloc>();
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Image.asset(
              'assets/images/fon2.png',
              fit: BoxFit.fill,
            ),
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: aspectRatio * 2,
              crossAxisCount: rowBattle, // количество столбцов
            ),
            itemCount: rowBattle * columnBattle, // общее количество элементов
            itemBuilder: (context, index) {
              final x = index ~/ columnBattle; // вычислите номер строки
              final y = index % columnBattle; // вычислите номер столбца
              return CellScenarios(
                  x: x, y: y, mapBattleList: mapBattleList, onPut: onPut);
            },
          ),
        ],
      ),
      bottomNavigationBar: DragTarget<BaseMap>(builder: (
        context,
        accepted,
        rejected,
      ) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          height: 120,
          color: AppColor.darkBlue,
          width: deviceSize.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final item in TypeBase.values)
                if (!item.isMainShip ||
                    (!isOurMain && item == TypeBase.ourMainShip) ||
                    (!isEnemyMain && item == TypeBase.enemyMainShip))
                  BaseDrag(
                    baseMap: BaseMap(
                        x: -1, y: -1, typeBase: item, typeStatus: item.status),
                  ),
            ],
          ),
        );
      }, onAccept: (sender) {
        mapBattleList[sender.y][sender.x] = null;
        onPut();
      }),
    );
  }
}
