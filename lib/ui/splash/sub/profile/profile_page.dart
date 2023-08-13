// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/routers/routers.dart';
import 'package:expansion/ui/battle/widgets/modal.dart';
import 'package:expansion/ui/battle/widgets/widgets.dart';
import 'package:expansion/ui/splash/sub/profile/bloc/profile_bloc.dart';
import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/ui/widgets/messages.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<ProfileBloc>();
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
          appButtonBack(
            tr("profile"),
          ),
          BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
            return Container(
              width: deviceSize.width,
              padding: const EdgeInsets.symmetric(
                vertical: 75,
                horizontal: 45,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  CircleAvatar(
                    radius: 40.r,
                    backgroundImage: state.user.photoURL.contains('http')
                        ? NetworkImage(state.user.photoURL)
                        : AssetImage(state.user.photoURL) as ImageProvider,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.user.name,
                            style: AppText.baseTextShadow
                                .copyWith(fontSize: 30.sp),
                          ),
                          GestureDetector(
                            onTap: () async {
                              String? enteredName = await showModalBottom(
                                context,
                                TextFieldModel(context, '${tr('username')}?'),
                              );

                              if (enteredName != null &&
                                  enteredName.isNotEmpty) {
                                print('Введенное имя: $enteredName');
                              }
                            },
                            child: const Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 200.h,
                  ),
                  ButtonLong(
                    title: tr('googlelogin'),
                    function: () async {
                      await signup(context);
                    },
                    isPhoto: true,
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  ButtonLong(
                    title: tr('accountlogin'),
                    function: () => router.go('/profile/profile_login'),
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    CircleButton(
                        iconPath: 'assets/svg/exit.svg', click: () async {}),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      tr("exit_profile_text"),
                      style: AppText.baseTextShadow.copyWith(fontSize: 15.sp),
                    ),
                  ]),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// функция для регистрации пользователя в аккаунт Google
  Future<void> signup(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;
      if (user != null) {
        if (context.mounted) {
          context.read<ProfileBloc>().add(ChangeUser(
              name: user.displayName!,
              photoUrl: user.photoURL!,
              uid: user.uid,
              isRegistration: true));
        }
      }
    }
  }
}
