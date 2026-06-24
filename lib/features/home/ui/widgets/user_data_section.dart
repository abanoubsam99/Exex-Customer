import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/ui/helpers/auth_guard.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class UserDataSection extends StatelessWidget {
  const UserDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserService>().currentUser?.userViewModel;
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (!AuthGuard.requireLogin(context)) return;
            NavigationHelper.pushNamed(Routes.profileScreen);
          },
          child: Container(
            width: 46.r,
            height: 46.r,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: AppColors.grey9),
                borderRadius: BorderRadius.circular(23.r),
              ),
            ),
            child: CustomImageHandler(
              user?.imageName != null
                  ? '${AppEndpoints.baseUrl}${user!.imageName}'
                  : AppImages.imagesNewLogo2,
              smartFill: true,
              width: 46.r,
              height: 46.r,
            ),
          ),
        ),
        8.horizontalSpace,
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أهلاً بيك !',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 12.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w400,
                letterSpacing: -0.24,
              ),
            ),
            Text(
              user?.name ??  user?.userName ??'عميل',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.blacksoft,
                fontSize: 16.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                height: 1.50,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
