import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../battle/widgets/widgets.dart';

class MapsPage extends StatelessWidget {
  const MapsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: deviceSize.height,
            child: Image.asset(
              'assets/images/fonMap1.png',
              fit: BoxFit.fill,
            ),
          ),
          appButtonBack(tr("maps")),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 70.h),
            child: const Column(
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
