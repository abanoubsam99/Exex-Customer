import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/helpers/date_format_helper.dart';
import 'package:evex_user/core/ui/widgets/custom_circle.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/gradient_text.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/cubits/home/home_state.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/data/repos/confirm_booking_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class ChangeOccasion extends StatelessWidget {
  /// البوابة المختارة من الشاشة السابقة. لو اتبعتت بنعرض اسمها وموقعها الحقيقي،
  /// وإلا بنستخدم القيم الافتراضية (زي ما في شاشة تفاصيل الخدمة).
  final Item? port;

  /// The picked occasion date; shown instead of the placeholder when provided.
  final DateTime? occasionDate;

  const ChangeOccasion({super.key, this.port, this.occasionDate});

  String _location() {
    final parts = [port?.governorate, port?.city]
        .where((e) => e != null && e.trim().isNotEmpty)
        .cast<String>()
        .toList();
    if (parts.isEmpty) return 'اسيوط, اسيوط, مصر';
    return '${parts.join(', ')}, مصر';
  }

  /// Opens a date picker and stores the chosen occasion date in HomeCubit.
  Future<void> _editDate(BuildContext context) async {
    final cubit = context.read<HomeCubit>();
    final repo = context.read<ConfirmBookingRepo>();
    final now = DateTime.now();
    final current = cubit.state.bookingDate;
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('ar'),
      initialDate: (current != null && current.isAfter(now)) ? current : now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked == null) return;
    cubit.setBookingDate(picked);
    // Check instant-booking availability for this port on the picked date.
    final portId = port?.id;
    if (portId != null) {
      cubit.setAvailability(
        await repo.checkAvailability(portId: portId, date: picked),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final portName = port?.portName?.trim();
    final hasName = portName != null && portName.isNotEmpty;
    return Container(
      height: port == null ? 58.h : null,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 11.w,
        vertical: port == null ? 5.h : 8.h,
      ),
      decoration: ShapeDecoration(
        color: AppColors.bgGrey2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child:
                    BlocSelector<HomeCubit, HomeState, CheckReservationResponse?>(
                  selector: (s) => s.availability,
                  builder: (context, avail) {
                    final available = avail?.allowedToReservation ?? true;
                    final dotColor = available
                        ? AppColors.greenSoft
                        : AppColors.coral;
                    final textColor = available
                        ? AppColors.green2
                        : AppColors.coral;
                    final message = avail?.verificationResultMessage ??
                        (available
                            ? 'متاح للحجز الفوري'
                            : 'غير متاح في هذا الميعاد');
                    return Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomCircle(
                              radius: 14.r,
                              color: dotColor.withValues(alpha: 0.4),
                            ),
                            CustomCircle(radius: 6.r, color: dotColor),
                          ],
                        ),
                        6.horizontalSpace,
                        Expanded(
                          child: Text(
                            message,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              GradientText(
                'متجدد لحظه بلحظه',
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0, 0.64, 1],
                  colors: [
                    AppColors.greenSoft,
                    AppColors.green4,
                    AppColors.greenSoft,
                  ],
                ),
                style: TextStyle(
                  color: AppColors.blueGrey,
                  fontSize: 12.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          if (hasName) ...[
            4.verticalSpace,
            Text(
              portName,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.blacksoft,
                fontSize: 15.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          4.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    BlocSelector<HomeCubit, HomeState, DateTime?>(
                      selector: (s) => s.bookingDate,
                      builder: (context, date) {
                        final d = date ?? occasionDate;
                        return Text(
                          d != null
                              ? DateFormatHelper.arabicDate(d.toIso8601String())
                              : 'حدد تاريخ المناسبة',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: AppColors.blacksoft,
                            fontSize: 14.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                    6.horizontalSpace,
                    Transform.translate(
                      offset: Offset(0, 2.h),
                      child:
                          CustomCircle(radius: 5.r, color: AppColors.dividerGrey),
                    ),
                    6.horizontalSpace,
                    Flexible(
                      child: Text(
                        _location(),
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.blueGrey,
                          fontSize: 14.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    6.horizontalSpace,
                    Transform.translate(
                      offset: Offset(0, 2.h),
                      child:
                          CustomCircle(radius: 5.r, color: AppColors.dividerGrey),
                    ),
                    6.horizontalSpace,
                    const Text(
                      'فرح',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.blueGrey,
                        fontSize: 14,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                        height: 1.43,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ],
                ),
              ),
              8.horizontalSpace,
              GestureDetector(
                onTap: () => _editDate(context),
                child: CustomImageHandler(
                  AppImages.iconsEdit,
                  width: 14.r,
                  height: 14.r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
