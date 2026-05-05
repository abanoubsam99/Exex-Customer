import 'package:evexcustomer/app/constants/app_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/widgets/custom_image_handler.dart';
import '../../../app/widgets/shimmer_skelton.dart';
import '../../../app/widgets/speech_bubble_border.dart';
import 'booking_services_type.dart';

class InstantBookingServicesSection extends StatelessWidget{
  const InstantBookingServicesSection({super.key});

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
              'خدمات الحجز الفوري',
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
        false==true
            ? SizedBox(
          height: 70.h,
          child: ListView.builder(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemBuilder:
                (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ShimmerSkelton(width: 74.w, height: 68.h),
            ),
            itemCount: 2,
          ),
        )
            : SizedBox(
          height: 100.h,
          child: ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount:5,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // controller.selectedBookingPortType.value = null;
                  // controller.selectedBookingPort.value =
                  // controller.bookingPorts[index];
                },
                child: Center(
                  child: Container(
                    width: 74.w,
                    height: 68.h,
                    decoration:false==true
                        ? ShapeDecoration(
                      color: Colors.white,
                      shape: SpeechBubbleBorder(
                        borderColor: const Color(
                          0xffF38B4A,
                        ),
                        borderWidth: 2,
                        tailPosition: 0.70,
                      ),
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.1,
                          ),
                          blurRadius: 8.r,
                          offset: Offset(0, 4.r),
                        ),
                      ],
                    )
                        : ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: const Color(0xFFF3F3F3),
                        ),
                        borderRadius: BorderRadius.circular(
                          12.r,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomImageHandler(
                          '',
                          // '${AppEndpoints.baseUrl}${controller.bookingPorts[index].iconePath ?? ''}',
                          fit: BoxFit.fill,
                          height: 40.r,
                          width: 40.r,
                        ),
                        Text(
                          "nameAr",
                          // controller.bookingPorts[index].nameAr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF2C262C),
                            fontSize: 14.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return 10.horizontalSpace;
            },
          ),
        ),
        BookingServicesType(),
      ],
    );
  }
}
