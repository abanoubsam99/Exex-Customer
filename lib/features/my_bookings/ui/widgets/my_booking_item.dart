import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/service_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyBookingItem extends StatelessWidget {
  final String portName;
  final String statusText;
  final Color statusColor;
  final String serviceName;
  final String location;
  final String dateText;

  /// الإجمالي بعد الخصم (الرقم البرتقالي).
  final num finalCost;

  /// السعر الظاهر قبل الخصم (المشطوب). بيتعرض بس لو مختلف عن [finalCost].
  final num apparentPrice;

  /// The highlighted (green) amount row — label + value. Varies per tab:
  /// مقدم الحجز (requests) / المبلغ المدفوع (confirmed) / المبلغ المسترد (cancelled).
  final String primaryAmountLabel;
  final num primaryAmountValue;

  /// The second (coral) amount row — label + value. Varies per tab:
  /// الإجمالي (requests) / المتبقي (confirmed) / المدفوع (cancelled).
  final String secondaryAmountLabel;
  final num secondaryAmountValue;

  /// When true, the secondary row shows the pre-discount price ([apparentPrice])
  /// struck through next to its value. Only the الإجمالي row (requests) uses it.
  final bool secondaryShowStrikethrough;

  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  /// When set, the header shows a single download icon (DownloadInfo) instead of
  /// the edit + trash actions. Used by the confirmed / cancelled tabs.
  final VoidCallback? onDownload;

  /// When true (requests tab), an envelope icon with a badge is shown in the
  /// content row. The badge reads 1 when [hasMessage] is true, 0 otherwise.
  final bool showMessageIcon;

  /// Whether the vendor sent a pending message (drives the badge count).
  final bool hasMessage;

  /// Tapping the envelope icon (opens the pending-message dialog).
  final VoidCallback? onMessageTap;

  const MyBookingItem({
    super.key,
    required this.portName,
    required this.statusText,
    required this.statusColor,
    required this.serviceName,
    required this.location,
    required this.dateText,
    required this.finalCost,
    required this.apparentPrice,
    required this.primaryAmountLabel,
    required this.primaryAmountValue,
    required this.secondaryAmountLabel,
    required this.secondaryAmountValue,
    this.secondaryShowStrikethrough = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onDownload,
    this.showMessageIcon = false,
    this.hasMessage = false,
    this.onMessageTap,
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
                    // Confirmed / cancelled cards: total price (old struck-through
                    // + final) next to a single download (DownloadInfo) action.
                    // Otherwise (current requests): edit + trash.
                    if (onDownload != null) ...[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // if (hasDiscount)
                            // Text(
                            //   _money(apparentPrice),
                            //   textDirection: TextDirection.ltr,
                            //   style: TextStyle(
                            //     color: AppColors.salmon,
                            //     fontSize: 12.r,
                            //     fontFamily: 'Almarai',
                            //     fontWeight: FontWeight.w400,
                            //     height: 1.2,
                            //     letterSpacing: -0.24,
                            //     decoration: TextDecoration.lineThrough,
                            //     decorationColor: AppColors.salmon,
                            //   ),
                            // ),
                          Text(
                            _money(finalCost),
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 15.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
                      8.horizontalSpace,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onDownload,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child:
                                SvgPicture.asset(AppImages.iconsDownload,width:22.r ,height: 22.r,)
                              // Icon(
                              //   Icons.download_rounded,
                              //   size: 22.r,
                              //   color: AppColors.primaryColor,
                              // ),
                            ),
                          ),
                        ),
                      ),
                    ]
                    else ...[
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
                  ],
                ),
                Divider(color: AppColors.boarderColor, thickness: 1.r),
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
                                child: Text(
                                  serviceName,
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 12.r,
                                    fontFamily: 'Almarai',
                                    fontWeight: FontWeight.w700,
                                    height: 1.50,
                                    letterSpacing: -0.24,
                                  ),
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
                                    color: AppColors.grey,
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
                                  color: AppColors.grey,
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
                    if (showMessageIcon && hasMessage) ...[
                      10.horizontalSpace,
                      _MessageBadge(
                        count: 1,
                        onTap: onMessageTap,
                      ),
                    ],
                  ],
                ),
                const Spacer(),
                // Highlighted (green) amount row — مقدم الحجز / المبلغ المدفوع /
                // المبلغ المسترد depending on the tab.
                Row(
                  children: [
                    Text(
                      primaryAmountLabel,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.blueGrey,
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        height: 1.54,
                        letterSpacing: -0.24,
                      ),
                    ),
                    const Spacer(),
                    Text.rich(
                      textDirection: TextDirection.rtl,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${_money(primaryAmountValue)} ',
                            style: TextStyle(
                              color: AppColors.greenSoft,
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
                              color: AppColors.blueGrey,
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
                // Second (coral) amount row — الإجمالي / المتبقي / المدفوع
                // depending on the tab. Only الإجمالي shows the struck price.
                Row(
                  children: [
                    Text(
                      secondaryAmountLabel,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.blueGrey,
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        height: 1.54,
                        letterSpacing: -0.24,
                      ),
                    ),
                    const Spacer(),
                    if (secondaryShowStrikethrough && hasDiscount) ...[
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            _money(apparentPrice),
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: AppColors.salmon,
                              fontSize: 14.r,
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
                      textDirection: TextDirection.rtl,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${_money(secondaryAmountValue)} ',
                            style: TextStyle(
                              color: AppColors.coral,
                              fontSize: 14.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w700,
                              height: 1.67,
                              letterSpacing: -0.24,
                            ),
                          ),
                          TextSpan(
                            text: 'جنيه',
                            style: TextStyle(
                              color: AppColors.blueGrey,
                              fontSize: 14.r,
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

/// Envelope icon with a small red badge showing the pending-message count
/// (1 when the vendor sent a message, 0 otherwise). Tapping opens the dialog.
class _MessageBadge extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;

  const _MessageBadge({required this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SvgPicture.asset(
              AppImages.iconsMessage,
              width: 28.r,
              height: 28.r,
            ),
            Positioned(
              top: -4.r,
              right: -4.r,
              child: Container(
                width: 16.r,
                height: 16.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.coral,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.r),
                ),
                child: Text(
                  '1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
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
    this.dottedLineColor = AppColors.dividerGrey,
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
