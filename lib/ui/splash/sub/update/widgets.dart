import 'package:expansion/domain/models/upgrade.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/ui/battle/widgets/widgets.dart';
import 'package:expansion/ui/splash/sub/update/bloc/update_bloc.dart';
import 'package:expansion/ui/widgets/widgets.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

/// функция вывода строки для улучшения
Widget upgradeAdding(Upgrade upgrade, BuildContext context) {
  int maxLevel = Get.find<UserRepository>().upOur.maxLevel + 1;
  double size =
      ((deviceSize.width - 40 - maxLevel * 10) / (maxLevel + 1)).r - 1;
  TypeUp type = upgrade.type;
  Widget getUpLevel(int k, int index) {
    return Opacity(
      opacity: k > index ? 0.2 : 1,
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(right: 10),
        color: AppColor.darkYeloow,
        height: size - 10,
        width: size,
        child: SvgPicture.asset(
          type.image,
          colorFilter:
              const ColorFilter.mode(AppColor.darkBlue, BlendMode.srcIn),
        ),
      ),
    );
  }

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleButton(
                  iconPath: 'assets/svg/help.svg',
                  click: () {
                    SnackBarHelper.showUpgradeSnackBar(
                        context, upgrade.type.textHelp);
                  },
                  style: CircleButtonStyle.small,
                ),
                SizedBox(width: 15.w),
                Text(type.text, style: AppText.baseBodyBoldYellow),
              ],
            ),
            Row(
              children: [
                SvgPicture.asset(
                  type.image,
                  width: 15,
                  colorFilter: const ColorFilter.mode(
                      AppColor.darkYeloow, BlendMode.srcIn),
                ),
                SizedBox(width: 5.w),
                Text('+${upgrade.percenstValue}%',
                    style: AppText.baseBodyBoldYellow),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int k = 0; k < maxLevel; k++) getUpLevel(k, upgrade.level),
              GestureDetector(
                onTap: () {
                  if (!Get.find<UserRepository>().upOur.isUpgrade(upgrade)) {
                    return;
                  }
                  context.read<UpdateBloc>().add(ChangeUdrade(upgrade.type));
                },
                child: Opacity(
                  opacity: Get.find<UserRepository>().upOur.isUpgrade(upgrade)
                      ? 1
                      : 0.3,
                  child: SvgPicture.asset(
                    'assets/svg/buttonUp.svg',
                    width: size,
                    // height: size - 10,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
