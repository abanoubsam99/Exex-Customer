import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/top_backround.dart';
import 'package:evex_user/features/auth/add_phone/view/widget/add_phone_body.dart';
import 'package:evex_user/features/auth/add_phone/view/widget/add_phone_top_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class AddPhoneScreen extends StatelessWidget {
  const AddPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            TopBackround(height: 390.h),
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: AddPhoneTopPart(),
                    ),
                    24.verticalSpace,
                    Container(
                      width: double.infinity,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.r),
                            topRight: Radius.circular(40.r),
                          ),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 54,
                            offset: Offset(0, -6),
                            spreadRadius: -30,
                          ),
                        ],
                      ),
                      child: const AddPhoneBody(),
                    ),
                  ],
                ),
              ),
            ),
            // Logout icon at the top — lets the user abandon the phone
            // verification step and go back to login. Clears the account
            // session (device onboarding flags are preserved) like the
            // profile logout.
            Positioned(
              top: MediaQuery.of(context).padding.top + 8.h,
              left: 16.w,
              child: InkWell(
                onTap: () async {
                  await context.read<UserService>().logout();
                  NavigationHelper.pushNamedAndRemoveUntil(Routes.loginScreen);
                },
                child: Container(
                  width: 40.r,
                  height: 40.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.salmon2,
                      width: 1.3,
                    ),
                    color: AppColors.pinkBg,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: CustomImageHandler(
                    AppImages.iconsLogout,
                    height: 20.r,
                    width: 20.r,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
