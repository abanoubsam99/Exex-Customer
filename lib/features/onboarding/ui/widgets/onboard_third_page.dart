import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_dropdown_form_field.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/cubits/onboarding/onboarding_location_cubit.dart';
import 'package:evex_user/data/cubits/onboarding/onboarding_location_state.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
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
                            const _LocationDropdowns(),
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

/// The mandatory governorate + city dropdowns (wired to [OnboardingLocationCubit]).
/// The city dropdown is disabled until a governorate is picked.
class _LocationDropdowns extends StatelessWidget {
  const _LocationDropdowns();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingLocationCubit, OnboardingLocationState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingLocationCubit>();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDropDownFormField(
              title: 'المحافظة',
              hintText: state.isLoadingGovernorates
                  ? 'جاري التحميل...'
                  : 'اختر المحافظة',
              value: state.selectedGovernorate,
              items: state.governorates
                  .map((g) => DropdownMenuItem(
                        value: g,
                        child: Text(g.governorateNameAr),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value is Governate) cubit.selectGovernorate(value);
              },
            ),
            12.verticalSpace,
            CustomDropDownFormField(
              title: 'المدينة',
              hintText:
                  state.isLoadingCities ? 'جاري التحميل...' : 'اختر المدينة',
              value: state.selectedCity,
              items: state.cities
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.cityNameAr),
                      ))
                  .toList(),
              onChanged: state.selectedGovernorate == null
                  ? null
                  : (value) {
                      if (value is City) cubit.selectCity(value);
                    },
            ),
          ],
        );
      },
    );
  }
}
