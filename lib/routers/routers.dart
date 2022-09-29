import 'package:expansion/ui/begin/bloc/begin_bloc.dart';
import 'package:expansion/ui/begin/begin_page.dart';
import 'package:expansion/ui/splash/bloc/splash_bloc.dart';
import 'package:expansion/ui/splash/splash_page.dart';
import 'package:expansion/ui/splash/sub/settings/bloc/setting_bloc.dart';
import 'package:expansion/ui/splash/sub/settings/settings_page.dart';
import 'package:expansion/utils/function.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

final GoRouter router = GoRouter(
  // initialLocation: '/',
  routes: <GoRoute>[
    GoRoute(
      name: 'splash',
      path: '/',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        type: PageTransitionType.topToBottom,
        context: context,
        state: state,
        child: RepositoryProvider(
          create: (context) => userRepository,
          child: BlocProvider(
            create: (_) => SplashBloc()..add(const LoadBegin()),
            child: const SplashPage(),
          ),
        ),
      ),
      routes: [
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
      ],
    ),
    GoRoute(
      name: 'new game',
      path: '/new_game',
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
      name: 'game',
      path: '/game',
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
  ],
);
