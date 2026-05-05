import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'other_service_card_item.dart';

class OtherServicesSection  extends StatelessWidget  {
  const OtherServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        8.verticalSpace,
        Text(
          'مُقدمه من نفس التاجر أو مقدم الخدمة',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: const Color(0xFF6F767E),
            fontSize: 12.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        4.verticalSpace,
        SizedBox(
          height: 140.h,
          child: ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => 16.horizontalSpace,
            itemBuilder: (context, index) {
              return OtherServiceCardItem(
                images:  [],
                title:  'name',
              );
            },
          ),
        ),
      ],
    );
  }
}
