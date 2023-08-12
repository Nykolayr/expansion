import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/user/user.dart';
import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<User> yourDataList = [
  const User(name: "прикольный ник", score: 405, id: 2),
  const User(name: "Гость", score: 1492, id: 4),
  const User(name: "обычный игрок", score: 510, id: 5),
  const User(name: "Лучший человек", score: 6201, id: 6),
  const User(name: "Антон", score: 542, id: 8),
  const User(name: "прикольный ник", score: 405, id: 2),
  const User(name: "Гость", score: 1492, id: 4),
  const User(name: "обычный игрок", score: 510, id: 5),
  const User(name: "Лучший человек", score: 6201, id: 6),
  const User(name: "Антон", score: 542, id: 8),
  const User(name: "прикольный ник", score: 405, id: 2),
  const User(name: "Гость", score: 1492, id: 4),
  const User(name: "обычный игрок", score: 510, id: 5),
  const User(name: "Лучший человек", score: 6201, id: 6),
  const User(name: "Антон", score: 542, id: 8),
  const User(name: "прикольный ник", score: 405, id: 2),
  const User(name: "Гость", score: 1492, id: 4),
  const User(name: "обычный игрок", score: 510, id: 5),
  const User(name: "Лучший человек", score: 6201, id: 6),
  const User(name: "Антон", score: 542, id: 8),
  const User(name: "обычный игрок", score: 510, id: 5),
  const User(name: "Лучший человек", score: 6201, id: 6),
  const User(name: "Антон", score: 542, id: 8),
  const User(name: "прикольный ник", score: 405, id: 2),
  const User(name: "Гость", score: 1492, id: 4),
  const User(name: "прикольный ник", score: 405, id: 2),
  const User(name: "Гость", score: 1492, id: 4),
  const User(name: "обычный игрок", score: 510, id: 5),
  const User(name: "Лучший человек", score: 6201, id: 6),
  const User(name: "Антон", score: 542, id: 8),
  const User(name: "прикольный ник", score: 405, id: 2),
  const User(name: "Гость", score: 1492, id: 4),
  const User(name: "обычный игрок", score: 510, id: 5),
  const User(name: "Лучший человек", score: 6201, id: 6),
  const User(name: "Антон", score: 542, id: 8),
  const User(name: "обычный игрок", score: 510, id: 5),
  const User(name: "Лучший человек", score: 6201, id: 6),
  const User(name: "Антон", score: 542, id: 8),
  const User(name: "прикольный ник", score: 405, id: 2),
  const User(name: "Гость", score: 1492, id: 4),
  const User(name: "обычный игрок", score: 510, id: 5),
  const User(name: "Лучший человек", score: 6201, id: 6),
  const User(name: "Антон", score: 542, id: 8),
  const User(name: "прикольный ник", score: 405, id: 2),
  const User(name: "Гость", score: 1492, id: 4),
  const User(name: "обычный игрок", score: 510, id: 5),
  const User(name: "Лучший человек", score: 6201, id: 6),
  const User(name: "Антон", score: 542, id: 8),
];

class NameAndScoreWidget extends StatelessWidget {
  final User user;
  final int id;
  final int index;

  const NameAndScoreWidget({
    super.key,
    required this.user,
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
            '$index. ${user.name}',
            style: TextStyle(
              color: user.id == id ? AppColor.red : AppColor.darkYeloow,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10.h), // Отступ слева
          child: Text(
            tr("scorename", args: [user.score.toString()]),
            style: TextStyle(
              color: user.id == id ? AppColor.red : AppColor.darkYeloow,
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
