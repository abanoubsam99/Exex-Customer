import 'dart:ui';

import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/helpers/auth_guard.dart';
import 'package:evex_user/core/ui/widgets/custom_circle.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/cubits/home/home_state.dart';
import 'package:evex_user/features/home/ui/widgets/home_banner_carousel.dart';
import 'package:evex_user/features/home/ui/widgets/user_data_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The home screen's top block: a blurred colour-blob backdrop carrying the
/// user row + search bar, with the white rounded sheet (and its banner
/// carousel) overlapping its bottom half.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  /// Figma: the backdrop is 256h, the white sheet starts at 188h and the whole
  /// block (sheet + banner + its bottom padding) ends at 368h.
  static const double _backdropHeight = 256;
  static const double _sheetTop = 188;
  static const double _totalHeight = 368;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _totalHeight.h,
      child: Stack(
        children: [
          const _HeaderBackdrop(height: _backdropHeight),
          Positioned.fill(
            top: _sheetTop.h,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(30.r)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    20.verticalSpace,
                    const HomeBannerCarousel(),
                    16.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Three colour blobs behind a heavy blur — the frosted-glass header background.
class _HeaderBackdrop extends StatelessWidget {
  final double height;
  const _HeaderBackdrop({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: height.h,
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            top: -52.r,
            left: -46.r,
            child: CustomCircle(radius: 107.r, color: AppColors.greenSoft),
          ),
          Positioned(
            top: -91.h,
            left: 146.w,
            child: CustomCircle(radius: 163.r, color: AppColors.primaryColor),
          ),
          Positioned(
            top: 67.h,
            left: 321.w,
            child: CustomCircle(radius: 107.r, color: AppColors.amber),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 141,
              sigmaY: 141,
              tileMode: TileMode.clamp,
            ),
            child: Container(
              width: 1.sw,
              height: height.h,
              color: AppColors.bgLightGrey.withValues(alpha: 0.5),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    64.verticalSpace,
                    const UserDataSection(),
                    14.verticalSpace,
                    const _HeaderActionsRow(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Search field + the payment-history and notifications actions.
class _HeaderActionsRow extends StatelessWidget {
  const _HeaderActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _HomeSearchField()),
        _HeaderIconButton(
          icon: CustomImageHandler(
            AppImages.iconsReceipt,
            width: 22.r,
            height: 22.r,
            color: Colors.black,
          ),
          onTap: () =>
              NavigationHelper.pushNamed(Routes.paymentHistoryScreen),
        ),
        _HeaderIconButton(
          icon: BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (p, c) => p.unreadNotifications != c.unreadNotifications,
            builder: (context, state) =>
                _NotificationBell(count: state.unreadNotifications),
          ),
          onTap: () {
            // Opening the screen marks all as read, so clear the badge now.
            context.read<HomeCubit>().clearUnreadNotifications();
            NavigationHelper.pushNamed(Routes.notificationsScreen);
          },
        ),
      ],
    );
  }
}

/// A header action that's only available to a signed-in user.
class _HeaderIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;
  const _HeaderIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (!AuthGuard.requireLogin(context)) return;
        onTap();
      },
      icon: icon,
    );
  }
}

/// Home search box — matches Figma exactly: 40h, white fill, 1px orange border,
/// 16r radius, "بحث ..." hint in #99A2AC (Almarai 14).
class _HomeSearchField extends StatelessWidget {
  const _HomeSearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primaryColor, width: 1),
      ),
      alignment: Alignment.center,
      child: TextField(
        textAlign: TextAlign.right,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 14.r,
          color: AppColors.blacksoft,
        ),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          hintText: 'بحث ...',
          hintStyle: TextStyle(
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w400,
            fontSize: 14.r,
            // Figma hint colour (#99A2AC).
            color: const Color(0xFF99A2AC),
          ),
        ),
      ),
    );
  }
}

/// The bell icon with a red unread-count badge on top (hidden when [count] 0).
class _NotificationBell extends StatelessWidget {
  final int count;
  const _NotificationBell({required this.count});

  @override
  Widget build(BuildContext context) {
    final bell = CustomImageHandler(
      AppImages.iconsNotification,
      width: 22.r,
      height: 22.r,
    );
    if (count <= 0) return bell;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        bell,
        Positioned(
          top: -6.r,
          right: -6.r,
          child: Container(
            constraints: BoxConstraints(minWidth: 16.r, minHeight: 16.r),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              count > 99 ? '99+' : '$count',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 9.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
