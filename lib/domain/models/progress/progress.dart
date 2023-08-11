import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Player {
  final String name;
  final int score;
  final int id;

  Player({required this.name, required this.score, required this.id});
}

List<Player> yourDataList = [
  Player(name: "прикольный ник", score: 405, id: 2),
  Player(name: "Гость", score: 1492, id: 4),
  Player(name: "обычный игрок", score: 510, id: 5),
  Player(name: "Лучший человек", score: 6201, id: 6),
  Player(name: "Антон", score: 542, id: 8),
  Player(name: "прикольный ник", score: 405, id: 2),
  Player(name: "Гость", score: 1492, id: 4),
  Player(name: "обычный игрок", score: 510, id: 5),
  Player(name: "Лучший человек", score: 6201, id: 6),
  Player(name: "Антон", score: 542, id: 8),
  Player(name: "прикольный ник", score: 405, id: 2),
  Player(name: "Гость", score: 1492, id: 4),
  Player(name: "обычный игрок", score: 510, id: 5),
  Player(name: "Лучший человек", score: 6201, id: 6),
  Player(name: "Антон", score: 542, id: 8),
  Player(name: "прикольный ник", score: 405, id: 2),
  Player(name: "Гость", score: 1492, id: 4),
  Player(name: "обычный игрок", score: 510, id: 5),
  Player(name: "Лучший человек", score: 6201, id: 6),
  Player(name: "Антон", score: 542, id: 8),
];

class NameAndScoreWidget extends StatelessWidget {
  final Player player;
  final int id;
  final int index;

  const NameAndScoreWidget({
    super.key,
    required this.player,
    required this.id,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.h), // Отступ слева
          child: Text(
            '$index. ${player.name}',
            style: TextStyle(
              color: player.id == id ? AppColor.red : AppColor.darkYeloow,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10.h), // Отступ слева
          child: Text(
            tr("scorename", args: [player.score.toString()]),
            style: TextStyle(
              color: player.id == id ? AppColor.red : AppColor.darkYeloow,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
