import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/service_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookingItem extends StatelessWidget {
  final String portName;
  final String statusText;
  final Color statusColor;
  final String serviceName;
  final String serviceDetails;
  final String location;
  final String dateText;

  /// مقدم الحجز.
  final num deposit;

  /// الإجمالي بعد الخصم (الرقم البرتقالي).
  final num finalCost;

  /// السعر الظاهر قبل الخصم (المشطوب). بيتعرض بس لو مختلف عن [finalCost].
  final num apparentPrice;

  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MyBookingItem({
    super.key,
    required this.portName,
    required this.statusText,
    required this.statusColor,
    required this.serviceName,
    required this.serviceDetails,
    required this.location,
    required this.dateText,
    required this.deposit,
    required this.finalCost,
    required this.apparentPrice,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  static String _money(num v) => v.round().toString();

  @override
  Widget build(BuildContext context) {
    final hasDiscount = apparentPrice > 0 && apparentPrice != finalCost;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 210.h,
        width: double.infinity,
        clipBehavior: Clip.none,
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: CustomPaint(
          painter: TicketPainter(
            borderColor: Colors.transparent,
            bgColor: Colors.white,
            shadowColor: Colors.black.withValues(alpha: 0.1),
            shadowBlurRadius: 46.r,
            shadowOffset: Offset(0, 4.h),
            shadowSpreadRadius: 0,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 10, 8).r,
            child: Column(
              children: [
                Row(
                  children: [
                    CustomImageHandler(
                      AppImages.iconsBuildings,
                      width: 20.r,
                      height: 20.r,
                    ),
                    5.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            portName,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.24,
                            ),
                          ),
                          Text(
                            statusText,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w400,
                              height: 1.64,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    5.horizontalSpace,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onEdit,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: CustomImageHandler(
                              AppImages.iconsEdit,
                              width: 17.r,
                              height: 17.r,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onDelete,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: CustomImageHandler(
                              AppImages.iconsTrash,
                              width: 18.r,
                              height: 18.r,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: const Color(0xFFF2F4F7), thickness: 1.r),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomImageHandler(
                                AppImages.iconsNote2,
                                width: 19.r,
                                height: 19.r,
                              ),
                              6.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      serviceName,
                                      textAlign: TextAlign.right,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: const Color(0xFF6F767E),
                                        fontSize: 12.r,
                                        fontFamily: 'Almarai',
                                        fontWeight: FontWeight.w700,
                                        height: 1.50,
                                        letterSpacing: -0.24,
                                      ),
                                    ),
                                    Text(
                                      serviceDetails,
                                      textAlign: TextAlign.right,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: const Color(0xFF99A2AC),
                                        fontSize: 11.r,
                                        fontFamily: 'Almarai',
                                        fontWeight: FontWeight.w300,
                                        height: 1.36,
                                        letterSpacing: -0.24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CustomImageHandler(
                                AppImages.iconsLocation2,
                                width: 16.r,
                                height: 16.r,
                                color: AppColors.primaryColor,
                              ),
                              6.horizontalSpace,
                              Expanded(
                                child: Text(
                                  location,
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: const Color(0xFF6F767E),
                                    fontSize: 12.r,
                                    fontFamily: 'Almarai',
                                    fontWeight: FontWeight.w700,
                                    height: 1.67,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CustomImageHandler(
                                AppImages.iconsCalendar2,
                                width: 16.r,
                                height: 16.r,
                              ),
                              6.horizontalSpace,
                              Text(
                                dateText,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: const Color(0xFF6F767E),
                                  fontSize: 12.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w700,
                                  height: 1.67,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    13.horizontalSpace,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Image.asset(
                        AppImages.imagesLuxuriousDinnerHall,
                        fit: BoxFit.fill,
                        height: 63.r,
                        width: 63.r,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      'مقدم الحجز',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0xFF99A2AC),
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        height: 1.54,
                        letterSpacing: -0.24,
                      ),
                    ),
                    const Spacer(),
                    Text.rich(
                      textDirection: TextDirection.ltr,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${_money(deposit)} ',
                            style: TextStyle(
                              color: const Color(0xFF79E2B2),
                              fontSize: 16.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                              letterSpacing: -0.24,
                            ),
                          ),
                          TextSpan(
                            text: 'جنيه',
                            style: TextStyle(
                              color: const Color(0xFF99A2AC),
                              fontSize: 12.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w400,
                              height: 1.67,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'الإجمالي',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0xFF99A2AC),
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        height: 1.54,
                        letterSpacing: -0.24,
                      ),
                    ),
                    const Spacer(),
                    if (hasDiscount) ...[
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            _money(apparentPrice),
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: const Color(0xFFFF928E),
                              fontSize: 12.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                              letterSpacing: -0.24,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 2.25.h,
                            child: CustomPaint(
                              size: Size(32.w, 10.h),
                              painter: StrikethroughPainter(),
                            ),
                          ),
                        ],
                      ),
                      7.horizontalSpace,
                    ],
                    Text.rich(
                      textDirection: TextDirection.ltr,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${_money(finalCost)} ',
                            style: TextStyle(
                              color: const Color(0xFFFE7062),
                              fontSize: 12.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w700,
                              height: 1.67,
                              letterSpacing: -0.24,
                            ),
                          ),
                          TextSpan(
                            text: 'جنيه',
                            style: TextStyle(
                              color: const Color(0xFF99A2AC),
                              fontSize: 12.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w400,
                              height: 1.67,
                              letterSpacing: -0.24,
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
      ),
    );
  }
}

class TicketPainter extends CustomPainter {
  final Color borderColor;
  final Color bgColor;
  final Color dottedLineColor;
  final Color shadowColor;
  final double shadowBlurRadius;
  final Offset shadowOffset;
  final double shadowSpreadRadius;

  static final _cornerGap = 16.r;
  static final _cutoutRadius = 9.r;
  static final _cutoutDiameter = _cutoutRadius * 2;

  TicketPainter({
    required this.bgColor,
    required this.borderColor,
    this.dottedLineColor = const Color(0xFFD9D9D9),
    this.shadowColor = Colors.transparent,
    this.shadowBlurRadius = 0,
    this.shadowOffset = Offset.zero,
    this.shadowSpreadRadius = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxWidth = size.width;
    final maxHeight = size.height;

    final cutoutStartPos = maxHeight - maxHeight * 0.23;
    final leftCutoutStartY = cutoutStartPos;
    final rightCutoutStartY = cutoutStartPos - _cutoutDiameter;

    final dottedLineY = cutoutStartPos - _cutoutRadius;
    double dottedLineStartX = _cutoutRadius;
    final double dottedLineEndX = maxWidth - _cutoutRadius;
    const double dashWidth = 8.5;
    const double dashSpace = 4;

    final paintBg = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..color = bgColor;

    final paintBorder = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = borderColor;

    final paintDottedLine = Paint()
      ..color = dottedLineColor
      ..strokeWidth = 1;

    var path = Path();

    path.moveTo(_cornerGap, 0);
    path.lineTo(maxWidth - _cornerGap, 0);
    _drawCornerArc(path, maxWidth, _cornerGap);
    path.lineTo(maxWidth, rightCutoutStartY);
    _drawCutout(path, maxWidth, rightCutoutStartY + _cutoutDiameter);
    path.lineTo(maxWidth, maxHeight - _cornerGap);
    _drawCornerArc(path, maxWidth - _cornerGap, maxHeight);
    path.lineTo(_cornerGap, maxHeight);
    _drawCornerArc(path, 0, maxHeight - _cornerGap);
    path.lineTo(0, leftCutoutStartY);
    _drawCutout(path, 0.0, leftCutoutStartY - _cutoutDiameter);
    path.lineTo(0, _cornerGap);
    _drawCornerArc(path, _cornerGap, 0);

    if (shadowColor != Colors.transparent) {
      final shadowPaint = Paint()
        ..color = shadowColor
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlurRadius / 2);

      canvas.save();
      canvas.translate(shadowOffset.dx, shadowOffset.dy);
      canvas.drawPath(path, shadowPaint);
      canvas.restore();
    }

    canvas.drawPath(path, paintBg);
    canvas.drawPath(path, paintBorder);

    while (dottedLineStartX < dottedLineEndX) {
      canvas.drawLine(
        Offset(dottedLineStartX, dottedLineY),
        Offset(dottedLineStartX + dashWidth, dottedLineY),
        paintDottedLine,
      );
      dottedLineStartX += dashWidth + dashSpace;
    }
  }

  void _drawCutout(Path path, double startX, double endY, [double? radius]) {
    path.arcToPoint(
      Offset(startX, endY),
      radius: Radius.circular(radius ?? _cutoutRadius),
      clockwise: false,
    );
  }

  void _drawCornerArc(
    Path path,
    double endPointX,
    double endPointY, [
    double? radius,
  ]) {
    path.arcToPoint(
      Offset(endPointX, endPointY),
      radius: Radius.circular(radius ?? _cornerGap),
    );
  }

  @override
  bool shouldRepaint(TicketPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TicketPainter oldDelegate) => false;
}
