import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({
    super.key,
    required this.title,
    this.onChanged,
    this.onBeforePick,
  });

  final String title;

  /// Called when the user picks a date.
  final ValueChanged<DateTime>? onChanged;

  /// Optional gate run before the calendar opens. Return `false` to block it
  /// (e.g. guests are prompted to sign in instead of picking a date).
  final bool Function()? onBeforePick;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.onBeforePick != null && !widget.onBeforePick!()) return;
        final DateTime? picked = await showDatePicker(
          context: context,
          locale: const Locale('ar'),
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked == null) return;
        setState(() {
          selectedDate = picked;
        });
        widget.onChanged?.call(picked);
      },
      child: Container(
        height: 46.h,
        decoration: ShapeDecoration(
          color: AppColors.boarderFillColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomImageHandler(
                AppImages.iconsCalendar,
                color: AppColors.lightOrange2,
              ),
              8.horizontalSpace,
              Text(
                selectedDate != null
                    ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                    : widget.title,
                style: TextStyle(
                  color: AppColors.blueGrey,
                  fontSize: 14.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.24,
                ),
              ),
              Spacer(),
              CustomImageHandler(
                AppImages.iconsAngleSmallDown,
                fit: BoxFit.cover,
                height: 16.r,
                width: 16.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
