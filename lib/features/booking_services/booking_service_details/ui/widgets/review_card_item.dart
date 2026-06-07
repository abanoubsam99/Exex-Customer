// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:evex_user/features/booking_services/booking_service_details/data/models/customer_review.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewCardItem extends StatelessWidget {
  final CustomerReview customerReview;
  const ReviewCardItem({super.key, required this.customerReview});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
      height: 115.h,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFF2F4F7)),
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: ShapeDecoration(
                    color: const Color(0x28F38B4A),
                    shape: OvalBorder(),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 33.r,
                    height: 33.r,
                    decoration: ShapeDecoration(
                      color: Colors.transparent,
                      shape: OvalBorder(
                        side: BorderSide(width: 2.5, color: Colors.white),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'م',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0xFFF38B4A),
                        fontSize: 14.r,
                        // fontFamily: 'Amita',
                        fontWeight: FontWeight.w700,
                        // height: 1.50,
                        height: -0.4,
                      ),
                    ),
                  ),
                ),
                6.horizontalSpace,

                Column(
                  children: [
                    Text(
                      'مينا نبيل',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0xFF2C262C),
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    6.verticalSpace,
                    Text(
                      '12/10/2026',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0xFF99A2AC),
                        fontSize: 12.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(top: 2.h),
                  width: 36.r,
                  height: 19.r,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF3FC086),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.r),
                        topRight: Radius.circular(2.r),
                        bottomLeft: Radius.circular(2.r),
                        bottomRight: Radius.circular(8.r),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.white, size: 14.r),
                      Text(
                        '5.0',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                      4.horizontalSpace,
                    ],
                  ),
                ),
              ],
            ),
            6.verticalSpace,
            Text(
              'القاعه كانت حلوه جدا وكنت مبسوط وانا هناك والدى جى كان حلو ورايق بس كان زحمه اوى بس فى الاخر جابولنا كراسي وترابيزات ف كان الجو لذيذ اوى ',
              textAlign: TextAlign.right,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF6F767E),
                fontSize: 12.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
