import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/ui/battle/widgets/widgets.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sbp/models/c2bmembers_model.dart';
import 'package:surf_logger/surf_logger.dart';
import 'package:url_launcher/url_launcher.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  String url = 'https://qr.nspk.ru/AS10003P3RH0LJ2A9ROO038L6NT5RU1M';

  int id = 0;
  List<C2bmemberModel> informations = [];

  @override
  void initState() {
    url = 'https://www.sberbank.com/sms/pbpn?requisiteNumber=79526818276';
    // url = 'https://qr.nspk.ru';
    id = Get.find<UserRepository>().user.id;
    getInstalledBanks();
    super.initState();
  }

  Future<void> getInstalledBanks() async {
    // try {
    //   informations.addAll(await Sbp.getInstalledBanks(
    //       C2bmembersModel.fromJson(c2bmembersData)));
    // } on Exception catch (e) {
    //   throw Exception(e);
    // }
    setState(() {});
  }

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
          appButtonBack(tr('help_games')),
          Container(
            width: deviceSize.width,
            padding: const EdgeInsets.symmetric(
              vertical: 75,
              horizontal: 45,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Text(tr('text_donat'), style: AppText.baseTitle18),
                SizedBox(
                  height: 30.h,
                ),
                Text(tr('sub_donat', args: [id.toString()]),
                    style: AppText.baseTitle18.copyWith(color: AppColor.white)),
                SizedBox(
                  height: 30.h,
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: id.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: AppColor.darkBlue,
                      duration: const Duration(seconds: 5),
                      content: Text(
                        tr('text_id'),
                        textAlign: TextAlign.center,
                        style: AppText.baseBody16,
                      ),
                    ));
                  },
                  child: Row(
                    children: [
                      Text(tr('copy_id'), style: AppText.baseTitle18),
                      const SizedBox(width: 30),
                      SvgPicture.asset(
                        'assets/svg/icon_copy.svg',
                        colorFilter: const ColorFilter.mode(
                            AppColor.darkYeloow, BlendMode.srcIn),
                        width: 30,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                ButtonLong(
                    title: tr('button_donat'),
                    function: () async {
                      if (!await launchUrl(
                        Uri.parse(
                          url,
                        ),
                        mode: LaunchMode.externalApplication,
                      )) {
                        Logger.d('Could not launch $url');
                        throw Exception('Could not launch $url');
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SbpHeaderModalSheet extends StatelessWidget {
  const SbpHeaderModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          height: 5,
          width: 50,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: Colors.grey),
        ),
        SizedBox(height: 20.h),
        SvgPicture.asset(
          'assets/svg/sbp.svg',
          width: 120.w,
        ),
        SizedBox(height: 20.h),
        Text(
          'Выберите банк для оплаты по СБП',
          style: AppText.baseText,
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}




// class SbpModalBottomSheetEmptyListBankWidget extends StatelessWidget {
//   const SbpModalBottomSheetEmptyListBankWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const SbpHeaderModalSheet(),
//         Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Container(
//               height: 80,
//               decoration: const BoxDecoration(
//                 color: Colors.grey,
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(10),
//                 ),
//               ),
//               child: const Center(
//                 child: Text('У вас нет банков для оплаты по СБП'),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 50),
//       ],
//     );
//   }
// }

/// Модальное окно с банками
// class SbpModalBottomSheetWidget extends StatelessWidget {
//   final List<C2bmemberModel> informations;
//   final String url;

//   const SbpModalBottomSheetWidget(this.informations, this.url, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     /// если есть информация о банках, то отображаем их
//     if (informations.isNotEmpty) {
//       return Column(
//         children: [
//           const SbpHeaderModalSheet(),
//           Expanded(
//             child: ListView.separated(
//               itemCount: informations.length,
//               itemBuilder: (ctx, index) {
//                 final information = informations[index];
//                 return Container(
//                   alignment: Alignment.center,
//                   margin: EdgeInsets.symmetric(horizontal: 50.w),
//                   height: 40.h,
//                   decoration: const BoxDecoration(
//                     color: AppColor.darkYeloow,
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(20),
//                     ),
//                   ),
//                   child: GestureDetector(
//                     onTap: () => openBank(url, information),
//                     child: Text(
//                       information.bankName,
//                       style: AppText.baseBody16.copyWith(color: AppColor.black),
//                     ),
//                   ),
//                 );
//               },
//               separatorBuilder: (context, index) => const SizedBox(height: 25),
//             ),
//           ),
//         ],
//       );
//     } else {
//       return const SbpModalBottomSheetEmptyListBankWidget();
//     }
//   }

//   /// передается scheme
//   FutureOr<void> openBank(String url, C2bmemberModel c2bmemberModel) async =>
//       await Sbp.openBank(url, c2bmemberModel);
// }
