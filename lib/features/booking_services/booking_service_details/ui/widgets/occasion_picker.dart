import 'package:evex_user/data/models/occasion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

/// "نوع المناسبة" picker. Lives on the service-details screen now (validated
/// before "إضافة لحجوزاتي") and feeds the chosen occasionId through to the
/// booking request — the backend rejects a reservation without it.
class OccasionPicker extends StatelessWidget {
  final List<Occasion> occasions;
  final int? selectedId;
  final ValueChanged<int> onSelected;
  const OccasionPicker({
    super.key,
    required this.occasions,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع المناسبة',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: AppColors.blacksoft,
            fontSize: 15.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
          ),
        ),
        8.verticalSpace,
        Container(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: AppColors.boarderFillColor,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: selectedId,
              borderRadius: BorderRadius.circular(14.r),
              hint: Text(
                'حدد نوع المناسبة',
                style: TextStyle(
                  color: AppColors.blueGrey,
                  fontSize: 14.r,
                  fontFamily: 'Almarai',
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.blueGrey),
              items: occasions
                  .where((o) => o.id != null)
                  .map((o) => DropdownMenuItem<int>(
                        value: o.id,
                        child: Text(
                          o.name ?? '',
                          style: TextStyle(
                            color: AppColors.blacksoft,
                            fontSize: 14.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) onSelected(v);
              },
            ),
          ),
        ),
      ],
    );
  }
}
