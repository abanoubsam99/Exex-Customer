import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class OtherServiceCardItem extends StatelessWidget {
  final String title;
  final List<String> images;

  const OtherServiceCardItem({
    super.key,
    required this.title,
    this.images = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 121.w,
      height: 140.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16.r,
            offset: Offset(0, 4.r),
            spreadRadius: -2,
          ),
        ],
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed image area so every card looks identical whether the
            // service has an image or falls back to the placeholder.
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CustomImageHandler(
                    images.isEmpty ? null : ImageUrlHelper.full(images[0]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            3.verticalSpace,
            Text(
              title,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.blacksoft,
                fontSize: 13.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                height: 1.50,
                letterSpacing: -0.24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}