import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

CustomTransitionPage buildPageWithDefaultTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  required PageTransitionType type,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(
      milliseconds: 250,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        PageTransition(child: child, type: type)
            .buildTransitions(context, animation, secondaryAnimation, child),
  );
}
