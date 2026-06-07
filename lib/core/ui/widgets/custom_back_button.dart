import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBackButtonWidget extends StatelessWidget {
  final Function? onTap;
  const CustomBackButtonWidget({super.key, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: () => onTap == null ? NavigationHelper.pop() : onTap!(),
      child: Container(
        width: 36.r,
        height: 36.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1.3),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: SvgPicture.asset(
          AppImages.iconsChevronRightSolid,
          height: 18.r,
          width: 18.r,
        ),
      ),
    );
  }
}
