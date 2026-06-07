import 'package:evex_user/features/booking_services/booking_service_details/data/models/port_service.dart';
import 'package:evex_user/features/booking_services/booking_service_details/logic/port_services_controller.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/other_service_card_item.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/service_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OtherServicesSection extends GetView<PortServicesController> {
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
        Obx(
          () => SizedBox(
            height: 140.h,
            child: ListView.separated(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              itemCount: controller.services.value.length,
              separatorBuilder: (context, index) => 16.horizontalSpace,
              itemBuilder: (context, index) {
                PortService service = controller.services.value[index];
                return Obx(
                  () => OtherServiceCardItem(
                    images: service.serviceImages ?? [],
                    title: service.name ?? '',
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
