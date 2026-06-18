import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/helpers/auth_guard.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/cubits/main/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/helpers/navigation_helper.dart';
import '../../../core/routing/routes.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Row(
                children: [
                  CustomBackButtonWidget(
                    onTap: () {
                      context.read<MainCubit>().goToTab(0);
                    },
                  ),
                  12.horizontalSpace,
                  Text(
                    'المزيد',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 18.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.24,
                    ),
                  ),
                ],
              ),
              24.verticalSpace,
              buildMoreItem(
                title: 'الصفحة الشخصية',
                image: AppImages.iconsUser,
                onTap: () {
                  if (!AuthGuard.requireLogin(context)) return;
                  NavigationHelper.pushNamed(Routes.profileScreen);
                },
              ),
              Divider(color: AppColors.dividerGrey, thickness: 1.r),
              buildMoreItem(
                title: 'تفضيلاتي',
                image: AppImages.iconsHeart,
                onTap: () {
                  if (!AuthGuard.requireLogin(context)) return;
                  NavigationHelper.pushNamed(Routes.favoritesScreen);
                },
              ),
              Divider(color: AppColors.dividerGrey, thickness: 1.r),
              buildMoreItem(
                title: 'سجل المدفوعات',
                image: AppImages.iconsMoneyTransfer,
                onTap: () {
                  if (!AuthGuard.requireLogin(context)) return;
                  NavigationHelper.pushNamed(Routes.paymentHistoryScreen);
                },
              ),
              Divider(color: AppColors.dividerGrey, thickness: 1.r),
              buildMoreItem(
                title: 'الإشعارات',
                image: AppImages.iconsBell,
                onTap: () {
                  if (!AuthGuard.requireLogin(context)) return;
                  NavigationHelper.pushNamed(Routes.notificationsScreen);
                },
              ),
              Divider(color: AppColors.dividerGrey, thickness: 1.r),
              buildMoreItem(
                title: 'انضم الينا',
                image: AppImages.iconsPuzzle,
                onTap: () {
                  NavigationHelper.pushNamed(Routes.requestToJoinScreen);
                },
              ),
              Divider(color: AppColors.dividerGrey, thickness: 1.r),
              buildMoreItem(
                title: 'إقتراح جديد',
                image: AppImages.iconsThoughtBubble,
                onTap: () {
                  if (!AuthGuard.requireLogin(context)) return;
                  NavigationHelper.pushNamed(Routes.newSuggestionScreen);
                },
              ),
              Divider(color: AppColors.dividerGrey, thickness: 1.r),
              buildMoreItem(
                title: 'اتصل بنا',
                image: AppImages.iconsPhonePlus,
                onTap: () {
                  NavigationHelper.pushNamed(Routes.contactUsScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile buildMoreItem({
    required String title,
    required String image,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: CustomImageHandler(image, width: 22.r, height: 22.r),
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: AppColors.blacksoft,
          fontSize: 16.r,
          fontFamily: 'Almarai',
          fontWeight: FontWeight.w400,
          letterSpacing: -0.24,
        ),
      ),
    );
  }
}
