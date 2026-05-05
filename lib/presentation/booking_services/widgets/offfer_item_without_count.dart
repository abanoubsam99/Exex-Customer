import 'package:evexcustomer/app/constants/app_images.dart';
import 'package:evexcustomer/app/constants/MyColors.dart';
import 'package:evexcustomer/app/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfferItemWithoutCount extends StatelessWidget {
  final String title, trilling;
  final bool? isGift;
  final bool isSelected;
  final VoidCallback onChanged;
  const OfferItemWithoutCount({
    super.key,
    required this.title,
    required this.isSelected,
    required this.trilling,
    required this.isGift,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isGift == null || isGift == false) {
          onChanged();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? AppColors.secondaryColor : const Color(0xffE4E7EC),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF2C262C),
                fontSize: 12,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                letterSpacing: -0.24,
              ),
            ),
            const Spacer(),
            if (isGift ?? false)
              SizedBox(
                child: Card(
                  color: const Color(0xffFFF1E9),
                  shape: const StadiumBorder(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          const CustomImageHandler(AppImages.imagesGift),
                          Text(
                            " $title ",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            const Spacer(),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: trilling,

                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor,
                    ), // Use .sp for responsive font size
                  ),
                  TextSpan(
                    text: ' جنيه',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.blackColor,
                    ), // Use .sp for responsive font size
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

