import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/cubits/main/main_cubit.dart';
import 'package:evex_user/data/cubits/main/main_state.dart';
import 'package:evex_user/features/home/ui/home_screen.dart';
import 'package:evex_user/features/more/ui/more_screen.dart';
import 'package:evex_user/features/my_bookings/ui/my_bookings_screen.dart';
import 'package:evex_user/features/wallet/ui/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const List<Widget> _pages = [
    HomeScreen(),
    MyBookingsScreen(),
    WalletScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MainCubit>();
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: cubit.pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: cubit.animateToTab,
            children: _pages.map((page) {
              return Padding(
                padding: EdgeInsets.only(bottom: 74.h),
                child: page,
              );
            }).toList(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 74.r,
              margin: EdgeInsets.all(22.r),
              padding: EdgeInsets.symmetric(horizontal: 35.r, vertical: 12.r),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 22,
                    offset: Offset(0, 4),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: BlocBuilder<MainCubit, MainState>(
                builder: (context, state) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _NavItem(
                      icon: AppImages.iconsHouse,
                      label: 'الرئيسيه',
                      page: 0,
                      currentPage: state.currentPage,
                      onTap: () => cubit.goToTab(0),
                    ),
                    _NavItem(
                      // materialIcon: Icons.shopping_cart_outlined,
                      icon: AppImages.iconsCart,
                      label: 'حجوزاتى',
                      page: 1,
                      currentPage: state.currentPage,
                      onTap: () => cubit.goToTab(1),
                    ),
                    _NavItem(
                      icon: AppImages.iconsWallet,
                      label: 'المحفظه',
                      page: 2,
                      currentPage: state.currentPage,
                      onTap: () => cubit.goToTab(2),
                    ),
                    _NavItem(
                      icon: AppImages.iconsMenu,
                      label: 'المزيد',
                      page: 3,
                      currentPage: state.currentPage,
                      onTap: () => cubit.goToTab(3),
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
}

class _NavItem extends StatelessWidget {
  /// Asset path for an SVG/PNG icon. Use either [icon] or [materialIcon].
  final String? icon;

  /// A built-in Material icon, rendered when [icon] is not provided.
  final IconData? materialIcon;
  final String label;
  final int page;
  final int currentPage;
  final VoidCallback onTap;

  const _NavItem({
    this.icon,
    this.materialIcon,
    required this.label,
    required this.page,
    required this.currentPage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentPage == page;
    final color = isActive ? AppColors.primaryColor : AppColors.grey;
    return ZoomTapAnimation(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            materialIcon != null
                ? Icon(materialIcon, color: color, size: 24.r)
                : CustomImageHandler(
                    icon!,
                    color: color,
                    height: 24.r,
                    width: 24.r,
                  ),
            4.verticalSpace,
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primaryColor : AppColors.grey,
                fontSize: 12.r,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
