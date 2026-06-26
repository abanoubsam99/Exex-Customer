import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/helpers/app_validation_functions.dart';
import 'package:evex_user/core/localization/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/theme/app_text_styles.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_dropdown_form_field.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:evex_user/data/cubits/profile/profile_cubit.dart';
import 'package:evex_user/data/cubits/profile/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return Scaffold(
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) => Container(
          height: 1.sh,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.4],
              colors: [AppColors.peachBg1, Colors.white],
            ),
          ),
          child: SafeArea(
            // Show a loader only when there is nothing to display yet
            // (no cached data and the first fetch is still running).
            child: state.isLoading && state.profile == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: const CustomBackButtonWidget(),
                    ),
                    8.verticalSpace,
                    Text(
                      'تعديل البيانات الشخصية',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font18BlackExtraBoldHeader,
                    ),
                    6.verticalSpace,
                    Text(
                      'يمكنك تغيير البيانات في أى وقت',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font12greyRegular,
                    ),
                    16.verticalSpace,
                    Form(
                      key: cubit.editProfileFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── الاسم الثلاثى ──
                          TextFieldBuilder(
                            radius: 16,
                            title: 'الاسم الثلاثى',
                            hintText: 'الاسم الثلاثى',
                            controller: cubit.nameController,
                            validator: (p0) {
                              return AppValidationFunctions.fullNameValidation(
                                p0,
                                ' اسم العميل',
                              );
                            },
                            fillColor: AppColors.buttonSecondaryColor,
                          ),
                          16.verticalSpace,
                          // ── البريد الالكتروني (للعرض فقط) ──
                          TextFieldBuilder(
                            radius: 16,
                            title: 'البريد الالكتروني',
                            hintText: 'البريد الالكتروني',
                            readOnly: true,
                            controller: cubit.emailController,
                            validator: (_) => null,
                            fillColor: AppColors.buttonSecondaryColor,
                          ),
                          16.verticalSpace,
                          // ── العنوان ──
                          TextFieldBuilder(
                            radius: 16,
                            title: 'العنوان',
                            hintText: 'اكتب العنوان',
                            controller: cubit.addressController,
                            validator: (_) => null,
                            fillColor: AppColors.buttonSecondaryColor,
                          ),
                          16.verticalSpace,
                          // ── المحافظة / المدينة ──
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomDropDownFormField(
                                  title: AppStrings.governnorate.tr(),
                                  hintText: 'المحافظة',
                                  icon: CustomImageHandler(
                                    AppImages.iconsArrowDown,
                                    width: 16,
                                  ),
                                  items: state.governorates
                                      .map(
                                        (g) => DropdownMenuItem(
                                          value: g.governorateNameAr ?? '',
                                          alignment: Alignment.center,
                                          child: Text(g.governorateNameAr ?? ''),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) =>
                                      cubit.selectGovernorate(value),
                                  value: state.selectedGovernorate,
                                  validator: (value) =>
                                      value == null ? 'يرجي اختيار محافظة' : null,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: CustomDropDownFormField(
                                  title: AppStrings.city.tr(),
                                  hintText: 'المدينة',
                                  icon: CustomImageHandler(
                                    AppImages.iconsArrowDown,
                                    width: 16,
                                  ),
                                  items: state.cities
                                      .map(
                                        (c) => DropdownMenuItem(
                                          value: c.cityNameAr ?? '',
                                          alignment: Alignment.center,
                                          child: Text(c.cityNameAr ?? ''),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (city) => cubit.selectCity(city),
                                  value: state.selectedCity,
                                  validator: (value) =>
                                      value == null ? 'يرجي اختيار مدينة' : null,
                                ),
                              ),
                            ],
                          ),
                          16.verticalSpace,
                          // ── النوع / تاريخ الميلاد ──
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomDropDownFormField(
                                  title: 'النوع',
                                  hintText: 'حدد النوع',
                                  icon: CustomImageHandler(
                                    AppImages.iconsArrowDown,
                                    width: 16,
                                  ),
                                  items: ProfileCubit.genderOptions
                                      .map(
                                        (g) => DropdownMenuItem(
                                          value: g,
                                          alignment: Alignment.center,
                                          child: Text(g),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) =>
                                      cubit.selectGender(value as String?),
                                  value: state.selectedGender,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: TextFieldBuilder(
                                  radius: 16,
                                  title: 'تاريخ الميلاد',
                                  hintText: 'حدد التاريخ',
                                  isDatePicker: true,
                                  readOnly: true,
                                  controller: cubit.dateOfBirthController,
                                  validator: (_) => null,
                                  fillColor: AppColors.buttonSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    40.verticalSpace,
                    CustomButton(
                      text: 'حفظ التغييرات',
                      isLoading: state.isLoading,
                      onTap: () {
                        if (cubit.editProfileFormKey.currentState!.validate()) {
                          cubit.updateClient();
                        }
                      },
                    ),
                    16.verticalSpace,
                    CustomButton(
                      bordereColor: AppColors.blacksoft,
                      backgroundColor: Colors.white,
                      fontColor: AppColors.blacksoft,
                      text: 'الغاء',
                      onTap: () => NavigationHelper.pop(),
                    ),
                    24.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
