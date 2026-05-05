import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/constants/MyColors.dart';

class BookingServicesType extends StatelessWidget {
  const BookingServicesType({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount:5,
        itemBuilder: (context, index) {
          return Center(
            child: GestureDetector(
              onTap: () {
                // controller.selectedBookingPortType.value =
                // controller
                //     .selectedBookingPort
                //     .value
                //     ?.portTypeDtos[index];
                //
                // Get.toNamed(Routes.instantBookingServicesScreen);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 4.h,
                  horizontal: 18.w,
                ),
                decoration: ShapeDecoration(
                  color:Colors.white,
                  // color:
                  // controller
                  //     .selectedBookingPortType
                  //     .value
                  //     ?.id ==
                  //     controller
                  //         .selectedBookingPort
                  //         .value
                  //         ?.portTypeDtos[index]
                  //         .id
                  //     ? AppColors.blacksoft
                  //     : Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.5,
                      color: const Color(0xFF2C262C),
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                 "nameAr",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blacksoft,
                    // color:
                    // controller
                    //     .selectedBookingPortType
                    //     .value
                    //     ?.id ==
                    //     controller
                    //         .selectedBookingPort
                    //         .value
                    //         ?.portTypeDtos[index]
                    //         .id
                    //     ? Colors.white
                    //     : AppColors.blacksoft,
                    fontSize: 13.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => 10.horizontalSpace,
      ),
    );
  }
}
