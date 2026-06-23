import 'package:flutter/material.dart';

import 'package:evex_user/data/models/review.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class ReviewCardItem extends StatelessWidget {
  final Review review;
  const ReviewCardItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final name = (review.clientName?.trim().isNotEmpty == true)
        ? review.clientName!.trim()
        : 'عميل';
    final initial = name.characters.isNotEmpty ? name.characters.first : 'ع';
    final hasComment = review.comment?.trim().isNotEmpty == true;
    final comment = hasComment ? review.comment!.trim() : 'لا يوجد تعليق';
    return Container(
      width: 280.w,
      height: 115.h,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: AppColors.boarderColor),
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        child: Column( crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: const ShapeDecoration(
                    color: AppColors.primaryAlpha28,
                    shape: OvalBorder(),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 33.r,
                    height: 33.r,
                    decoration: ShapeDecoration(
                      color: Colors.transparent,
                      shape: OvalBorder(
                        side: BorderSide(width: 2.5, color: Colors.white),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initial,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 14.r,
                        fontWeight: FontWeight.w700,
                        height: -0.4,
                      ),
                    ),
                  ),
                ),
                6.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.blacksoft,
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    6.verticalSpace,
                    Text(
                      _formatDate(review.createdAt),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.blueGrey,
                        fontSize: 12.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  margin: EdgeInsets.only(top: 2.h),
                  width: 36.r,
                  height: 19.r,
                  decoration: ShapeDecoration(
                    color: AppColors.green5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.r),
                        topRight: Radius.circular(2.r),
                        bottomLeft: Radius.circular(2.r),
                        bottomRight: Radius.circular(8.r),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.white, size: 14.r),
                      Text(
                        '${review.stars ?? 0}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                      4.horizontalSpace,
                    ],
                  ),
                ),
              ],
            ),
            6.verticalSpace,
            Expanded(
              child: Text(
                comment ,
                textAlign: TextAlign.right,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  // Lighter/italic when it's the "no comment" placeholder.
                  color: hasComment
                      ? AppColors.grey
                      : AppColors.unitGrey,
                  fontSize: 12.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                  fontStyle: hasComment ? FontStyle.normal : FontStyle.italic,
                  height: 1.50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Formats the review date as dd/MM/yyyy. Returns '' for the .NET default
  /// (0001-01-01) or a null date.
  String _formatDate(DateTime? date) {
    if (date == null || date.year < 2000) return '';
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }
}
