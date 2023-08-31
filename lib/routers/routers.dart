import 'package:expansion/ui/battle/battle_page.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/ui/battle/widgets/help.dart';
import 'package:expansion/ui/begin/begin_page.dart';
import 'package:expansion/ui/begin/bloc/begin_bloc.dart';
import 'package:expansion/ui/help_game/help_game.dart';
import 'package:expansion/ui/maps/bloc/maps_bloc.dart';
import 'package:expansion/ui/maps/maps_page.dart';
import 'package:expansion/ui/splash/bloc/splash_bloc.dart';
import 'package:expansion/ui/splash/splash_page.dart';
import 'package:expansion/ui/splash/sub/profile/bloc/profile_bloc.dart';
import 'package:expansion/ui/splash/sub/profile/profile_page.dart';
import 'package:expansion/ui/splash/sub/profile_login/bloc/profile_login_bloc.dart';
import 'package:expansion/ui/splash/sub/profile_login/profile_login_page.dart';
import 'package:expansion/ui/splash/sub/profile_register/profile_register_page.dart';
import 'package:expansion/ui/splash/sub/progress/bloc/progress_bloc.dart';
import 'package:expansion/ui/splash/sub/progress/progress_page.dart';
import 'package:expansion/ui/splash/sub/settings/bloc/setting_bloc.dart';
import 'package:expansion/ui/splash/sub/settings/settings_page.dart';
import 'package:expansion/ui/splash/sub/update/bloc/update_bloc.dart';
import 'package:expansion/ui/splash/sub/update/update_page.dart';
import 'package:expansion/utils/function.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: <GoRoute>[
    GoRoute(
      name: 'splash',
      path: '/',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        type: PageTransitionType.topToBottom,
        context: context,
        state: state,
        child: BlocProvider(
          create: (_) => SplashBloc()..add(const LoadBegin()),
          child: const SplashPage(),
        ),
      ),
      routes: [
        GoRoute(
          name: 'maps',
          path: 'maps',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            type: PageTransitionType.topToBottom,
            context: context,
            state: state,
            child: BlocProvider(
              create: (_) => MapsBloc(),
              child: const MapsPage(),
            ),
          ),
        ),
        GoRoute(
          name: 'helpGame',
          path: 'helpGame',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            type: PageTransitionType.topToBottom,
            context: context,
            state: state,
            child: const HelpGamePage(),
          ),
        ),
        GoRoute(
          name: 'settings',
          path: 'settings',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            type: PageTransitionType.topToBottom,
            context: context,
            state: state,
            child: BlocProvider(
              create: (_) => SettingBloc(),
              child: const SettingsPage(),
            ),
          ),
        ),
        GoRoute(
            name: 'profile',
            path: 'profile',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
                  type: PageTransitionType.topToBottom,
                  context: context,
                  state: state,
                  child: BlocProvider(
                    create: (_) => ProfileBloc(),
                    child: const ProfilePage(),
                  ),
                ),
            routes: [
              GoRoute(
                name: 'profileLogin',
                path: 'profile_login',
                pageBuilder: (context, state) => buildPageWithDefaultTransition(
                  type: PageTransitionType.rightToLeft,
                  context: context,
                  state: state,
                  child: BlocProvider.value(
                    value: ProfileBloc(),
                    child: const ProfileLoginPage(),
                  ),
                ),
              ),
              GoRoute(
                name: 'profileRegister',
                path: 'profile_Register',
                pageBuilder: (context, state) => buildPageWithDefaultTransition(
                  type: PageTransitionType.rightToLeft,
                  context: context,
                  state: state,
                  child: BlocProvider.value(
                    value: ProfileBloc(),
                    child: const ProfileRegisterPage(),
                  ),
                ),
              ),
            ]),
        GoRoute(
          name: 'progress',
          path: 'progress',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            type: PageTransitionType.topToBottom,
            context: context,
            state: state,
            child: BlocProvider(
              create: (_) => ProgressBloc(),
              child: const ProgressPage(),
            ),
          ),
        ),
        GoRoute(
          name: 'update',
          path: 'update',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            type: PageTransitionType.topToBottom,
            context: context,
            state: state,
            child: BlocProvider(
              create: (_) => UpdateBloc(),
              child: const UpdatePage(),
            ),
          ),
        ),
        GoRoute(
          name: 'new game',
          path: 'new_game',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            type: PageTransitionType.rightToLeft,
            context: context,
            state: state,
            child: BlocProvider(
              create: (_) => BeginBloc(),
              child: const BeginPage(),
            ),
          ),
        ),
        GoRoute(
          name: 'Profile Login',
          path: 'profile_login',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            type: PageTransitionType.rightToLeft,
            context: context,
            state: state,
            child: BlocProvider(
              create: (_) => ProfileLoginBloc(),
              child: const ProfileLoginPage(),
            ),
          ),
        ),
      ],
    ),
    GoRoute(
      name: 'battle',
      path: '/battle',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        type: PageTransitionType.fade,
        context: context,
        state: state,
        child: BlocProvider(
          create: (_) {
            return BattleBloc()..add(InitEvent());
          },
          child: const BattlePage(),
        ),
      ),
    ),
    GoRoute(
      name: 'help',
      path: '/help',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        type: PageTransitionType.topToBottom,
        context: context,
        state: state,
        child: const HelpPage(),
      ),
    ),
  ],
);
