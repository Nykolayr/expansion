import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:expansion/presentation/pages/battle_page.dart';
import 'package:expansion/presentation/pages/begin_page.dart';
import 'package:expansion/presentation/pages/intro_story_page.dart';
import 'package:expansion/presentation/pages/maps_page.dart';
import 'package:expansion/presentation/pages/profile_page.dart';
import 'package:expansion/presentation/pages/progress_page.dart';
import 'package:expansion/presentation/pages/upgrades_page.dart';
import 'package:expansion/presentation/pages/settings_page.dart';
import 'package:expansion/presentation/pages/splash_page.dart';

/// Корневой роутер. Новые маршруты добавляй в [routes].
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashPage();
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (BuildContext context, GoRouterState state) {
        return const SettingsPage();
      },
    ),
    GoRoute(
      path: '/intro-story',
      name: 'introStory',
      builder: (BuildContext context, GoRouterState state) {
        return const IntroStoryPage();
      },
    ),
    GoRoute(
      path: '/maps',
      name: 'maps',
      builder: (BuildContext context, GoRouterState state) {
        return const MapsPage();
      },
    ),
    GoRoute(
      path: '/begin',
      name: 'begin',
      builder: (BuildContext context, GoRouterState state) {
        return const BeginPage();
      },
    ),
    GoRoute(
      path: '/battle',
      name: 'battle',
      builder: (BuildContext context, GoRouterState state) {
        final extra = state.extra;
        final sceneId = extra is int ? extra : null;
        return BattlePage(sceneId: sceneId);
      },
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (BuildContext context, GoRouterState state) {
        return const ProfilePage();
      },
    ),
    GoRoute(
      path: '/progress',
      name: 'progress',
      builder: (BuildContext context, GoRouterState state) {
        return const ProgressPage();
      },
    ),
    GoRoute(
      path: '/upgrades',
      name: 'upgrades',
      builder: (BuildContext context, GoRouterState state) {
        return const UpgradesPage();
      },
    ),
  ],
);
