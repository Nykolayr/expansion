import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

/// функция создает различные анимации для переходов по страницам
CustomTransitionPage<dynamic> buildPageWithDefaultTransition({
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

/// функция которая возращает null, если нет вхождений
T? findFirstWhereOrNull<T>(Iterable<T> items, bool Function(T) test) {
  for (final item in items) {
    if (test(item)) {
      return item;
    }
  }
  return null;
}

/// функция которая перемешивает список
void shuffle(List<dynamic> elements,
    {int start = 0, int? end, Random? random}) {
  random ??= Random();
  end ??= elements.length;
  var length = end - start;
  while (length > 1) {
    final pos = random.nextInt(length);
    length--;
    final tmp1 = elements[start + pos];
    elements[start + pos] = elements[start + length];
    elements[start + length] = tmp1;
  }
}

/// печать длинных строк
void prints(Object s1) {
  final s = s1.toString();
  final pattern = RegExp('.{1,800}');
  // ignore: avoid_print
  pattern.allMatches(s).forEach((match) => print(match.group(0)));
}
