import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_images.dart';
import 'scoial_media_item.dart';

class AllSocalMediaWidget extends StatelessWidget {
  const AllSocalMediaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScoialMediaItemWidget(image: AppImages.iconsFeacbook),
        12.horizontalSpace,
        ScoialMediaItemWidget(image: AppImages.iconsGoogel),
      ],
    );
  }
}
