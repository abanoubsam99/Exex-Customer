import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/models/port_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

/// كارت منتج/خدمة في شاشة الدفع المباشر (عرض فقط — بيفتح bottom sheet التفاصيل).
class DirectProductCard extends StatelessWidget {
  final PortService service;
  final VoidCallback onTap;

  const DirectProductCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final before = service.priceBeforDiscount;
    final price = service.price ?? 0;
    final hasDiscount = before != null && before > price;
    final discountPercent =
        hasDiscount ? (((before - price) / before) * 100).round() : 0;
    final images = service.serviceImages ?? const <String>[];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 141.w,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shadows: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 16.r,
              offset: Offset(0, 4.r),
              spreadRadius: -2,
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 89.h,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: CustomImageHandler(
                          images.isEmpty
                              ? AppImages.imagesWedding2
                              : (ImageUrlHelper.full(images.first) ??
                                  AppImages.imagesWedding2),
                          fit: BoxFit.cover,
                          errorIcon: const Icon(Icons.broken_image_outlined),
                        ),
                      ),
                    ),
                    if (hasDiscount)
                      Positioned(
                        top: 4.r,
                        left: 4.r,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            '$discountPercent%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              6.verticalSpace,
              Text(
                service.name ?? '',
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.blacksoft,
                  fontSize: 14.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                  letterSpacing: -0.24,
                ),
              ),
              Text(
                service.details ?? '',
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.blueGrey,
                  fontSize: 12.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  letterSpacing: -0.24,
                ),
              ),
              8.verticalSpace,
              Row(
                textDirection: TextDirection.ltr,
                children: [
                  if (hasDiscount) ...[
                    Text(
                      '$before LE',
                      style: TextStyle(
                        color: AppColors.unitGrey,
                        fontSize: 11.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: AppColors.salmon,
                      ),
                    ),
                    6.horizontalSpace,
                  ],
                  Text.rich(
                    textDirection: TextDirection.ltr,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$price',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: ' LE',
                          style: TextStyle(
                            color: AppColors.blueGrey,
                            fontSize: 12.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
