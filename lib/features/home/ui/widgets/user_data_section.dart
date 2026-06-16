import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
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
            child: CustomImageHandler(
              user?.imageName != null
                  ? '${AppEndpoints.baseUrl}${user!.imageName}'
                  : AppImages.imagesNewLogo2,
              fit: BoxFit.cover,
              width: 40.r,
              height: 40.r,
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
                color: const Color(0xFF6F767E),
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
                color: const Color(0xFF2C262C),
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
