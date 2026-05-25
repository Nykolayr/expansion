import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:expansion/presentation/pages/intro_story_page.dart';
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
  ],
);
