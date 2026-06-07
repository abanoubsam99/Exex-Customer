import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/country_picker.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardFirstPage extends StatefulWidget {
  const OnboardFirstPage({super.key});

  @override
  State<OnboardFirstPage> createState() => _OnboardFirstPageState();
}

class _OnboardFirstPageState extends State<OnboardFirstPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(1.5, -1),
          end: Alignment(-1, 0.2),
          colors: [Color(0xffF9C5A4).withValues(alpha: 0.5), Colors.white],
        ),
      ),
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 1.sh,
                child: Stack(
                  children: [
                    Positioned(
                      top: 174.r,
                      left: 0,
                      right: 0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // CustomImageHandler(
                          //   AppImages.iconsOnboardItem2Background,
                          //   fit: BoxFit.contain,
                          //   width: 345.r,
                          //   height: 355.r,
                          // ),
                          SizedBox(width: 345.r, height: 355.r),
                          CustomImageHandler(
                            AppImages.iconsOnboardItem1Image,
                            fit: BoxFit.contain,
                            width: 210.r,
                            height: 210.r,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 505.r,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Column(
                          children: [
                            Text(
                              'عندك مناسبة ؟!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF2C262C),
                                fontSize: 22.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.24,
                              ),
                            ),
                            4.verticalSpace,
                            Text(
                              'ماتشيلش هم .. كل اللي عليك تحدد اليوم والمكان\nوفوراً هنعرضلك كل الخدمات المتاحه للحجز في الميعاد دا',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF5E5E5E),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                                letterSpacing: -0.24,
                              ),
                            ),
                            28.verticalSpace,
                            CountryPicker(
                              title: 'اختار دولتك',
                              value: customCountries.first,
                              items: [
                                ...customCountries.map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 30.r,
                                          height: 30.r,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                'assets/flags/${e.code.toLowerCase()}.png',
                                                package:
                                                    'flutter_intl_phone_field',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Container(
                                          width: 1,
                                          height: 30.h,
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 0.5,
                                                strokeAlign:
                                                    BorderSide
                                                        .strokeAlignCenter,
                                                color: const Color(0xFF99A2AC),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8.w),

                                        Text(
                                          e.nameTranslations['ar'] ?? e.name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
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
                              ],
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomImageHandler(
                      AppImages.imagesOnboardItem1Top,
                      fit: BoxFit.fill,
                      alignment: Alignment.bottomCenter,
                      width: 1.sw,
                      // height: 221.h,
                      height: 0.28.sh,
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
