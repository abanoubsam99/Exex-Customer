import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/features/home/logic/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BookingServicesType extends GetView<HomeController> {
  const BookingServicesType({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.selectedBookingPort.value != null
              ? SizedBox(
                height: 30.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      controller
                          .selectedBookingPort
                          .value
                          ?.portTypeDtos
                          .length ??
                      0,
                  itemBuilder: (context, index) {
                    return Obx(
                      () => Center(
                        child: GestureDetector(
                          onTap: () {
                            controller.selectedBookingPortType.value =
                                controller
                                    .selectedBookingPort
                                    .value
                                    ?.portTypeDtos[index];

                            Get.toNamed(Routes.instantBookingServicesScreen);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 4.h,
                              horizontal: 18.w,
                            ),
                            decoration: ShapeDecoration(
                              color:
                                  controller
                                              .selectedBookingPortType
                                              .value
                                              ?.id ==
                                          controller
                                              .selectedBookingPort
                                              .value
                                              ?.portTypeDtos[index]
                                              .id
                                      ? AppColors.blacksoft
                                      : Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1.5,
                                  color: const Color(0xFF2C262C),
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            child: Text(
                              controller
                                      .selectedBookingPort
                                      .value
                                      ?.portTypeDtos[index]
                                      .nameAr ??
                                  '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                // color: const Color(0xFF2C262C),
                                color:
                                    controller
                                                .selectedBookingPortType
                                                .value
                                                ?.id ==
                                            controller
                                                .selectedBookingPort
                                                .value
                                                ?.portTypeDtos[index]
                                                .id
                                        ? Colors.white
                                        : AppColors.blacksoft,
                                fontSize: 13.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => 10.horizontalSpace,
                ),
              )
              : SizedBox.shrink(),
    );
  }
}
