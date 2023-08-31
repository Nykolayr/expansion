import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/user/user.dart';
import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<UserGame> yourDataList = [
  const UserGame(name: 'прикольный ник', score: 405, id: '2'),
  const UserGame(name: 'обычный игрок', score: 405, id: '5'),
  const UserGame(name: 'Лучший человек', score: 405, id: '6'),
  const UserGame(name: 'Антон', score: 405, id: '12'),
  const UserGame(name: 'Nen', score: 405, id: '11'),
  const UserGame(name: 'treplo', score: 405, id: '15'),
  const UserGame(name: 'Star', score: 405, id: '18'),
  const UserGame(name: 'mer', score: 405, id: '111'),
  const UserGame(name: 'grunt', score: 405, id: '222'),
  const UserGame(name: 'letro', score: 405, id: '333'),
  const UserGame(name: 'stuppid', score: 405, id: '4444'),
  const UserGame(name: 'seven', score: 405, id: '5555'),
  const UserGame(name: 'truestep', score: 405, id: '888'),
  const UserGame(name: 'Cool', score: 405, id: '99'),
];

class NameAndScoreWidget extends StatelessWidget {
  final UserGame user;
  final String id;
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
            tr('scorename', args: [user.score.toString()]),
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
