
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/constants/app_images.dart';
import '../../../app/widgets/custom_back_button.dart';
import '../../../app/widgets/custom_image_handler.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomBackButtonWidget(
                    onTap: () {
                      // Get.find<MainController>().goToTab(0);
                    },
                  ),
                  12.horizontalSpace,
                  Text(
                    'محفظة evex',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFF121212),
                      fontSize: 18.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.24,
                    ),
                  ),
                ],
              ),
              24.verticalSpace,
              Container(
                width: 1.sw,
                height: 133.h,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF9670F7).withValues(alpha: 0.7),
                      const Color(0xFF584191).withValues(alpha: 0.7),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 14.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'عروض محفظة evex',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w800,
                                height: 1.33,
                                letterSpacing: -0.24,
                              ),
                            ),
                            12.verticalSpace,
                            Text(
                              'دلوقتي تقدر تستفيد من قيمة نقاطك لما تدفع كاش لأى منتج أو خدمة من خدمات الدفع المباشر',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.67,
                                letterSpacing: -0.24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16.w,
                        top: 13.h,
                        bottom: 8.h,
                      ),
                      child: CustomImageHandler(
                        AppImages.imagesCoin,
                        // height: 112.r,
                        // width: 112.r,
                      ),
                    ),
                  ],
                ),
              ),
              24.verticalSpace,
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
                    'معلومات النقاط',
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
              16.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 155.r,
                    height: 65.r,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF2F4F7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '120',
                                style: TextStyle(
                                  color: const Color(0xFF2CAC61),
                                  fontSize: 18.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.24,
                                ),
                              ),
                              TextSpan(
                                text: ' ',
                                style: TextStyle(
                                  color: const Color(0xFF2CAC61),
                                  fontSize: 18.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.24,
                                ),
                              ),
                              TextSpan(
                                text: 'جنيه',
                                style: TextStyle(
                                  color: const Color(0xFF99A2AC),
                                  fontSize: 14.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          'قيمة النقاط',
                          textAlign: TextAlign.right,
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
                  17.horizontalSpace,
                  Container(
                    width: 155.r,
                    height: 65.r,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF2F4F7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '201',
                                style: TextStyle(
                                  color: const Color(0xFF879DFF),
                                  fontSize: 18.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.24,
                                ),
                              ),
                              TextSpan(
                                text: ' ',
                                style: TextStyle(
                                  color: const Color(0xFF879DFF),
                                  fontSize: 18.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.24,
                                ),
                              ),
                              TextSpan(
                                text: 'جنيه',
                                style: TextStyle(
                                  color: const Color(0xFF99A2AC),
                                  fontSize: 14.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          'الرصيد النقدي',
                          textAlign: TextAlign.right,
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
                ],
              ),
              32.verticalSpace,

              Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: CustomImageHandler(
                        AppImages.iconsInfo,
                        width: 16.r,
                        height: 16.r,
                      ),
                    ),
                    TextSpan(
                      text:
                          '  ينصح بتغيير الرقم السري للمحفظة بشكل دوري لضمان مستوى الأمان',
                      style: TextStyle(
                        color: const Color(0xFF6F767E),
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                        height: 1.69,
                        letterSpacing: -0.24,
                      ),
                    ),
                    TextSpan(
                      text: ' ',
                      style: TextStyle(
                        color: const Color(0xFF4764E8),
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        height: 1.69,
                        letterSpacing: -0.24,
                      ),
                    ),
                    TextSpan(
                      text: 'تغيير كلمة المرور للمحفظة',
                      style: TextStyle(
                        color: const Color(0xFFF38B4A),
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        height: 1.69,
                        letterSpacing: -0.24,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              print('Change password tapped');
                            },
                    ),
                    // WidgetSpan(
                    //   child: TextButton(
                    //     onPressed: () {},
                    //     child: Text(
                    //       'تغيير كلمة المرور للمحفظة',
                    //       style: TextStyle(
                    //         color: const Color(0xFFF38B4A),
                    //         fontSize: 13,
                    //         fontFamily: 'Almarai',
                    //         fontWeight: FontWeight.w700,
                    //         height: 1.69,
                    //         letterSpacing: -0.24,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              16.verticalSpace,
              Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: CustomImageHandler(
                        AppImages.iconsInfo,
                        width: 16.r,
                        height: 16.r,
                      ),
                    ),
                    TextSpan(
                      text:
                          '  يمكنك اسخدام الرصيد النقدي فقط في خدمات الحجز الفوري ويمكنك استخدام قيمة النقاط فقط في خدمات الدفع المباشر',
                      style: TextStyle(
                        color: const Color(0xFF6F767E),
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                        height: 1.69,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
