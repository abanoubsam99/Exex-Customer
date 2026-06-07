import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtherServicesSection extends StatelessWidget {
  const OtherServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 6.r,
              height: 18.r,
              decoration: ShapeDecoration(
                color: const Color(0xFFF38B4A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),
            8.horizontalSpace,
            Text(
              'خدمات أخرى',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                letterSpacing: -0.24,
              ),
            ),
          ],
        ),
        11.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 157.w,
              height: 51.h,
              decoration: ShapeDecoration(
                color: const Color(0xFF79E2B2).withValues(alpha: 0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 30,
                    offset: Offset(0, 14),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16.r),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16.r),
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Row(
                      children: [
                        CustomImageHandler(
                          AppImages.imagesTimeIsMoney,
                          fit: BoxFit.fill,
                          height: 34.r,
                          width: 34.r,
                        ),
                        11.horizontalSpace,
                        Text(
                          'خدمة قسطلي',
                          style: TextStyle(
                            color: Color(0xFF2C262C),
                            fontSize: 14.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w700,
                            height: 1.14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            13.horizontalSpace,
            Container(
              width: 157.w,
              height: 51.h,
              decoration: ShapeDecoration(
                color: const Color(0xFFF38B4A).withValues(alpha: 0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 30,
                    offset: Offset(0, 14),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16.r),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16.r),
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Row(
                      children: [
                        CustomImageHandler(
                          AppImages.imagesTimeIsRight,
                          fit: BoxFit.fill,
                          height: 40.r,
                          width: 40.r,
                        ),
                        2.horizontalSpace,
                        Text(
                          'خدمة نظملي',
                          style: TextStyle(
                            color: Color(0xFF2C262C),
                            fontSize: 14.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w700,
                            height: 1.14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
