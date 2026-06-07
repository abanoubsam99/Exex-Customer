import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_dropdown_form_field.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardThirdPage extends StatefulWidget {
  const OnboardThirdPage({super.key});

  @override
  State<OnboardThirdPage> createState() => _OnboardThirdPageState();
}

class _OnboardThirdPageState extends State<OnboardThirdPage>
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
                          CustomImageHandler(
                            AppImages.iconsOnboardItem3Background,
                            fit: BoxFit.contain,
                            width: 345.r,
                            height: 355.r,
                          ),
                          Positioned(
                            bottom: 45.r,
                            child: CustomImageHandler(
                              AppImages.iconsOnboardItem3Image,
                              fit: BoxFit.contain,
                              width: 215.r,
                              height: 202.r,
                            ),
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
                              'خصومات وعروض حصرية !!',
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
                              'استفيد بخصومات على كل حجوزاتك\nوبدون وسيط أو عمولات ',
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
                            CustomDropDownFormField(
                              title: 'اختار مدينتك',
                              hintText: 'اختار مدينتك',
                              items: [
                                const DropdownMenuItem(
                                  value: 'القاهرة',
                                  child: Text('القاهرة'),
                                ),
                                const DropdownMenuItem(
                                  value: 'الجيزة',
                                  child: Text('الجيزة'),
                                ),
                              ],
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomImageHandler(
                      AppImages.imagesOnboardItem3Top,
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
