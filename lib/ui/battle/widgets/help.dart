import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: deviceSize.height,
            child: Image.asset(
              'assets/images/fon1.png',
              fit: BoxFit.fill,
            ),
          ),
          Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  tr("help"),
                  style: AppText.baseText.copyWith(
                    fontSize: 30.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
