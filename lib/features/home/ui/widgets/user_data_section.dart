import 'package:evex_user/core/models/user_model.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/routing/routes.dart';

class UserDataSection extends GetView<UserService> {
  const UserDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      UserViewModel? user = controller.currentUser.value?.userViewModel;
      return Row(
        children: [
          InkWell(
            onTap: () {
              // UserService().logout();
              // Get.offAllNamed(Routes.loginScreen);
              Get.toNamed(Routes.profileScreen);
            },
            child: Container(
              width: 40.r,
              height: 40.r,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: const Color(0xFFC5BFC3)),
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ),
          2.horizontalSpace,
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'أهلاً بيك !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF6F767E),
                  fontSize: 13.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.24,
                ),
              ),
              Text(
                user?.userName ?? 'زائر',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFF2C262C),
                  fontSize: 18.r,
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
