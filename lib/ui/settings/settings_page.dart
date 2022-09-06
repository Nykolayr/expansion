// ignore_for_file: library_private_types_in_public_api

import 'package:expansion/ui/settings/bloc/settings_bloc.dart';
import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<SettingsBloc>();
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(60.0),
      //   child: AppBarWithIcon(
      //     title: tr('settings'),
      //     isBack: true,
      //   ),
      // ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) async {},
          builder: (context, state) {
            return Stack(
              children: [
                Container(
                  color: AppColor.darkYeloow,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15,
                  ),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [],
                  ),
                ),
                // Center(
                //   child: state.isLoading
                //       ? const CircularProgressIndicator()
                //       : const SizedBox.shrink(),
                // ),
              ],
            );
          }),
    );
  }
}
