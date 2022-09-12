import 'package:expansion/ui/begin/bloc/begin_bloc.dart';
import 'package:expansion/ui/begin/home_page.dart';
import 'package:expansion/ui/settings/settings_page.dart';
import 'package:expansion/ui/splash/bloc/splash_bloc.dart';
import 'package:expansion/ui/splash/splash_page.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <GoRoute>[
    GoRoute(
      name: 'splash',
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return RepositoryProvider(
          create: (context) => userRepository,
          child: BlocProvider(
            create: (_) => SplashBloc()..add(const LoadBegin()),
            child: const SplashPage(),
          ),
        );
      },
      routes: [],
    ),
    GoRoute(
      name: 'begin',
      path: '/begin',
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (_) => BeginBloc(),
          child: const BeginPage(),
        );
      },
      routes: [],
    ),
    GoRoute(
      path: '/settings',
      builder: (BuildContext context, GoRouterState state) {
        return const SettingsPage();
      },
    ),
  ],
);
