import 'package:evex_user/features/booking_services/booking_service_details/data/models/customer_review.dart';
import 'package:evex_user/features/booking_services/booking_service_details/data/models/port_service.dart';
import 'package:evex_user/features/booking_services/booking_service_details/logic/port_services_controller.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/service_card_item.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/review_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ReviewsSection extends GetView<PortServicesController> {
  const ReviewsSection({super.key});

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
              'آراء العملاء',
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
        12.verticalSpace,
        SizedBox(
          height: 115.h,
          child: ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: customerReviews.length,
            separatorBuilder: (context, index) => 10.horizontalSpace,
            itemBuilder:
                (context, index) =>
                    ReviewCardItem(customerReview: customerReviews[index]),
          ),
        ),
      ],
    );
  }
}
