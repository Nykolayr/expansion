import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Player {
  final String name;
  final int score;

  Player({required this.name, required this.score});
}

List<Player> yourDataList = [
  Player(name: "прикольный ник", score: 405),
  Player(name: "Гость", score: 1492),
  Player(name: "обычный игрок", score: 510),
  Player(name: "Лучший человек", score: 6201),
  Player(name: "Антон", score: 542)
];

class NameAndScoreWidget extends StatelessWidget {
  final String name;
  final int score;
  final Color colortext;

  const NameAndScoreWidget({
    super.key,
    required this.name,
    required this.score,
    this.colortext = const Color.fromARGB(255, 255, 0, 0),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.h), // Отступ слева
          child: Text(
            name,
            style: TextStyle(
              color: colortext,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10.h), // Отступ слева
          child: Text(
            tr("scorename", args: [score.toString()]),
            style: TextStyle(
              color: colortext,
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
