import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JoinUsSection extends StatelessWidget {
  const JoinUsSection({super.key});

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
              'انضم الينا !',
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
              height: 89.h,
              decoration: ShapeDecoration(
                color: const Color(0x23F38B4A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Transform.rotate(
              angle: -4.5 * Math.pi / 180,
              child: Container(
                width: 1.sw,
                height: 89.h,
                decoration: ShapeDecoration(
                  color: const Color(0x23F38B4A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 89.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.verticalSpace,
                    Text(
                      'انضم الينا الآن ..',
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
                      'يمكنك أن تصبح شريكاً حقيقياً للنجاح \n انضم الآن لشبكة evex وتمتع بمميزات حصرية',
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
                    Row(
                      children: [
                        Spacer(),
                        Text(
                          'عرض المزيد',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: const Color(0xFFF38B4A),
                            fontSize: 13.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w700,
                            height: -0.0002,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
