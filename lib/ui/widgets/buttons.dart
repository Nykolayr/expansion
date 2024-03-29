import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/upgrade.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/routers/routers.dart';
import 'package:expansion/ui/battle/widgets/modal.dart';
import 'package:expansion/ui/widgets/messages.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;
import 'package:get/get.dart';

class ButtonSide extends StatelessWidget {
  final Direct direct;
  final String? title;
  final Function()? function;
  const ButtonSide(this.direct, {this.function, this.title, super.key});

  @override
  Widget build(BuildContext context) {
    final widht = deviceSize.width / 3;
    final height = widht / 3.h;
    final text = title ?? direct.title;
    final fun = function ??
        () async {
          if (Direct.rightBottom == direct &&
              Get.find<UserRepository>().user.isBegin) {
            if (Get.find<UserRepository>().user.mapClassic == 1) {
              router.go('/new_game');
            } else {
              router.go('/maps');
            }

            return;
          }
          if (Direct.leftBottom == direct) {
            final result = await showModalBottom(
                context, YesNoModal(context, tr('attempt_new_game')));
            if (result != null && result) {
              if (context.mounted) {
                Get.find<UserRepository>().upEnemy = AllUpgrade.initialEnemy();
                Get.find<UserRepository>().upOur = AllUpgrade.initialOur();
                Get.find<UserRepository>().user = Get.find<UserRepository>()
                    .user
                    .copyWith(isBegin: true, scoreClassic: 0, mapClassic: 1);
                await Get.find<UserRepository>().saveUser();
                router.go(direct.router);
              }
              return;
            }
          }
          router.go(direct.router);
        };
    return GestureDetector(
      onTap: fun,
      child: SizedBox(
        width: widht.w,
        height: height.h,
        child: Center(
          child: Stack(
            children: [
              Align(
                child: SvgPicture.asset(
                  direct.puthIn,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                width: widht,
                height: height,
                padding: EdgeInsets.only(
                  left: direct.paddingText.w,
                  right: direct.isLeft ? 8.w : 0.w,
                ),
                child: Align(
                  child: Text(
                    text,
                    style: AppText.baseText.copyWith(
                      fontSize: 15.sp,
                      color: direct.colorText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonLongSimple extends StatelessWidget {
  final String title;
  final Function() function;
  final String? photo;
  const ButtonLongSimple(
      {required this.function, required this.title, this.photo, super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        alignment: Alignment.center,
        width: deviceSize.width - 60.w,
        height: 45.h,
        margin: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        decoration: const BoxDecoration(
            image:
                DecorationImage(image: svg.Svg('assets/svg/bottom_long.svg'))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (photo != null)
              Row(
                children: [
                  if (photo!.contains('svg'))
                    SvgPicture.asset(
                      photo!,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                          AppColor.darkYeloow, BlendMode.srcIn),
                    )
                  else
                    Image.asset(photo!, height: 15),
                  SizedBox(width: 10.w),
                ],
              ),
            Text(
              title,
              style: AppText.baseText.copyWith(
                fontSize: 16.sp,
                color: AppColor.darkYeloow,
              ),
            ),
            if (photo != null) SizedBox(width: 20.w),
          ],
        ),
      ),
    );
  }
}

class ButtonLong extends StatelessWidget {
  final String title;
  final Function() function;
  final bool isWidth;
  final String? photo;
  const ButtonLong(
      {required this.function,
      required this.title,
      this.isWidth = false,
      this.photo,
      super.key});

  @override
  Widget build(BuildContext context) {
    var widht = deviceSize.width - 90.w;
    if (isWidth) {
      widht = widht + 60.w;
    }
    return GestureDetector(
      onTap: function,
      child: SizedBox(
        width: widht,
        child: Center(
          child: Stack(
            children: [
              Align(
                child: SvgPicture.asset(
                  'assets/svg/bottom_long.svg',
                  width: widht,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                width: widht,
                padding: EdgeInsets.only(
                  top: isWidth ? 0 : 10.h,
                  right: isWidth ? 0 : 8.w,
                ),
                child: Align(
                  child: Text(
                    title,
                    style: AppText.baseText.copyWith(
                      fontSize: isWidth ? 20.sp : 16.sp,
                      color: AppColor.darkYeloow,
                    ),
                  ),
                ),
              ),
              if (photo != null)
                Container(
                    padding: EdgeInsets.only(
                        top: 11
                            .h), // Можете настроить нужные вам значения padding
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor:
                            0.15, // Можете настроить нужные вам значения widthFactor для ограничения ширины изображения
                        child: photo!.contains('svg')
                            ? SvgPicture.asset(photo!, height: 15)
                            : Image.asset(photo!, height: 15),
                      ),
                    ))
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

enum Direct {
  leftTop,
  leftBottom,
  meddleTop,
  meddleBottom,
  titl,
  rightTop,
  rightBottom,
}

extension DirectExtention on Direct {
  Color get colorText {
    switch (this) {
      case Direct.leftBottom:
      case Direct.rightBottom:
      case Direct.meddleTop:
        return AppColor.black;
      default:
        return AppColor.darkYeloow;
    }
  }

  String get puthIn {
    switch (this) {
      case Direct.leftBottom:
        return 'assets/svg/bottom_in.svg';
      case Direct.rightBottom:
        return 'assets/svg/bottom_right_in.svg';
      case Direct.leftTop:
        return 'assets/svg/top_in.svg';
      case Direct.rightTop:
        return 'assets/svg/top_right_in.svg';
      case Direct.meddleBottom:
        return 'assets/svg/bottom_middle_in.svg';
      case Direct.titl:
        return 'assets/svg/bottom_middle_in.svg';
      case Direct.meddleTop:
        return 'assets/svg/top_middle_in.svg';
      default:
        return '';
    }
  }

  double get paddingText {
    switch (this) {
      case Direct.leftBottom:
      case Direct.leftTop:
        return 2;
      case Direct.rightTop:
      case Direct.rightBottom:
        return 4;
      default:
        return 0;
    }
  }

  bool get isLeft {
    switch (this) {
      case Direct.leftBottom:
      case Direct.leftTop:
        return true;
      default:
        return false;
    }
  }

  String get router {
    switch (this) {
      case Direct.leftBottom:
        return '/new_game';
      case Direct.rightBottom:
        return (Get.find<UserRepository>().user.mapClassic > 1 &&
                Get.find<UserRepository>().user.isBegin)
            ? '/maps'
            : '/battle';
      case Direct.leftTop:
        return '/profile';
      case Direct.rightTop:
        return '/progress';
      case Direct.meddleBottom:
        return '/update';
      case Direct.meddleTop:
        return '/settings';
      default:
        return '/settings';
    }
  }

  String get title {
    switch (this) {
      case Direct.leftBottom:
        return tr('new_game');
      case Direct.rightBottom:
        return tr('сontinue');
      case Direct.leftTop:
        return tr('profile');
      case Direct.rightTop:
        return tr('progress');
      case Direct.meddleBottom:
        return tr('upgrades');
      case Direct.meddleTop:
        return tr('settings');
      default:
        return '';
    }
  }
}
