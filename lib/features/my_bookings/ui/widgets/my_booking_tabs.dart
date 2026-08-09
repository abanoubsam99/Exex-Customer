import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/data/cubits/my_bookings/my_bookings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookingTabs extends StatelessWidget {
  const MyBookingTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      // Re-fetch the tapped tab's data so it auto-refreshes on every tap.
      // Each tab has its own status filter — the cancelled tab must NOT reuse
      // the confirmed loader (that would send status=Confirmed for cancelled).
      onTap: (index) {
        final cubit = context.read<MyBookingsCubit>();
        switch (index) {
          case 0:
            cubit.loadRequests();
            break;
          case 1:
            cubit.loadReservations();
            break;
          case 2:
            cubit.loadCancelled();
            break;
        }
      },
      dividerColor: AppColors.grey6,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 4.r,
      indicator: CustomTabIndicator(),
      labelStyle: TextStyle(
        color: AppColors.blacksoft,
        fontSize: 13.r,
        fontFamily: 'Almarai',
        fontWeight: FontWeight.w700,
        letterSpacing: -0.24,
      ),
      unselectedLabelStyle: TextStyle(
        color: AppColors.grey,
        fontSize: 13.r,
        fontFamily: 'Almarai',
        fontWeight: FontWeight.w400,
        letterSpacing: -0.24,
      ),

      isScrollable: false,
      // tabAlignment: TabAlignment.start,
      labelPadding: EdgeInsets.zero,
      tabs: [
        Tab(text: 'الطلبات الحالية'),
        Tab(text: 'الحجوزات المؤكدة'),
        Tab(text: 'الحجوزات الملغاه'),
      ],
    );
  }
}

class CustomTabIndicator extends Decoration {
  final double radius;

  final Color color;

  final double indicatorHeight;

  const CustomTabIndicator({
    this.radius = 8,
    this.indicatorHeight = 4,
    this.color = AppColors.primaryColor,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(this, onChanged, radius, color, indicatorHeight.h);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;
  final double radius;
  final Color color;
  final double indicatorHeight;

  _CustomPainter(
    this.decoration,
    VoidCallback? onChanged,
    this.radius,
    this.color,
    this.indicatorHeight,
  ) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    final Paint paint = Paint();
    double xAxisPos = offset.dx + configuration.size!.width / 2;
    double yAxisPos =
        offset.dy + configuration.size!.height - indicatorHeight / 2;
    paint.color = color;

    RRect fullRect = RRect.fromRectAndCorners(
      Rect.fromCenter(
        center: Offset(xAxisPos, yAxisPos + 1.5.h),
        width: configuration.size!.width,
        height: indicatorHeight,
      ),
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );

    canvas.drawRRect(fullRect, paint);
  }
}
