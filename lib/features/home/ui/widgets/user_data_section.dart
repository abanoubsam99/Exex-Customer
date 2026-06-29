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
import 'package:evex_user/data/cubits/home/home_state.dart';
import 'package:evex_user/data/models/user_model.dart';

import '../../../../data/cubits/home/home_cubit.dart';

class UserDataSection extends StatelessWidget {
  const UserDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (p, c) => p.currentUser != c.currentUser,
      builder: (context, state) {
        // Prefer the freshly-refreshed user from HomeState; fall back to the
        // cached login user so the avatar still shows before the refresh lands.
        final user = state.currentUser ??
            context.read<UserService>().currentUser?.userViewModel;
        return _buildContent(context, user);
      },
    );
  }

  Widget _buildContent(BuildContext context, UserViewModel? user) {
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
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: AppColors.grey9),
                borderRadius: BorderRadius.circular(23.r),
              ),
            ),
            child: CustomImageHandler(
              user?.imageName != null
                  ? '${AppEndpoints.baseUrl}${user!.imageName}'
                  : AppImages.imagesNewLogo2,
              smartFill: false,
              fit: BoxFit.fill,
              width: 46.r,
              height: 46.r,
            ),
          ),
        ),
        8.horizontalSpace,
        Expanded(
          child: Column(
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
                // Never fall back to `userName` here — it's the email.
                (user?.name?.trim().isNotEmpty ?? false)
                    ? user!.name!.trim()
                    : 'عميل',
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
        ),
        // Row(
        //   children: [
        //     // Spacer(),
        //     // const Expanded(child: _HomeSearchField()),
        //     IconButton(
        //       onPressed: () {
        //         if (!AuthGuard.requireLogin(
        //             context)) {
        //           return;
        //         }
        //         NavigationHelper.pushNamed(
        //           Routes.paymentHistoryScreen,
        //         );
        //       },
        //       icon: CustomImageHandler(
        //         AppImages.iconsReceipt,
        //         width: 22.r,
        //         height: 22.r,
        //         color: Colors.black,
        //       ),
        //     ),
        //     IconButton(
        //       onPressed: () {
        //         if (!AuthGuard.requireLogin(
        //             context)) {
        //           return;
        //         }
        //         // Opening the screen marks all as
        //         // read, so clear the badge now.
        //         context
        //             .read<HomeCubit>()
        //             .clearUnreadNotifications();
        //         NavigationHelper.pushNamed(
        //           Routes.notificationsScreen,
        //         );
        //       },
        //       icon: BlocBuilder<HomeCubit,
        //           HomeState>(
        //         buildWhen: (p, c) =>
        //         p.unreadNotifications !=
        //             c.unreadNotifications,
        //         builder: (context, state) =>
        //             _NotificationBell(
        //               count: state.unreadNotifications,
        //             ),
        //       ),
        //     ),
        //
        //   ],
        // ),

      ],
    );
  }
}
//
// /// The bell icon with a red unread-count badge on top (hidden when [count] 0).
// class _NotificationBell extends StatelessWidget {
//   final int count;
//   const _NotificationBell({required this.count});
//
//   @override
//   Widget build(BuildContext context) {
//     final bell = CustomImageHandler(
//       AppImages.iconsNotification,
//       width: 22.r,
//       height: 22.r,
//     );
//     if (count <= 0) return bell;
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         bell,
//         Positioned(
//           top: -6.r,
//           right: -6.r,
//           child: Container(
//             constraints: BoxConstraints(minWidth: 16.r, minHeight: 16.r),
//             padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: AppColors.primaryColor,
//               borderRadius: BorderRadius.circular(8.r),
//             ),
//             child: Text(
//               count > 99 ? '99+' : '$count',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 9.r,
//                 fontFamily: 'Almarai',
//                 fontWeight: FontWeight.w700,
//                 height: 1,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
