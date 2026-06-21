import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_dropdown_form_field.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/cubits/onboarding/onboarding_location_cubit.dart';
import 'package:evex_user/data/cubits/onboarding/onboarding_location_state.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class OnboardSecondPage extends StatefulWidget {
  const OnboardSecondPage({super.key});

  @override
  State<OnboardSecondPage> createState() => _OnboardSecondPageState();
}

class _OnboardSecondPageState extends State<OnboardSecondPage> with AutomaticKeepAliveClientMixin {
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
                            AppImages.iconsOnboardItem2Background,
                            fit: BoxFit.contain,
                            width: 345.r,
                            height: 355.r,
                          ),
                          CustomImageHandler(
                            AppImages.iconsOnboardItem2Image,
                            fit: BoxFit.contain,
                            width: 174.r,
                            height: 200.r,
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
                              'أكتر من 30 نوع خدمة !!',
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
                              'مش محتاج تنزل وتدور\nكل اللي انت محتاجه وأكتر في مكان واحد',
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
                            28.verticalSpace,
                            const _GovernorateDropdown(),
                          ],
                        ),
                      ),
                    ),
                    CustomImageHandler(
                      AppImages.imagesOnboardItem2Top,
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

/// The mandatory governorate dropdown (wired to [OnboardingLocationCubit]).
/// Picking a governorate loads its cities for the next page.
class _GovernorateDropdown extends StatelessWidget {
  const _GovernorateDropdown();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingLocationCubit, OnboardingLocationState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingLocationCubit>();
        return CustomDropDownFormField(
          title: 'اختار محافظتك',
          hintText:
              state.isLoadingGovernorates ? 'جاري التحميل...' : 'اختر المحافظة',
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
        );
      },
    );
  }
}
