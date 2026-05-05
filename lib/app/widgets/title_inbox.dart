import '../constants/MyColors.dart';
import '../constants/app_images.dart';
import '../constants/app_text_styles.dart';
import 'custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleInBox extends StatelessWidget {
  const TitleInBox({
    super.key,
    required this.title,
    this.extraTitle,
    this.paddingInLeft = 0,
    this.image,
  });

  final String title;
  final String? extraTitle;
  final double paddingInLeft;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12).r,
      decoration: const BoxDecoration(
        color: AppColors.bgGrey2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment:
            image != null
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
        children: [
          if (image != null) Image.asset(image!),
          if (image != null) const SizedBox(width: 6),
          Text(
            title,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16.r,
              color: const Color(0xFF2C262C),
              fontWeight: FontWeight.bold,
            ),
          ),
          if (extraTitle != null)
            Padding(
              padding: EdgeInsets.only(left: paddingInLeft),
              child: Text(
                extraTitle!,
                style: AppTextStyles.font14BrownBold.copyWith(
                  color:
                      paddingInLeft == 0
                          ? AppColors.redtext
                          : const Color(0xff99A2AC),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
