import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/helpers/app_validation_functions.dart';
import 'package:evex_user/core/localization/app_strings.dart';
import 'package:evex_user/core/localization/app_localizations.dart';
import 'package:evex_user/core/theme/app_colors.dart';
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
              colors: [Color(0xFFFEF3ED), Colors.white],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomBackButtonWidget(),
                    Center(
                      child: GestureDetector(
                        onTap: () => cubit.pickImage(),
                        child: Container(
                          height: 100.r,
                          width: 100.r,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const ClipOval(
                            child: CustomImageHandler(
                              'assets/images/new_logo.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                    8.verticalSpace,
                    Form(
                      key: cubit.editProfileFormKey,
                      child: Column(
                        children: [
                          TextFieldBuilder(
                            radius: 16,
                            title: 'الاسم الثلاثى',
                            controller: cubit.nameController,
                            validator: (p0) {
                              return AppValidationFunctions.fullNameValidation(
                                p0,
                                ' اسم الموظف',
                              );
                            },
                            fillColor: AppColors.buttonSecondaryColor,
                          ),
                          16.verticalSpace,
                          Row(
                            children: [
                              Expanded(
                                flex: 9,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(AppStrings.governnorate.tr),
                                    SizedBox(height: 6.h),
                                    CustomDropDownFormField(
                                      hintText: 'المحافظة',
                                      icon: CustomImageHandler(
                                        AppImages.iconsArrowDown,
                                        width: 16,
                                      ),
                                      items: state.governorates
                                          .map(
                                            (g) => DropdownMenuItem(
                                              value: g.governorateNameAr,
                                              alignment: Alignment.center,
                                              child: Text(
                                                g.governorateNameAr ?? '',
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        cubit.selectGovernorate(value);
                                      },
                                      value: state.selectedGovernorate,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'يرجي اختيار محافظة';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 11,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(AppStrings.city.tr),
                                    SizedBox(height: 6.h),
                                    CustomDropDownFormField(
                                      icon: CustomImageHandler(
                                        AppImages.iconsArrowDown,
                                        width: 16,
                                      ),
                                      hintText: 'المدينة',
                                      items: state.cities
                                          .map(
                                            (g) => DropdownMenuItem(
                                              value: g.cityNameAr,
                                              alignment: Alignment.center,
                                              child: Text(g.cityNameAr ?? ''),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (city) {
                                        cubit.selectCity(city);
                                      },
                                      value: state.selectedCity,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'يرجي اختيار مدينة';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    72.verticalSpace,
                    CustomButton(
                      text: 'حفظ التغيرات',
                      onTap: () {
                        if (cubit.editProfileFormKey.currentState!.validate()) {
                          cubit.updateClient();
                        }
                      },
                    ),
                    const SizedBox(height: 18),
                    CustomButton(
                      bordereColor: const Color(0xff2C262C),
                      backgroundColor: Colors.white,
                      fontColor: const Color(0xff2C262C),
                      text: 'الغاء',
                      onTap: () => NavigationHelper.pop(),
                    ),
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
