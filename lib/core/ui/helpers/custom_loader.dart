import 'package:evex_user/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const CircularProgressIndicator(color: AppColors.primaryColor),
    );
  }
}

startLoading() {
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    useSafeArea: true,
    builder: (context) => const CustomLoader(),
  );
}

stopLoading() {
  Get.back();
}
