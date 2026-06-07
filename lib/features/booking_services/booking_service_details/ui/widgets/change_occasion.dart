import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_circle.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangeOccasion extends StatelessWidget {
  const ChangeOccasion({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 5.h),
      decoration: ShapeDecoration(
        color: Color(0xFFF7F7F7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CustomCircle(radius: 14.r, color: Color(0x6879E2B2)),
                  CustomCircle(radius: 6.r, color: Color(0xFF79E2B2)),
                ],
              ),
              6.horizontalSpace,
              Text(
                'متاح للحجز الفوري',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFF42C287),
                  fontSize: 14.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Spacer(),
              GradientText(
                'متجدد لحظه بلحظه',
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0, 0.64, 1],
                  colors: [
                    const Color(0xFF79E2B2),
                    const Color(0xFF55A07E),
                    const Color(0xFF79E2B2),
                  ],
                ),
                style: TextStyle(
                  color: const Color(0xFF99A2AC),
                  fontSize: 12.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          4.verticalSpace,
          Row(
            children: [
              Text(
                '22 اكتوبر 2026',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF2C262C),
                  fontSize: 14.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                ),
              ),
              6.horizontalSpace,
              Transform.translate(
                offset: Offset(0, 2.h),
                child: CustomCircle(radius: 5.r, color: Color(0xFFD9D9D9)),
              ),
              6.horizontalSpace,
              Text(
                'اسيوط, اسيوط, مصر',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF99A2AC),
                  fontSize: 14.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                ),
              ),
              6.horizontalSpace,
              Transform.translate(
                offset: Offset(0, 2.h),
                child: CustomCircle(radius: 5.r, color: Color(0xFFD9D9D9)),
              ),
              6.horizontalSpace,
              const Text(
                'فرح',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF99A2AC),
                  fontSize: 14,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                  letterSpacing: -0.24,
                ),
              ),
              const Spacer(),
              CustomImageHandler(
                AppImages.iconsEdit,
                width: 14.r,
                height: 14.r,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
