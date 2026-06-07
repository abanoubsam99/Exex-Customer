import 'dart:math' as math;

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyExpandableMin extends StatelessWidget {
  const MyExpandableMin({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 8.r),
        child: ScrollOnExpand(
          child: Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Color(0xFFF2F4F7), width: 1.r),
              borderRadius: BorderRadius.circular(16.r),
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
                    color: Color(0xFF2C262C).withValues(alpha: 0.04),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.r,
                        vertical: 8.h,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "الحجوزات المؤكدة",
                            style: TextStyle(
                              color: Color(0xFF2C262C),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.r,
                            ),
                          ),
                          4.horizontalSpaceRadius,
                          Container(
                            height: 18.r,
                            width: 16.r,
                            decoration: BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(4.r),
                            ),

                            alignment: Alignment.center,
                            child: Text(
                              '2',
                              style: TextStyle(
                                color: Color(0xFF2C262C),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.r,
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: 24.r,
                            height: 24.r,
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
                                iconSize: 24.r,
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
                      horizontal: 12.r,
                      vertical: 4.h,
                    ),
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(color: Color(0xFFF2F4F7), thickness: 1.r);
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
                                        fontSize: 17.r,
                                      ),
                                    ),
                                    4.horizontalSpaceRadius,
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.r,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFF1E9),
                                        borderRadius: BorderRadius.circular(
                                          500.r,
                                        ),
                                      ),
                                      child: Text(
                                        'Besho Bassem',
                                        style: TextStyle(
                                          color: Color(0xFFF38B4A),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11.r,
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
                                        fontSize: 11.r,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(width: 4.r),
                                    Container(
                                      width: 3.r,
                                      height: 3.r,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(217, 217, 217, 1),
                                        borderRadius: BorderRadius.all(
                                          Radius.elliptical(3.r, 3.r),
                                        ),
                                      ),
                                    ),
                                    4.horizontalSpaceRadius,
                                    Text(
                                      'مدينه نصر, القاهره',
                                      style: TextStyle(
                                        color: Color.fromRGBO(111, 118, 126, 1),
                                        fontSize: 11.r,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Spacer(),
                            SizedBox(
                              width: 52.r,
                              height: 20.r,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Color(0xFF121212),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Color(0xFF2C262C),
                                      width: 1.r,
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: Text(
                                  'تفاصيل',
                                  style: TextStyle(
                                    fontSize: 11.r,
                                    color: Color(0xFF121212),
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
