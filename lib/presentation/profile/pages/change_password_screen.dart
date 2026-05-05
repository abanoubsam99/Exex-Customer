// import 'package:evex/components/custom_back_button.dart';
// import 'package:evex/components/custom_button.dart';
// import 'package:evex/core/utils/app_colors.dart';
// import 'package:evex/core/utils/app_validation_functions.dart';
// import 'package:evex/feature/auth_feature/widgets/text_field_builder_widget.dart';
// import 'package:evex/feature/profile/logic/controller/profile_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:evexcustomer/app/compat/getx_compat.dart';

// class ChangePasswordScreen  extends StatelessWidget  {
//   const ChangePasswordScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: 1.sh,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             stops: [0.0, 0.4],
//             colors: [
//               Color(0xFFFEF3ED),
//               Colors.white,
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: LayoutBuilder(builder: (context, constraints) {
//             return SingleChildScrollView(
//               reverse: true,
//               padding: EdgeInsets.symmetric(horizontal: 24.w),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   minHeight: constraints.maxHeight,
//                 ),
//                 child: IntrinsicHeight(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const CustomBackButtonWidget(),
//                       16.verticalSpace,
//                       Text(
//                         "تغيير كلمه المرور",
//                         style: TextStyle(
//                             fontSize: 20.r,
//                             color: const Color(0xFF121212),
//                             fontWeight: FontWeight.w800),
//                       ),
//                       1.verticalSpace,
//                       Text(
//                         "يمكنك تغير كلمه المرور فى اى وقت واعاده التسجيل",
//                         style: TextStyle(
//                             fontSize: 12.r, color: const Color(0xFF6F767E)),
//                       ),
//                       24.verticalSpace,
//                       Form(
//                         key: controller.changePasswordFormKey,
//                         child: Column(
//                           children: [
//                             TextFieldBuilder(
//                               isPassword: true,
//                               fillColor: AppColors.buttonSecondaryColor,
//                               // validator: (value) => AppValidationFunctions
//                               //     .passwordValidationFunction(
//                               //   value,
//                               // ),
//                               validator: (value) => null,
//                               controller: controller.currentPasswordController,
//                               // hintText: "",
//                               title: "كلمه المرور الحاليه",
//                               hintText: 'اكتب كلمه المرور الحاليه',
//                               bgColor: AppColors.whiteColor,
//                             ),
//                             16.verticalSpace,
//                             TextFieldBuilder(
//                               isPassword: true,
//                               fillColor: AppColors.buttonSecondaryColor,
//                               // validator: (value) => AppValidationFunctions
//                               //     .passwordValidationFunction(
//                               //   value,
//                               // ),
//                               validator: (value) => null,
//                               controller: controller.newPasswordController,
//                               title: "كلمه المرور الجديده",
//                               hintText: "اكتب كلمه المرور الجديده",
//                               bgColor: AppColors.whiteColor,
//                             ),
//                             16.verticalSpace,
//                             TextFieldBuilder(
//                               isPassword: true,
//                               fillColor: AppColors.buttonSecondaryColor,
//                               validator: (Value) =>
//                                   Value == controller.newPasswordController.text
//                                       ? null
//                                       : 'كلمة المرور غير متطابقة',
//                               controller: controller.confirmPasswordController,
//                               title: "تأكيد كلمة المرور",
//                               hintText: "اكتب كلمه المرور الجديده",
//                               bgColor: AppColors.whiteColor,
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Spacer(),
//                       32.verticalSpace,
//                       CustomButton(
//                         text: 'حفظ كلمه المرور',
//                         onTap: () {
//                           if (controller.changePasswordFormKey.currentState!
//                               .validate()) {
//                             controller.changePassword();
//                           }
//                         },
//                       ),
//                       18.verticalSpace,
//                       CustomButton(
//                         bordereColor: const Color(0xff2C262C),
//                         backgroundColor: Colors.white,
//                         color: const Color(0xff2C262C),
//                         text: 'الغاء',
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }

//   userRowData(String s, String t, profile) {}

//   divider() {}
// }


