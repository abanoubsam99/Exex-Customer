import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/helpers/app_validation_functions.dart';
import 'package:evex_user/core/localization/app_strings.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_dropdown_form_field.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:evex_user/features/profile/logic/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends GetView<ProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Container(
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
                        onTap: () => controller.pickImage(),
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
                      key: controller.editProfileFormKey,
                      child: Column(
                        children: [
                          TextFieldBuilder(
                            radius: 16,
                            title: 'الاسم الثلاثى',
                            controller: controller.nameController,
                            validator: (p0) {
                              return AppValidationFunctions.fullNameValidation(
                                p0,
                                ' اسم الموظف',
                              );
                            },
                            fillColor: AppColors.buttonSecondaryColor,
                          ),
                          // 16.verticalSpace,
                          // TextFieldBuilder(
                          //   validator:
                          //       (email) =>
                          //           AppValidationFunctions.emailValidationFunction(
                          //             email,
                          //           ),
                          //   title: "البريد الالكترونى",
                          //   controller: controller.emailController,
                          //   fillColor: AppColors.buttonSecondaryColor,
                          //   bgColor: AppColors.buttonSecondaryColor,
                          // ),
                          // 16.verticalSpace,
                          // TextFieldBuilder(
                          //   radius: 16,
                          //   controller: controller.addressController,
                          //   title: 'العنوان',
                          //   validator: (p0) {
                          //     return null;
                          //   },
                          //   // validator: (p0) {
                          //   //   return AppValidationFunctions
                          //   //       .stringValidationFunction(p0, 'العنوان');
                          //   // },
                          //   fillColor: AppColors.buttonSecondaryColor,
                          // ),
                          16.verticalSpace,
                          Row(
                            children: [
                              Expanded(
                                flex: 9,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppStrings.governnorate.tr),
                                    SizedBox(height: 6.h),
                                    CustomDropDownFormField(
                                      hintText: 'المحافظة',
                                      icon: CustomImageHandler(
                                        AppImages.iconsArrowDown,
                                        width: 16,
                                      ),
                                      items:
                                          controller.governates.value
                                              .map(
                                                (g) => DropdownMenuItem(
                                                  value: g.governorateNameAr,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    g.governorateNameAr ?? "",
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (value) {
                                        controller.selectedGovernate.value =
                                            value;
                                        controller.selectedCity.value = null;
                                        controller.getCities(value);
                                      },
                                      value: controller.selectedGovernate.value,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppStrings.city.tr),
                                    SizedBox(height: 6.h),
                                    CustomDropDownFormField(
                                      // size: 30,
                                      icon: CustomImageHandler(
                                        AppImages.iconsArrowDown,
                                        width: 16,
                                      ),
                                      hintText: 'المدينة',
                                      items:
                                          controller.cities.value
                                              .map(
                                                (g) => DropdownMenuItem(
                                                  value: g.cityNameAr,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    g.cityNameAr ?? "",
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (city) {
                                        controller.selectedCity.value = city;
                                      },
                                      value: controller.selectedCity.value,
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
                        if (controller.editProfileFormKey.currentState!
                            .validate()) {
                          controller.updateClient();
                        }
                      },
                    ),
                    const SizedBox(height: 18),
                    CustomButton(
                      bordereColor: const Color(0xff2C262C),
                      backgroundColor: Colors.white,
                      fontColor: const Color(0xff2C262C),
                      text: 'الغاء',
                      onTap: () {
                        Get.back();
                      },
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

  userRowData(String s, String t, profile) {}

  divider() {}
}
