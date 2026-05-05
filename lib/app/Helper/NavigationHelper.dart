import 'package:flutter/material.dart';

class NavigationHelper {
  /// Push
  static Future<T?> push<T>(
      BuildContext context,
      Widget page,
      ) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  /// Push Replacement
  static Future<T?> pushReplacement<T, TO>(
      BuildContext context,
      Widget page,
      ) {
    return Navigator.of(context).pushReplacement<T, TO>(
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  /// Push And Remove Until
  static Future<T?> pushAndRemoveUntil<T>(
      BuildContext context,
      Widget page,
      ) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      MaterialPageRoute(
        builder: (_) => page,
      ),
          (route) => false,
    );
  }

  /// Named Push
  static Future<T?> pushNamed<T>(
      BuildContext context,
      String routeName, {
        Object? arguments,
      }) {
    return Navigator.of(context).pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Named Replacement
  static Future<T?> pushReplacementNamed<T, TO>(
      BuildContext context,
      String routeName, {
        Object? arguments,
      }) {
    return Navigator.of(context).pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
    );
  }

  /// Named Remove Until
  static Future<T?> pushNamedAndRemoveUntil<T>(
      BuildContext context,
      String routeName, {
        Object? arguments,
      }) {
    return Navigator.of(context).pushNamedAndRemoveUntil<T>(
      routeName,
          (route) => false,
      arguments: arguments,
    );
  }

  /// Pop
  static void pop<T>(
      BuildContext context, [
        T? result,
      ]) {
    Navigator.of(context).pop(result);
  }

  /// Can Pop
  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  /// Pop Until First
  static void popUntilFirst(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}