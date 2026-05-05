import 'package:evexcustomer/app/constants/app_endpoints.dart';
import 'package:evexcustomer/presentation/home/widgets/payment_services_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/widgets/custom_image_handler.dart';
import '../../../app/widgets/speech_bubble_border.dart';


class InstantPaymentServices extends StatelessWidget {
  const InstantPaymentServices({super.key});

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
              'خدمات الدفع المباشر',
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
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // controller.selectedPaymentPortType.value = null;
                  // controller.selectedPaymentPort.value =
                  // controller.paymentPorts[index];
                },
                child: Center(
                  child: Container(
                    width: 74.w,
                    height: 68.h,
                    decoration:false ==true
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
                          color: Colors.black.withOpacity(
                            0.1,
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
                          // '${AppEndpoints.baseUrl}${controller.paymentPorts[index].iconePath ?? ''}',
                          fit: BoxFit.fill,
                          height: 40.r,
                          width: 40.r,
                        ),
                        Text(
                          "nameAr",
                          // controller.paymentPorts[index].nameAr,
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
        PaymentServicesType(),
      ],
    );
  }
}
