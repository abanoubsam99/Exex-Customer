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
    this.initialDate,
    this.onChanged,
    this.onBeforePick,
  });

  final String title;

  /// The date to show when the user hasn't picked one this build (comes from the
  /// session store, so the chosen date survives leaving and re-entering the
  /// screen). A locally picked date takes precedence over it.
  final DateTime? initialDate;

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
  void didUpdateWidget(covariant DatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The session date is the source of truth. When it changes from somewhere
    // else — e.g. the user edited the date inside a service and came back — the
    // local pick is stale and must not keep shadowing it.
    if (widget.initialDate != oldWidget.initialDate) {
      selectedDate = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Local pick wins; otherwise fall back to the session date passed in.
    final shown = selectedDate ?? widget.initialDate;
    final now = DateTime.now();
    return GestureDetector(
      onTap: () async {
        if (widget.onBeforePick != null && !widget.onBeforePick!()) return;
        final DateTime? picked = await showDatePicker(
          context: context,
          locale: const Locale('ar'),
          initialDate: (shown != null && !shown.isBefore(now)) ? shown : now,
          firstDate: now,
          lastDate: now.add(const Duration(days: 365)),
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
          // color: AppColors.bg,
          // Orange outlined box, matching the design.
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppColors.primaryColor, width: 1.5),
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomImageHandler(
                AppImages.iconsCalendar2,
                color: AppColors.primaryColor,
              ),
              8.horizontalSpace,
              Text(
                shown != null
                    ? DateFormat('dd/MM/yyyy').format(shown)
                    : widget.title,
                style: TextStyle(
                  color: AppColors.descriptionText,
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
