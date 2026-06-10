import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscountProgress extends StatelessWidget {
  const DiscountProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 125.h,
      padding: EdgeInsets.all(12.r),
      decoration: ShapeDecoration(
        color: const Color(0x19F38B4A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomImageHandler(
                AppImages.iconsBadgePercent,
                height: 28.r,
                width: 28.r,
              ),
              4.horizontalSpace,
              Text(
                'لفترة محدودة تقدر تستفيد بخصم إضافي 2 %  ',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFF2C262C),
                  fontSize: 14.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  height: 1.43,
                  letterSpacing: -0.24,
                ),
              ),
            ],
          ),
          Text(
            'على كل خدمة من خدمات الحجز الفوري لما تحجز 5 خدمات أو اكتر!',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: const Color(0xFF6F767E),
              fontSize: 12.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w400,
              height: 1.67,
              letterSpacing: -0.24,
            ),
          ),
          8.verticalSpace,
          Text(
            'مجموع الخدمات :',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: const Color(0xFF2C262C),
              fontSize: 12.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w400,
              height: 1.67,
              letterSpacing: -0.24,
            ),
          ),
          4.verticalSpace,
          Row(
            children: [
              Text(
                '2 من 5',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFF2C262C),
                  fontSize: 12.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  height: 1.67,
                  letterSpacing: -0.24,
                ),
              ),
              7.horizontalSpace,
              Expanded(
                child: LinearProgressIndicator(
                  value: 2 / 5,
                  borderRadius: BorderRadius.circular(4.r),
                  minHeight: 5.r,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFFF38B4A),
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
