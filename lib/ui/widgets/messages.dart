import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

/// Простой показ сообщения c title, body, необязательным
///  дополнительным виджетом additional
/// и необязательной функцией tap
class SimpleMessage extends StatelessWidget {
  final String title;
  final String body;
  final Widget? additional;
  final Function()? tap;
  const SimpleMessage(this.title, this.body,
      {this.additional, this.tap, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10,
        color: AppColor.darkBlue,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColor.darkYeloow, width: 2.w),
          borderRadius: BorderRadius.circular(10).r,
        ),
        margin: EdgeInsets.symmetric(vertical: 25.h, horizontal: 15),
        child: Container(
          height: 450.h,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 25,
          ),
          child: Column(
            children: [
              Text(
                title,
                style: AppText.baseTitle18,
              ),
              SizedBox(
                height: 25.h,
              ),
              Text(
                body,
                style: AppText.baseBody16,
              ),
              SizedBox(
                height: 25.h,
              ),
              additional ?? const SizedBox.shrink(),
              SizedBox(
                height: 45.h,
              ),
              Align(
                child: ButtonSide(
                  Direct.meddleTop,
                  function: () => Navigator.pop(context),
                  title: tr('good'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

dynamic showPolitic(BuildContext context) {
  final body = '''
${tr('part1')}

${tr('part2')}

${tr('part3')}
 ''';
  final url = Uri.parse(Values.politicUrl);

  return showModal(
      context,
      SimpleMessage(
        tr('what_data'),
        body,
        additional: urlText(tr('if_use'), url),
      ));
}

Widget urlText(String text, Uri url) {
  return GestureDetector(
    onTap: () => launchUrl(url),
    child: Container(
      width: double.infinity.w,
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppText.baseUrl16,
      ),
    ),
  );
}

void showModal(BuildContext context, Widget widget) {
  showDialog<void>(
      context: context,
      builder: (context) {
        return widget;
      });
}

Future<bool?> showModalBottom(BuildContext context, Widget widget) {
  return showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.darkBlue,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5.h,
                width: 150.w,
                color: AppColor.darkYeloow,
              ),
              SizedBox(
                height: 25.h,
              ),
              widget,
            ],
          ),
        );
      });
}
