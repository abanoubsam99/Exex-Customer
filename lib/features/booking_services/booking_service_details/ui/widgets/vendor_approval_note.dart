import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Amber note shown only when the availability check comes back with
/// `confirmationIsRequiredFromVendor == true`: the slot is bookable, but the
/// vendor has to approve it before the reservation (and its payment) can be
/// completed.
class VendorApprovalNote extends StatelessWidget {
  const VendorApprovalNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: ShapeDecoration(
        color: AppColors.yellowBg,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.amber.withValues(alpha: 0.45)),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 18.r,
            color: AppColors.black,
          ),
          6.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Sized to keep each line on ONE line inside the card, like the
                // design — the wording here is longer than the mock's.
                Text(
                  'يلزم موافقة هذا التاجر أولاً لتأكيد الحجز',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.bold,
                    height: 1.40,
                  ),
                ),
                2.verticalSpace,
                Text(
                  'يتم إشعارك فور موافقة التاجر لاستكمال الدفع',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.grey2,
                    fontSize: 10.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w400,
                    height: 1.40,
                  ),
                ),
              ],
            ),
          ),
          6.horizontalSpace,
          CustomImageHandler(
            AppImages.iconsVendorApproval,
            width: 30.r,
            height: 30.r,
          ),
        ],
      ),
    );
  }
}
