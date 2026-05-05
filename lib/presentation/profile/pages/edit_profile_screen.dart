
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../app/Helper/NavigationHelper.dart';
import '../../../app/constants/MyColors.dart';
import '../../../app/constants/app_images.dart';
import '../../../app/widgets/custom_back_button.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/custom_dropdown_form_field.dart';
import '../../../app/widgets/custom_image_handler.dart';
import '../../../app/widgets/text_field_builder_widget.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // trigger only when this screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // controller.prepareEditProfile();
    });
    return Scaffold(
      body: Container(
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
                  8.verticalSpace,
                  Form(
                    // key: controller.editProfileFormKey,
                    child: Column(
                      children: [
                        TextFieldBuilder(
                          radius: 16,
                          title: 'الاسم الثلاثى',
                          // controller: controller.vendorNameController,
                          // validator: (p0) {
                          //   return AppValidationFunctions.fullNameValidation(
                          //     p0,
                          //     ' اسم الموظف',
                          //   );
                          // },
                          fillColor: AppColors.buttonSecondaryColor,
                        ),
                        16.verticalSpace,
                        TextFieldBuilder(
                          // validator:
                          //     (email) =>
                          //     AppValidationFunctions.emailValidationFunction(
                          //       email,
                          //     ),
                          title: "البريد الالكترونى",
                          // controller: controller.emailController,
                          fillColor: AppColors.buttonSecondaryColor,
                          bgColor: AppColors.buttonSecondaryColor,
                        ),
                        16.verticalSpace,
                        TextFieldBuilder(
                          radius: 16,
                          // controller: controller.addressController,
                          title: 'العنوان',
                          validator: (p0) {
                            return null;
                          },
                          // validator: (p0) {
                          //   return AppValidationFunctions
                          //       .stringValidationFunction(p0, 'العنوان');
                          // },
                          fillColor: AppColors.buttonSecondaryColor,
                        ),
                        16.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              flex: 9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("المحافظة"),
                                  SizedBox(height: 6.h),
                                  CustomDropDownFormField(
                                    hintText: 'المحافظة',
                                    icon: CustomImageHandler(
                                      AppImages.iconsArrowDown,
                                      width: 16,
                                    ),
                                    // items:
                                    // controller.governates.value
                                    //     .map(
                                    //       (g) => DropdownMenuItem(
                                    //     value: g.governorateNameAr,
                                    //     alignment: Alignment.center,
                                    //     child: Text(
                                    //       g.governorateNameAr ?? "",
                                    //     ),
                                    //   ),
                                    // )
                                    //     .toList(),
                                    onChanged: (value) {
                                      // controller.selectedGovernateName.value =
                                      //     value;
                                      // controller.selectedCity.value = null;
                                      // controller.getCities(value);
                                    },
                                    // value: controller.selectedGovernateName.value,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'يرجي اختيار محافظة';
                                      }
                                      return null;
                                    }, items: [],
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
                                  Text("المدينة"),
                                  SizedBox(height: 6.h),
                                  CustomDropDownFormField(
                                    // size: 30,
                                    icon: CustomImageHandler(
                                      AppImages.iconsArrowDown,
                                      width: 16,
                                    ),
                                    hintText: 'المدينة',
                                    // items:
                                    // controller.cities.value
                                    //     .map(
                                    //       (g) => DropdownMenuItem(
                                    //     value: g.cityNameAr,
                                    //     alignment: Alignment.center,
                                    //     child: Text(
                                    //       g.cityNameAr ?? "",
                                    //     ),
                                    //   ),
                                    // )
                                    //     .toList(),
                                    onChanged: (city) {
                                      // controller.selectedCity.value = city;
                                    },
                                    // value: controller.selectedCity.value,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'يرجي اختيار مدينة';
                                      }
                                      return null;
                                    }, items: [],
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
                      // if (controller.editProfileFormKey.currentState!
                      //     .validate()) {
                      //   // controller.updateProfile();
                      // }
                    },
                  ),
                  const SizedBox(height: 18),
                  CustomButton(
                    bordereColor: const Color(0xff2C262C),
                    backgroundColor: Colors.white,
                    fontColor: const Color(0xff2C262C),
                    text: 'الغاء',
                    onTap: () {
                      NavigationHelper.pop(context);

                    },
                  ),
                ],
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

