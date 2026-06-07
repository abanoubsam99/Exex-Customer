import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primaryColor),
    );
  }
}

void startLoading() {
  final context = NavigationHelper.navigatorKey.currentContext;
  if (context == null) return;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const CustomLoader(),
  );
}

void stopLoading() {
  NavigationHelper.pop();
}
