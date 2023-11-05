import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/user/user.dart';
import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<UserGame> yourDataList = [
  UserGame(name: 'прикольный ник', scoreClassic: 405, id: 2),
  UserGame(name: 'обычный игрок', scoreClassic: 405, id: 5),
  UserGame(name: 'Лучший человек', scoreClassic: 405, id: 6),
  UserGame(name: 'Антон', scoreClassic: 405, id: 12),
  UserGame(name: 'Nen', scoreClassic: 405, id: 11),
  UserGame(name: 'treplo', scoreClassic: 405, id: 15),
  UserGame(name: 'Star', scoreClassic: 405, id: 18),
  UserGame(name: 'mer', scoreClassic: 405, id: 111),
  UserGame(name: 'grunt', scoreClassic: 405, id: 222),
  UserGame(name: 'letro', scoreClassic: 405, id: 333),
  UserGame(name: 'stuppid', scoreClassic: 405, id: 4444),
  UserGame(name: 'seven', scoreClassic: 405, id: 5555),
  UserGame(name: 'truestep', scoreClassic: 405, id: 888),
  UserGame(name: 'Cool', scoreClassic: 405, id: 99),
];

class NameAndScoreWidget extends StatelessWidget {
  final UserGame user;
  final int id;
  final int index;

  const NameAndScoreWidget({
    required this.user,
    required this.id,
    required this.index,
    super.key,
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
              color: user.id == int.parse(id.toString())
                  ? AppColor.red
                  : AppColor.darkYeloow,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10.h), // Отступ слева
          child: Text(
            tr('scorename', args: [user.scoreClassic.toString()]),
            style: TextStyle(
              color: user.id == int.parse(id.toString())
                  ? AppColor.red
                  : AppColor.darkYeloow,
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
