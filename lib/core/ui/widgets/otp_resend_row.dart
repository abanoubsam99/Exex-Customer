import 'package:evex_user/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The "لم يصلنى الكود ؟ إعادة الإرسال" line under the OTP boxes.
/// Shared by every OTP screen so the resend behaviour (disabled + spinner while
/// the request is in flight) stays identical across the app.
class OtpResendRow extends StatelessWidget {
  final bool isResending;
  final VoidCallback onResend;

  const OtpResendRow({
    super.key,
    required this.isResending,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'لم يصلنى الكود ؟  ',
          style: TextStyle(
            color: AppColors.blacksoft,
            fontSize: 14.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        if (isResending)
          SizedBox(
            width: 16.r,
            height: 16.r,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryColor,
            ),
          )
        else
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
            ),
            onPressed: onResend,
            child: Text(
              'إعادة الإرسال',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 14.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                height: 1.50,
              ),
            ),
          ),
      ],
    );
  }
}
