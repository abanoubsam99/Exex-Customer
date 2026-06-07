import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

loadingAlertDialog(BuildContext context, {bool isDismissible = false}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          alignment: Alignment.center,
          child: const CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      );
    },
  );
}
