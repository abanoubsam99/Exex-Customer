import 'dart:math' as math;

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class MyExpandable extends StatelessWidget {
  const MyExpandable({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ScrollOnExpand(
          child: Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColors.boarderColor, width: 1.dm),
              borderRadius: BorderRadius.circular(16.dm),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ExpandablePanel(
                  theme: ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToExpand: true,
                    tapBodyToCollapse: true,
                    hasIcon: false,
                  ),
                  header: Container(
                    color: AppColors.blacksoft.withValues(alpha: 0.04),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "الحجوزات المؤكدة",
                            style: TextStyle(
                              color: AppColors.blacksoft,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                          4.horizontalSpace,
                          Container(
                            height: 16.dm,
                            width: 16.dm,
                            decoration: BoxDecoration(
                              color: AppColors.dividerGrey,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(4.dm),
                            ),

                            alignment: Alignment.center,
                            child: Text(
                              '2',
                              style: TextStyle(
                                color: AppColors.blacksoft,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: 24.dm,
                            height: 24.dm,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: ExpandableIcon(
                              theme: ExpandableThemeData(
                                iconPadding: EdgeInsets.zero,
                                expandIcon: Icons.keyboard_arrow_left,
                                collapseIcon: Icons.keyboard_arrow_left,
                                iconColor: Colors.black,
                                iconSize: 24.dm,
                                iconRotationAngle: -math.pi / 2,
                                // iconPadding: EdgeInsets.only(right: 5),
                                hasIcon: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  collapsed: SizedBox(),
                  expanded: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(color: AppColors.boarderColor, thickness: 1.dm);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "محمد على",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.sp,
                                      ),
                                    ),
                                    4.horizontalSpace,
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.lightPeach,
                                        borderRadius: BorderRadius.circular(
                                          500.dm,
                                        ),
                                      ),
                                      child: Text(
                                        'Besho Bassem',
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '10:30 -  19 اكتوبر 2024',
                                      style: TextStyle(
                                        color: Color.fromRGBO(111, 118, 126, 1),
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Container(
                                      width: 3.dm,
                                      height: 3.dm,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(217, 217, 217, 1),
                                        borderRadius: BorderRadius.all(
                                          Radius.elliptical(3.dm, 3.dm),
                                        ),
                                      ),
                                    ),
                                    4.horizontalSpace,
                                    Text(
                                      'مدينه نصر, القاهره',
                                      style: TextStyle(
                                        color: Color.fromRGBO(111, 118, 126, 1),
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Spacer(),
                            SizedBox(
                              width: 52.dm,
                              height: 20.dm,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: AppColors.black,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: AppColors.blacksoft,
                                      width: 1.dm,
                                    ),
                                    borderRadius: BorderRadius.circular(16.dm),
                                  ),
                                ),
                                child: Text(
                                  'تفاصيل',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
