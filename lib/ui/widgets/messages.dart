import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
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
      {this.additional, this.tap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10,
        color: AppColor.darkBlue,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColor.darkYeloow, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        child: Container(
          height: 450,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 25,
          ),
          child: Column(
            children: [
              Text(
                title,
                style: AppText.baseTitle,
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                body,
                style: AppText.baseBody,
              ),
              const SizedBox(
                height: 25,
              ),
              additional ?? const SizedBox.shrink(),
              const SizedBox(
                height: 45,
              ),
              Align(
                alignment: Alignment.center,
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

showPolitic(BuildContext context) {
  String body = '''
${tr('part1')}

${tr('part2')}

${tr('part3')}
 ''';
  final Uri url = Uri.parse(politicUrl);

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
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppText.baseUrl,
      ),
    ),
  );
}

showModal(BuildContext context, Widget widget) {
  showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return widget;
      });
}

showModalBottom(BuildContext context, Widget widget) {
  showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.darkBlue,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 150,
                color: AppColor.darkYeloow,
              ),
              const SizedBox(
                height: 25,
              ),
              widget,
            ],
          ),
        );
      });
}
