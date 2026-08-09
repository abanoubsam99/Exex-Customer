import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: ShapeDecoration(
                color:
                    transaction.paymentType == 0
                        ? AppColors.red6Alpha19
                        : AppColors.greenSoftAlpha19,
                shape: OvalBorder(),
              ),
              alignment: Alignment.center,
              child: CustomImageHandler(
                transaction.paymentType == 0
                    ? AppImages.iconsOutcome
                    : AppImages.iconsIncome,
                width: 15.r,
                height: 15.r,
              ),
            ),
            Positioned(
              bottom: -6.r,
              left: -6.r,
              child: Container(
                width: 22.r,
                height: 22.r,
                decoration: ShapeDecoration(
                  color: AppColors.boarderFillColor,
                  shape: OvalBorder(
                    side: BorderSide(width: 1.5, color: Colors.white),
                  ),
                ),
                alignment: Alignment.center,
                child: CustomImageHandler(
                  transaction.paymentMethodImage,
                  width: 15.r,
                  height: 10.r,
                ),
              ),
            ),
          ],
        ),
        10.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction.portName,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                letterSpacing: -0.24,
              ),
            ),
            Text(
              transaction.dateText,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 12.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w400,
                height: 1.67,
                letterSpacing: -0.24,
              ),
            ),
          ],
        ),
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              // Payments (paymentType == 0) show no minus sign — the red colour
              // and the outgoing arrow already mark them; income keeps its '+'.
              '${transaction.paymentType == 0 ? '' : '+'}${transaction.paymentAmount}',
              textAlign: TextAlign.right,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color:
                    transaction.paymentType == 0
                        ? AppColors.red3
                        : AppColors.greenSoft,
                fontSize: 18.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                letterSpacing: -0.24,
              ),
            ),
            Text(
              transaction.paymentReasson.tr(),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 12.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w400,
                letterSpacing: -0.24,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
