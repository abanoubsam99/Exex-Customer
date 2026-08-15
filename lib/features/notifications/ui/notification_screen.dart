import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/theme/app_text_styles.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/empty_list_widget.dart';
import 'package:evex_user/core/ui/widgets/load_more_listener.dart';
import 'package:evex_user/data/cubits/notifications/notifications_cubit.dart';
import 'package:evex_user/data/cubits/notifications/notifications_state.dart';
import 'package:evex_user/data/models/app_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 8.h),
              child: Row(
                children: [
                  const CustomBackButtonWidget(),
                  12.horizontalSpace,
                  Text('الاشعارات',
                      style: AppTextStyles.font18BlackExtraBoldHeader),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.orangeColor,
                      ),
                    );
                  }
                  final recent = state.recent;
                  final others = state.others;
                  if (recent.isEmpty && others.isEmpty) {
                    return const EmptyListWidget(
                      message: 'لا توجد اشعارات',
                      icon: Icons.notifications_none,
                    );
                  }
                  return LoadMoreListener(
                    onLoadMore: () =>
                        context.read<NotificationsCubit>().loadMore(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      children: [
                        if (recent.isNotEmpty) ...[
                          // _sectionLabel('مؤخراً'),
                          for (int i = 0; i < recent.length; i++) ...[
                            _NotificationTile(
                                item: recent[i], highlighted: true),
                            if (i != recent.length - 1) 4.verticalSpace,
                          ],
                        ],
                        if (others.isNotEmpty) ...[
                          16.verticalSpace,
                          // _sectionLabel('اخري'),
                          for (int i = 0; i < others.length; i++) ...[
                            _NotificationTile(item: others[i]),
                            if (i != others.length - 1)
                              Divider(
                                  color: AppColors.fillGrey1, height: 1.h),
                          ],
                        ],
                        if (state.isLoadingMore) const PaginationLoader(),
                        24.verticalSpace,
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 14.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}

class _NotificationTile extends StatelessWidget {
  final AppNotification item;
  final bool highlighted;
  const _NotificationTile({required this.item, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: highlighted ? AppColors.bgGrey2 : Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: highlighted ? 8.w : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(.1), shape: BoxShape.circle),
            child: Icon(Icons.notifications_active,
                size: 18.r, color: AppColors.primaryColor),
          ),
          // _StatusIcon(type: item.type),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 14.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    8.horizontalSpace,
                    Text(
                      item.time,
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 11.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                4.verticalSpace,
                Text(
                  // Wraps over as many lines as the message needs — a one-line
                  // clamp cut every body off mid-sentence with an ellipsis.
                  item.body,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.font12greyRegular,
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final NotificationType type;
  const _StatusIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Widget icon;
    switch (type) {
      case NotificationType.confirmed:
        bg = AppColors.greenBg1;
        icon = Icon(Icons.check_rounded,
            size: 20.r, color: AppColors.green7);
        break;
      case NotificationType.canceled:
        bg = AppColors.redBg;
        icon =
            Icon(Icons.close_rounded, size: 20.r, color: AppColors.red4);
        break;
      case NotificationType.trash:
        bg = AppColors.yellowBg;
        icon = Icon(Icons.delete_outline_rounded,
            size: 20.r, color: AppColors.yellowColor);
        break;
      case NotificationType.team:
        bg = AppColors.lavenderBg;
        icon = CustomImageHandler(
          AppImages.iconsProfile2user,
          width: 20.r,
          height: 20.r,
          color: AppColors.purple2,
        );
        break;
      case NotificationType.offer:
        bg = AppColors.blueBg2;
        icon = Icon(Icons.local_offer_outlined,
            size: 18.r, color: AppColors.blue1);
        break;
    }
    return Container(
      width: 40.r,
      height: 40.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: icon,
    );
  }
}
