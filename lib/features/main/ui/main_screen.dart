import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/features/main/logic/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: controller.animateToTab,
            children: controller.pages.map((page) {
              return Padding(
                padding: EdgeInsets.only(bottom: 74.h),
                child: page,
              );
            }).toList(),
          ),
          Positioned(
            // left: 22.r,
            // right: 22.r,
            // bottom: 22.r,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              // width: 335,
              height: 74.r,
              margin: EdgeInsets.all(22.r),
              padding: EdgeInsets.symmetric(horizontal: 35.r, vertical: 12.r),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 22,
                    offset: Offset(0, 4),
                    spreadRadius: 2,
                  ),
                ],
              ),

              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _bottomAppBarItem(
                      icon: AppImages.iconsHouse,
                      page: 0,
                      context,
                      label: "الرئيسيه",
                    ),
                    _bottomAppBarItem(
                      icon: AppImages.iconsReceipt,
                      page: 1,
                      context,
                      label: "حجوزاتى",
                    ),
                    _bottomAppBarItem(
                      icon: AppImages.iconsWallet,
                      page: 2,
                      context,
                      label: "المحفظه",
                    ),
                    _bottomAppBarItem(
                      icon: AppImages.iconsMenu,
                      page: 3,
                      context,
                      label: "المزيد",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomAppBarItem(
    BuildContext context, {
    required icon,
    required page,
    required label,
  }) {
    return ZoomTapAnimation(
      onTap: () => controller.goToTab(page),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomImageHandler(
              icon,
              color: controller.currentPage == page
                  ? AppColors.primaryColor
                  : AppColors.grey,
              height: 24.r,
              width: 24.r,
            ),
            4.verticalSpace,
            Text(
              label,
              style: TextStyle(
                color: controller.currentPage == page
                    ? AppColors.primaryColor
                    : AppColors.grey,
                fontSize: 12.r,
                fontWeight: FontWeight.w700,
                // fontWeight:
                //     controller.currentPage == page ? FontWeight.w600 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
