import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/entities/base.dart';
import 'package:expansion/ui/battle/widgets/widgets.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

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
          appButtonBack(tr("help")),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 70.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25.h),
                  Text(
                    tr('help_win'),
                    style: AppText.baseText.copyWith(fontSize: 15.sp),
                  ),
                  SizedBox(height: 25.h),
                  lineHelp(SizeBase.base.add.pictire,
                      SizeBase.midleBase.add.pictire, tr('help_base')),
                  SizedBox(height: 25.h),
                  lineHelp('assets/images/enemy.png', 'assets/images/our.png',
                      tr('help_main_base')),
                  SizedBox(height: 25.h),
                  lineHelp('assets/svg/data_help.svg', '', tr('help_data'),
                      size: 80),
                  SizedBox(height: 25.h),
                  lineHelp('assets/images/asteroids/ast1.png',
                      'assets/images/asteroids/ast5.png', tr('help_asteroid'),
                      size: 30),
                  SizedBox(height: 25.h),
                  DropCapText(
                    tr('help_attack'),
                    style: AppText.baseText.copyWith(fontSize: 15.sp),
                    dropCapPadding: EdgeInsets.only(right: 10.w, bottom: 2.h),
                    dropCap: DropCap(
                        width: 120.w,
                        height: 120,
                        child: Image.asset('assets/images/help_attack.png')),
                  ),
                  SizedBox(height: 25.h),
                  DropCapText(
                    tr('help_up'),
                    style: AppText.baseText.copyWith(fontSize: 15.sp),
                    dropCapPadding: EdgeInsets.only(right: 10.w, bottom: 2.h),
                    dropCap: DropCap(
                        width: 80.w,
                        height: 80.h,
                        child: Image.asset('assets/images/help_up.png')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget lineHelp(String path, String path2, String text, {double size = 40}) {
  return Row(
    children: [
      Column(
        children: [
          getImageHelp(path, size),
          if (path2.isNotEmpty) SizedBox(height: 10.h),
          if (path2.isNotEmpty) getImageHelp(path2, size),
        ],
      ),
      SizedBox(width: 10.w),
      Expanded(
        child: Text(
          text,
          style: AppText.baseText.copyWith(fontSize: 15.sp),
        ),
      ),
    ],
  );
}

Widget getImageHelp(String path, double size) {
  if (path.contains('.svg')) {
    return SvgPicture.asset(path,
        semanticsLabel: 'My SVG Picture', width: size.w);
  } else {
    return Image.asset(path, height: size.h);
  }
}
