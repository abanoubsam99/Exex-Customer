import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Gates account-based actions behind a login. Guests browse freely, but any
/// account action calls [requireLogin] first and is blocked with a prompt.
class AuthGuard {
  AuthGuard._();

  /// Returns `true` when a real user is signed in. For guests it shows a
  /// login prompt and returns `false`, so the caller should abort its action:
  ///
  /// ```dart
  /// if (!AuthGuard.requireLogin(context)) return;
  /// ```
  static bool requireLogin(BuildContext context) {
    final isSignedIn = context.read<UserService>().currentUser != null;
    if (isSignedIn) return true;
    _showLoginSheet(context);
    return false;
  }

  static void _showLoginSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.r,
              height: 56.r,
              decoration: const BoxDecoration(
                color: AppColors.peachBg1,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.lock_outline_rounded,
                color: AppColors.primaryColor,
                size: 28.r,
              ),
            ),
            16.verticalSpace,
            Text(
              'سجّل دخولك أولاً',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blacksoft,
                fontSize: 16.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w800,
              ),
            ),
            8.verticalSpace,
            Text(
              'محتاج تسجّل دخولك عشان تكمّل العملية دي',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 13.r,
                fontFamily: 'Almarai',
                height: 1.6,
              ),
            ),
            20.verticalSpace,
            CustomButton(
              text: 'تسجيل الدخول',
              height: 48.h,
              onTap: () {
                Navigator.pop(ctx);
                NavigationHelper.pushNamed(Routes.loginScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}
