
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class UserDataSection  extends StatelessWidget {
  const UserDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            // UserService().logout();
            // Get.offAllNamed(Routes.loginScreen);
            // Get.toNamed(Routes.profileScreen);
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
               'زائر',
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
  }
}
