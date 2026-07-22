// import 'dart:io';

import 'package:evex_user/core/constants/app_images.dart';
// import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/cubits/auth/login/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Quick-login row: currently only the fingerprint/biometric button.
/// Google, Apple and Facebook are fully prepared but kept commented out
/// (disabled).
class AllSocalMediaWidget extends StatelessWidget {
  const AllSocalMediaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ── Fingerprint / biometric ──
        _SocialButton(
          onTap: () => cubit.loginWithBiometrics(),
          child: CustomImageHandler(
            AppImages.iconsLocalAuth,
            height: 28.r,
            width: 28.r,
          ),
        ),
        // 14.horizontalSpace,
        // ── Google (prepared — disabled) ──
        // _SocialButton(
        //   onTap: () => cubit.loginWithGoogle(),
        //   child: CustomImageHandler(
        //     AppImages.iconsGoogel,
        //     height: 28.r,
        //     width: 28.r,
        //   ),
        // ),
        // 14.horizontalSpace,
        // ── Facebook (prepared — disabled) ──
        // _SocialButton(
        //   onTap: () => cubit.loginWithFacebook(),
        //   child: CustomImageHandler(
        //     AppImages.iconsSocialFacebook,
        //     height: 28.r,
        //     width: 28.r,
        //   ),
        // ),
        // 14.horizontalSpace,
        // ── Apple (iOS only — prepared, disabled) ──
        // Apple sign-in only works natively on iOS; on Android the native
        // sheet isn't available, so the button is hidden there.
        // if (Platform.isIOS)
        //   _SocialButton(
        //     onTap: () => cubit.loginWithApple(),
        //     child: Icon(Icons.apple, size: 30.r, color: AppColors.blacksoft),
        //   ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _SocialButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52.r,
        height: 52.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
