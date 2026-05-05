import 'package:evexcustomer/presentation/booking_services/widgets/service_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

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
              'الخدمات الأساسية',
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
        Row(
          children: [
            Container(
              width: 13.r,
              height: 13.r,
              decoration: ShapeDecoration(
                color: const Color(0xFF79E2B2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            6.horizontalSpace,
            Text(
              'خدمة متاحة',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF6F767E),
                fontSize: 12.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w400,
                height: 1.30,
                letterSpacing: -0.24,
              ),
            ),
            Spacer(),
            Container(
              width: 13.r,
              height: 13.r,
              decoration: ShapeDecoration(
                color: const Color(0xFFFE7062),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            6.horizontalSpace,
            Text(
              'خدمة غير متاحة فى هذا اليوم',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF6F767E),
                fontSize: 12.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w400,
                height: 1.30,
                letterSpacing: -0.24,
              ),
            ),
          ],
        ),
        4.verticalSpace,
        SizedBox(
          height: 180.h,
          child: ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => 16.horizontalSpace,
            itemBuilder: (context, index) {
              return ServiceCardItem(
                images:  [],
                title:  'name',
                subtitle:  "details",
                price:  0,
                // isSelected: controller.selectedService.value?.id == service.id,
                onSelectionChanged: () {
                  // controller.selectedService.value = service;
                  // controller.getServicedata();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
