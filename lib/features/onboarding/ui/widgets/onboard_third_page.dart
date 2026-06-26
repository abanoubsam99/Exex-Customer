import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_dropdown_form_field.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/cubits/onboarding/onboarding_location_cubit.dart';
import 'package:evex_user/data/cubits/onboarding/onboarding_location_state.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

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
          colors: [AppColors.peachOrange.withValues(alpha: 0.5), Colors.white],
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
                      bottom: 135.r,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'خصومات وعروض حصرية !!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.blacksoft,
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
                                color: AppColors.darkGrey,
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                                letterSpacing: -0.24,
                              ),
                            ),
                            20.verticalSpace,
                            const _CityDropdown(),
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

/// The mandatory city dropdown (wired to [OnboardingLocationCubit]). The
/// governorate is chosen on the previous page, so its cities are already loaded
/// by the time this page is reached.
class _CityDropdown extends StatelessWidget {
  const _CityDropdown();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingLocationCubit, OnboardingLocationState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingLocationCubit>();
        return CustomDropDownFormField(
          title: 'اختار مدينتك',
          hintText: state.isLoadingCities ? 'جاري التحميل...' : 'اختر المدينة',
          value: state.selectedCity,
          items: state.cities
              .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(c.cityNameAr ?? ''),
                  ))
              .toList(),
          onChanged: state.selectedGovernorate == null
              ? null
              : (value) {
                  if (value is City) cubit.selectCity(value);
                },
        );
      },
    );
  }
}
