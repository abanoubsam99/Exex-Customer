import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserDataSection extends StatelessWidget {
  const UserDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserService>().currentUser?.userViewModel;
    return Row(
      children: [
        InkWell(
          onTap: () {
            NavigationHelper.pushNamed(Routes.profileScreen);
          },
          child: Container(
            width: 40.r,
            height: 40.r,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFFC5BFC3)),
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
  }
}
