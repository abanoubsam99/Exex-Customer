import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/features/main/logic/main_controller.dart';
import 'package:evex_user/features/my_bookings/ui/widgets/discount_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyBookingTopSection extends StatelessWidget {
  const MyBookingTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomBackButtonWidget(
              onTap: () {
                Get.find<MainController>().goToTab(0);
              },
            ),
            12.horizontalSpace,
            Text(
              'حجوزاتي',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: const Color(0xFF121212),
                fontSize: 18.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w800,
                letterSpacing: -0.24,
              ),
            ),
          ],
        ),
        16.verticalSpace,
        DiscountProgress(),
      ],
    );
  }
}
