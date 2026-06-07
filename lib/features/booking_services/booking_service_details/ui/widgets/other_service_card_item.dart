import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            color: Color(0x19000000),
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
            CustomImageHandler(
              images.isEmpty ? AppImages.imagesWedding2 : images[0],
              fit: BoxFit.fill,
            ),
            3.verticalSpace,
            Text(
              'قاعة اللؤلؤة',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: const Color(0xFF2C262C),
                fontSize: 14.r,
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