import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/shimmer_skelton.dart';
import 'package:evex_user/core/ui/widgets/speech_bubble_border.dart';
import 'package:evex_user/features/home/logic/home_controller.dart';
import 'package:evex_user/features/home/ui/widgets/booking_services_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InstantBookingServicesSection extends GetView<HomeController> {
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
        Obx(
          () =>
              controller.isLoading.value
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
                      itemCount: controller.bookingPorts.length,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => GestureDetector(
                            onTap: () {
                              controller.selectedBookingPortType.value = null;
                              controller.selectedBookingPort.value =
                                  controller.bookingPorts[index];
                            },
                            child: Center(
                              child: Container(
                                width: 74.w,
                                height: 68.h,
                                decoration:
                                    controller.selectedBookingPort.value?.id ==
                                            controller.bookingPorts[index].id
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
                                      '${AppEndpoints.baseUrl}${controller.bookingPorts[index].iconePath ?? ''}',
                                      fit: BoxFit.fill,
                                      height: 40.r,
                                      width: 40.r,
                                    ),
                                    Text(
                                      controller.bookingPorts[index].nameAr,
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
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return 10.horizontalSpace;
                      },
                    ),
                  ),
        ),
        BookingServicesType(),
      ],
    );
  }
}
