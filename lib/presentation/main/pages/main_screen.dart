import 'package:evexcustomer/app/constants/app_images.dart';
import 'package:evexcustomer/app/constants/MyColors.dart';
import 'package:evexcustomer/app/widgets/custom_image_handler.dart';
import 'package:evexcustomer/presentation/home/pages/home_screen.dart';
import 'package:evexcustomer/presentation/my_bookings/pages/my_bookings_screen.dart';
import 'package:evexcustomer/presentation/payment_history/pages/payment_history_screen.dart';
import 'package:evexcustomer/presentation/more/pages/more_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentPage = 0;

  late final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const MyBookingsScreen(),
    const PaymentHistoryScreen(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 74.h),
            child: IndexedStack(index: _currentPage, children: _pages),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              // width: 335,
              height: 74.r,
              margin: EdgeInsets.all(22.r),
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
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

              child: Row(
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
      onTap: () => setState(() => _currentPage = page as int),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomImageHandler(
              icon,
              color:
                  _currentPage == page
                      ? AppColors.primaryColor
                      : AppColors.grey,
              height: 24.r,
              width: 24.r,
            ),
            4.verticalSpace,
            Text(
              label,
              style: TextStyle(
                color:
                    _currentPage == page
                        ? AppColors.primaryColor
                        : AppColors.grey,
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


