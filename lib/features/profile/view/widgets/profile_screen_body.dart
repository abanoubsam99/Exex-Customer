import 'dart:developer';

import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/ui/helpers/custom_loader.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/features/profile/logic/profile_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../../core/ui/widgets/text_field_builder_widget.dart';
import 'revenue_card.dart';

class ProfileScreenBody extends GetView<ProfileController> {
  const ProfileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: RefreshIndicator(
          onRefresh: () async {
            controller.getProfile();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomBackButtonWidget(),
                      InkWell(
                        onTap: () {
                          UserService().logout();
                          Get.offAllNamed(Routes.loginScreen);
                        },
                        child: Container(
                          width: 40.r,
                          height: 40.r,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFFB7272),
                              width: 1.3,
                            ),
                            color: const Color(0xFFFFECEE),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: CustomImageHandler(
                            AppImages.iconsLogout,
                            height: 20.r,
                            width: 20.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => controller.isLoading.value
                        ? const CustomLoader()
                        : Column(
                            children: [
                              Center(
                                child: Container(
                                  height: 100.r,
                                  width: 100.r,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      255,
                                      255,
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: CustomImageHandler(
                                      controller.profile.value?.imageName !=
                                              null
                                          ? '${AppEndpoints.baseUrl}${controller.profile.value?.imageName}'
                                          : AppImages.imagesNewLogo2,
                                    ),
                                  ),
                                ),
                              ),
                              8.verticalSpace,
                              Text(
                                controller.profile.value?.userName ?? '',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w700,
                                  height: 1.50,
                                ),
                              ),
                              Text(
                                '#${controller.profile.value?.userId!.substring(controller.profile.value!.userId!.length - 6)}',
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  color: const Color(0xFF99A2AC),
                                  fontSize: 14.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                              ),
                              12.verticalSpace,
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     RevenueCard(
                              //       isShadow: true,
                              //       title: "تكلفه الاشتراك الشهري",
                              //       amount:
                              //           controller
                              //               .profile
                              //               .value
                              //               ?.planDto
                              //               ?.price
                              //               .toString() ??
                              //           '0',
                              //       currency: ' جنيه',
                              //       backgroundColor: const Color(0xffE3F9FF),
                              //       titleColor: const Color(0xff6F767E),
                              //     ),
                              //     RevenueCard(
                              //       isShadow: true,
                              //       title: "معاد تجديد الاشتراك",
                              //       amount: DateFormat('d/M/yyyy').format(
                              //         controller.profile.value?.renewDate ??
                              //             DateTime.parse(
                              //               '0001-01-01T00:00:00',
                              //             ),
                              //       ),
                              //       backgroundColor: const Color(0xffF8E7FB),
                              //       titleColor: const Color(0xff6F767E),
                              //     ),
                              //     RevenueCard(
                              //       isShadow: true,
                              //       title: "نظام الاشتراك الحالى",
                              //       amount:
                              //           controller
                              //               .profile
                              //               .value
                              //               ?.planDto
                              //               ?.name ??
                              //           'NaN',
                              //       backgroundColor: const Color(0xffFFFDC4),
                              //       titleColor: const Color(0xff6F767E),
                              //     ),
                              //   ],
                              // ),
                              16.verticalSpace,
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 16.h,
                                  horizontal: 12.w,
                                ),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1,
                                      color: Color(0xFFF2F4F7),
                                    ),
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    userRowData(
                                      'الاسم الثلاثى',
                                      controller.profile.value?.userName ?? '',
                                      AppImages.iconsProfile2user,
                                    ),
                                    divider(),
                                    userRowData(
                                      'الهاتف',
                                      controller.profile.value?.phoneNumber ??
                                          'NaN',
                                      AppImages.iconsPhone,
                                    ),
                                    divider(),
                                    userRowData(
                                      'الايميل',
                                      controller.profile.value?.email ?? 'NaN',
                                      AppImages.iconsEmail,
                                    ),
                                    divider(),
                                    userRowData(
                                      'صلاحيات المستخدم',
                                      controller.profile.value?.roles?.join(
                                            '/',
                                          ) ??
                                          'NAN',
                                      AppImages.iconsLock,
                                    ),
                                    divider(),
                                    userRowData(
                                      'العنوان',
                                      '${controller.profile.value?.governorate ?? ''} - ${controller.profile.value?.city ?? ''}',
                                      AppImages.iconsLocation2,
                                    ),
                                  ],
                                ),
                              ),
                              72.verticalSpace,
                              CustomButton(
                                text: 'تعديل البيانات الشخصيه',
                                onTap: () => {Get.toNamed(Routes.editProfile)},
                              ),
                              18.verticalSpace,
                              CustomButton(
                                bordereColor: const Color(0xff2C262C),
                                backgroundColor: Colors.white,
                                fontColor: const Color(0xff2C262C),
                                text: 'تغير كلمه المرور',
                                onTap: () => {
                                  // Get.toNamed(Routes.changePassword)
                                },
                              ),
                              18.verticalSpace,
                              CustomButton(
                                bordereColor: Colors.white,
                                backgroundColor: Colors.white,
                                fontColor: const Color(0xffD42D1C),
                                isfilled: false,
                                text: 'حذف الحساب',
                                onTap: () {
                                  {
                                    Get.dialog(
                                      barrierDismissible: true,
                                      _DeleteAccountDialog(),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      width: double.infinity,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.5,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0xFFEDEDED),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
    );
  }

  Row userRowData(String lable, String value, String icon) {
    return Row(
      children: [
        CustomImageHandler(
          icon,
          color: const Color(0xFFFFC9A9),
          height: 22.r,
          width: 22.r,
        ),
        4.horizontalSpace,
        Text(
          lable,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: const Color(0xFF2C262C),
            fontSize: 14.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w400,
          ),
        ),
        // const Spacer(),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: const Color(0xFF99A2AC),
              fontSize: 14.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog();

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  bool _showEmailField = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  ProfileController get controller => Get.find<ProfileController>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(18.r),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 28.r,
                    height: 28.r,
                    decoration: const ShapeDecoration(
                      color: Color(0xFFF2F4F7),
                      shape: OvalBorder(),
                    ),
                    child: Material(
                      shape: const OvalBorder(),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50.r),
                        onTap: () => Get.back(),
                        child: Center(
                          child: CustomImageHandler(
                            AppImages.iconsClose,
                            width: 16.r,
                            height: 16.r,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                width: 68.r,
                height: 68.r,
                decoration: const ShapeDecoration(
                  shape: OvalBorder(
                    side: BorderSide(
                      width: 4,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0x19FE2B2C),
                    ),
                  ),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFFE2B2C),
                    shape: OvalBorder(),
                  ),
                  child: Center(
                    child: CustomImageHandler(
                      AppImages.iconsTrash,
                      color: Colors.white,
                      width: 20.r,
                      height: 20.r,
                    ),
                  ),
                ),
              ),

              22.verticalSpace,

              // Title
              Text(
                'هل انت متأكد من انك تريد مسح الحساب الخاص بك نهائياً ؟',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF2C262C),
                  fontSize: 16.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w800,
                  height: 1.50,
                ),
              ),
              if (!_showEmailField) ...[
                16.verticalSpace,
                Container(
                  width: 271.r,
                  decoration: ShapeDecoration(
                    color: const Color(0x19FE2B2C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 13, horizontal: 12)
                            .r,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: CustomImageHandler(
                            width: 14.r,
                            height: 14.r,
                            AppImages.iconsInfo2,
                          ),
                        ),
                        8.horizontalSpace,
                        Expanded(
                          child: Text(
                            'سيؤدى مسح الحساب الى مسح جميع الانشطه اللى قمت فيها طوال فتره الحساب ومسح جميع الحجوزات المتاحه والعملاء ولا يمكن نهائياً استرجاع اياً منهما لاحقاً',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: const Color(0xFF6F767E),
                              fontSize: 12.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w400,
                              height: 1.63,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              16.verticalSpace,
              // Email field — shown after pressing the first button
              if (_showEmailField) ...[
                TextFieldBuilder(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'اكتب البريد الإلكتروني',
                  title: 'البريد الإلكتروني',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال البريد الإلكتروني';
                    }
                    if (!value.contains('@')) {
                      return 'بريد إلكتروني غير صالح';
                    }
                    return null;
                  },
                ),
                16.verticalSpace,
              ],

              // First button: show email field / confirm delete
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD92D20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {
                    if (!_showEmailField) {
                      // Step 1: reveal email field
                      setState(() => _showEmailField = true);
                    } else {
                      // Step 2: validate and delete
                      if (_formKey.currentState!.validate()) {
                        // log('Email confirmed: ${_emailController.text}');
                        controller.deleteAccount(_emailController.text);
                      }
                    }
                  },
                  child: Text(
                    _showEmailField ? 'حذف الحساب نهائياً' : 'نعم، احذف حسابي',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.r,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
              ),

              8.verticalSpace,

              // Cancel button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      color: const Color(0xFF2C262C),
                      fontSize: 14.r,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
