import 'package:evexcustomer/app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewSuggestionSection extends StatelessWidget {
  const NewSuggestionSection({super.key});

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
              'اقتراح جديد !',
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
        16.verticalSpace,
        Stack(
          children: [
            Container(
              width: 1.sw,
              height: 76.h,
              decoration: ShapeDecoration(
                color: const Color(0x33AED0E7),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: const Color(0xFFAED0E7)),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            // Transform.rotate(
            //   angle: -4.5 * Math.pi / 180,
            //   child: Container(
            //     width: 1.sw,
            //     height: 89.h,
            //     decoration: ShapeDecoration(
            //       color: const Color(0x23F38B4A),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(16),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 76.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.verticalSpace,
                    Text(
                      'اقترح تاجر جديد ..',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0xFF2C262C),
                        fontSize: 14.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.24,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      'يمكنك اقتراح تاجر أو مقدم خدمة جديد \nوالحصول على خصم عند الحجز',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0xFF787878),
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                        height: 1.46,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10.r,
              left: 8.r,
              child: Center(
                child: CustomButton(
                  height: 26.h,
                  width: 75.w,
                  borderRadius: 8.r,
                  fontSize: 13.r,
                  backgroundColor: Color(0xFFB6DAEE),
                  fontColor: Color(0xFF6681AF),
                  bordereColor: Color(0xFFB6DAEE),
                  text: 'اقترح الآن',
                  onTap: () {},
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

