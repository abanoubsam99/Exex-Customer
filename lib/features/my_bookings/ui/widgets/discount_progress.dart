import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/cubits/my_bookings/my_bookings_cubit.dart';
import 'package:evex_user/data/cubits/my_bookings/my_bookings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _orange = Color(0xFFF38B4A);
const _green = Color(0xFF4CD195);

/// Multi-booking discount banner, driven by CalculatePendingDeposit.
/// Two states: in-progress (orange) and achieved (green).
class DiscountProgress extends StatelessWidget {
  const DiscountProgress({super.key});

  String _n(num v) =>
      v == v.roundToDouble() ? v.round().toString() : v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyBookingsCubit, MyBookingsState>(
      buildWhen: (p, c) => p.pendingDeposit != c.pendingDeposit,
      builder: (context, state) {
        final summary = state.pendingDeposit;
        if (summary == null) return const SizedBox.shrink();
        final target = summary.numberOfReservationsAdditionalDiscount;
        final current = summary.totalRequests;
        final percentage = summary.additionalDiscountPercentage;
        final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
        final achieved = target > 0 && current >= target;
        return achieved
            ? _achieved(percentage, current, target,
                summary.additionalDiscountAmount, progress)
            : _inProgress(percentage, current, target, progress);
      },
    );
  }

  // ── In-progress (orange) ──
  Widget _inProgress(num percentage, int current, int target, double progress) {
    return _shell(
      bg: const Color(0x19F38B4A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomImageHandler(
                AppImages.iconsBadgePercent,
                height: 28.r,
                width: 28.r,
              ),
              4.horizontalSpace,
              Expanded(
                child: Text(
                  'لفترة محدودة تقدر تستفيد بخصم إضافي ',
                  // 'لفترة محدودة تقدر تستفيد بخصم إضافي ${_n(percentage)}%',
                  textAlign: TextAlign.right,
                  style: _titleStyle,
                ),
              ),
            ],
          ),
          Text(
            'على كل خدمة من خدمات الحجز الفوري لما تحجز $target خدمات أو اكتر!',
            textAlign: TextAlign.right,
            style: _subStyle,
          ),
          8.verticalSpace,
          Text('مجموع الخدمات :', textAlign: TextAlign.right, style: _labelStyle),
          4.verticalSpace,
          _bar('$current من $target', progress, _orange),
        ],
      ),
    );
  }

  // ── Achieved (green) ──
  Widget _achieved(
    num percentage,
    int current,
    int target,
    num amount,
    double progress,
  ) {
    return _shell(
      bg: const Color(0x194CD195),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomImageHandler(
                AppImages.iconsBadgePercent,
                height: 28.r,
                width: 28.r,
              ),
              4.horizontalSpace,
              Text('مبروك !', style: _titleStyle),
            ],
          ),
          Text(
            'حصلت على خصم إضافي ${_n(percentage)}% على كل خدمة أساسية',
            textAlign: TextAlign.right,
            style: _subStyle,
          ),
          8.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('مجموع الخدمات :', style: _labelStyle),
              Row(
                children: [
                  Text('قيمة الخصم  ', style: _labelStyle),
                  Text(
                    '${_n(amount)} جنيه',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: _green,
                      fontSize: 12.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w800,
                      height: 1.67,
                      letterSpacing: -0.24,
                    ),
                  ),
                ],
              ),
            ],
          ),
          4.verticalSpace,
          _bar('$current من $target', progress, _green),
        ],
      ),
    );
  }

  Widget _shell({required Color bg, required Widget child}) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.all(12.r),
      decoration: ShapeDecoration(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: child,
    );
  }

  Widget _bar(String label, double value, Color color) {
    return Row(
      children: [
        Text(
          label,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: const Color(0xFF2C262C),
            fontSize: 12.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
            height: 1.67,
            letterSpacing: -0.24,
          ),
        ),
        7.horizontalSpace,
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            borderRadius: BorderRadius.circular(4.r),
            minHeight: 5.r,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  TextStyle get _titleStyle => TextStyle(
        color: const Color(0xFF2C262C),
        fontSize: 14.r,
        fontFamily: 'Almarai',
        fontWeight: FontWeight.w700,
        height: 1.43,
        letterSpacing: -0.24,
      );

  TextStyle get _subStyle => TextStyle(
        color: const Color(0xFF6F767E),
        fontSize: 12.r,
        fontFamily: 'Almarai',
        fontWeight: FontWeight.w400,
        height: 1.67,
        letterSpacing: -0.24,
      );

  TextStyle get _labelStyle => TextStyle(
        color: const Color(0xFF2C262C),
        fontSize: 12.r,
        fontFamily: 'Almarai',
        fontWeight: FontWeight.w400,
        height: 1.67,
        letterSpacing: -0.24,
      );
}
