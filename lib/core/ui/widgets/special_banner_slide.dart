import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/helpers/auth_guard.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Static promotional banner (specialbannar.png) shown as the first slide of
/// every "عروض مميزة" carousel (home, instant-booking, direct-services). It is
/// always present: even when the backend returns no offers the carousel still
/// shows this banner on its own. Fills the carousel slot with rounded corners.
/// Tapping this in-house ad opens the "انضم الينا" (join us) screen; guests are
/// prompted to sign in first.
class SpecialBannerSlide extends StatelessWidget {
  const SpecialBannerSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!AuthGuard.requireLogin(context)) return;
        NavigationHelper.pushNamed(Routes.requestToJoinScreen);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: CustomImageHandler(
          AppImages.imagesSpecialBanner,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
