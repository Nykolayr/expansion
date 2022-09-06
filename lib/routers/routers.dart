import 'package:expansion/ui/home/bloc/home_bloc.dart';
import 'package:expansion/ui/home/home_page.dart';
import 'package:expansion/ui/settings/settings_page.dart';
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
            create: (_) => HomeBloc(),
            child: const SplashPage(),
          ),
        );
      },
      routes: [],
    ),
    GoRoute(
      name: 'home',
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
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
