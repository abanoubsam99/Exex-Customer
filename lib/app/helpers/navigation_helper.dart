import 'package:flutter/material.dart';

class NavigationHelper {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static NavigatorState get _nav => navigatorKey.currentState!;

  static Future<T?> push<T>(Widget page) {
    return _nav.push<T>(MaterialPageRoute(builder: (_) => page));
  }

  static Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return _nav.pushNamed<T>(routeName, arguments: arguments);
  }

  static Future<T?> pushReplacementNamed<T>(
    String routeName, {
    Object? arguments,
  }) {
    return _nav.pushReplacementNamed<T, dynamic>(
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> pushNamedAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
  }) {
    return _nav.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void pop<T>([T? result]) => _nav.pop<T>(result);

  static void popUntilNamed(String routeName) {
    _nav.popUntil(ModalRoute.withName(routeName));
  }
}
