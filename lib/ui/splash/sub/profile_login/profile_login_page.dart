// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/ui/battle/widgets/widgets.dart';
import 'package:expansion/ui/splash/sub/profile_login/bloc/profile_login_bloc.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileLoginPage extends StatelessWidget {
  const ProfileLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<ProfileLoginBloc>();
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Image.asset(
              'assets/images/fon1.png',
              fit: BoxFit.fill,
            ),
          ),
          appButtonBack(tr('profilelogin')),
          BlocBuilder<ProfileLoginBloc, ProfileLoginState>(
              builder: (context, state) {
            return Container(
              width: deviceSize.width,
              padding: const EdgeInsets.symmetric(
                vertical: 75,
                horizontal: 45,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  TextField(
                      style: const TextStyle(fontSize: 22, color: Colors.white),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: tr('username'),
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(80, 255, 255, 255)),
                          fillColor: const Color.fromARGB(26, 255, 255, 255),
                          filled: true)),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextField(
                      style: const TextStyle(fontSize: 22, color: Colors.white),
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: tr('password'),
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(80, 255, 255, 255)),
                          fillColor: const Color.fromARGB(26, 255, 255, 255),
                          filled: true)),
                  SizedBox(
                    height: 30.h,
                  ),
                  ButtonLong(
                      title: tr('login'),
                      // ignore: avoid_print
                      function: () => print('Вход в аккаунт какое то')),
                  SizedBox(
                    height: 15.h,
                  ),
                  ButtonLong(
                      title: tr('register'),
                      function: () => Navigator.pop(context)),
                  //router.go('/profile/profile_login/register')
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
