import 'package:expansion/ui/home/home_page.dart';
import 'package:expansion/ui/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final routes = RouteMap(routes: {
  '/': (_) => const CupertinoTabPage(
        child: HomePage(),
        paths: ['/settings'],
      ),
  '/settings': (_) => const MaterialPage(child: SettingsPage()),
});
