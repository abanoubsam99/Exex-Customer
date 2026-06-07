import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key, required this.title});

  final String title;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          locale: const Locale('ar'),
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        setState(() {
          selectedDate = picked;
        });
      },
      child: Container(
        height: 46.h,
        decoration: ShapeDecoration(
          color: const Color(0xFFF4F4F4),
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
                color: const Color(0xFFF8BC96),
              ),
              8.horizontalSpace,
              Text(
                selectedDate != null
                    ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                    : widget.title,
                style: TextStyle(
                  color: const Color(0xFF99A2AC),
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
