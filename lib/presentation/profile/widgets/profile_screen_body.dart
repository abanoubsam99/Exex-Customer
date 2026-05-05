import 'package:evexcustomer/app/constants/app_images.dart';
import 'package:evexcustomer/app/services/user_service.dart';
import 'package:evexcustomer/presentation/profile/logic/profile_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../app/widgets/custom_back_button.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/custom_image_handler.dart';
import 'revenue_card.dart';

class ProfileScreenBody  extends StatelessWidget  {
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
            // controller.getProfile();
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
                       CustomBackButtonWidget(),
                      InkWell(
                        onTap: () {
                          UserService().logout();
                          // Get.offAllNamed(Routes.loginScreen);
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
                  Column(
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
                              'assets/images/new_logo.png',
                            ),
                          ),
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        "userName",
                        // controller.profile.value?.userName ?? '',
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
                        '#65656',
                        // '#${controller.profile.value?.userId!.substring(controller.profile.value!.userId!.length - 6)}',
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
                              'الاسم الثلاثى', '',
                              AppImages.iconsProfile2user,
                            ),
                            divider(),
                            userRowData(
                              'الهاتف', 'NaN',
                              AppImages.iconsPhone,
                            ),
                            divider(),
                            userRowData(
                              'الايميل', 'NaN',
                              AppImages.iconsEmail,
                            ),

                            divider(),
                            userRowData(
                              'صلاحيات المستخدم', 'NAN',
                              AppImages.iconsLock,
                            ),
                            divider(),

                            userRowData(
                              'العنوان',
                              '',
                              AppImages.iconsLocation2,
                            ),
                          ],
                        ),
                      ),
                      72.verticalSpace,
                      CustomButton(
                          text: 'تعديل البيانات الشخصيه',
                          onTap:()=>null
                        // onTap: () => {Get.toNamed(Routes.editProfile)},
                      ),
                      const SizedBox(height: 18),
                      CustomButton(
                        bordereColor: const Color(0xff2C262C),
                        backgroundColor: Colors.white,
                        fontColor: const Color(0xff2C262C),
                        text: 'تغير كلمه المرور',
                        onTap:
                            () => {
                          // Get.toNamed(Routes.changePassword)
                        },
                      ),
                    ],
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
