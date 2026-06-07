import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceCostDetailsSection extends StatelessWidget {
  const ServiceCostDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 6.r,
              height: 18.r,
              decoration: ShapeDecoration(
                color: const Color(0xFFF38B4A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),
            8.horizontalSpace,
            Text(
              'تفاصيل تكلفة الخدمة',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                letterSpacing: -0.24,
              ),
            ),
          ],
        ),
        16.verticalSpace,
        SizedBox(
          height: 192.h,
          width: double.infinity,
          child: CustomPaint(
            painter: TicketPainter(
              borderColor: const Color(0x7FFFB88C),
              bgColor: const Color(0x7FFEF1E9).withValues(alpha: 0.5),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'عمولة evex',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFF6F767E),
                          fontSize: 14.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                      Spacer(),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '0',
                              style: TextStyle(
                                color: const Color(0xFF6F767E),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w700,
                                height: 1.50,
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: const Color(0xFF6F767E),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            TextSpan(
                              text: 'جنيه',
                              style: TextStyle(
                                color: const Color(0xFFA5B7C6),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  6.verticalSpace,
                  Row(
                    children: [
                      Text(
                        'رسوم إدارية',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFF6F767E),
                          fontSize: 14.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                      Spacer(),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '0',
                              style: TextStyle(
                                color: const Color(0xFF6F767E),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w700,
                                height: 1.50,
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: const Color(0xFF6F767E),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            TextSpan(
                              text: 'جنيه',
                              style: TextStyle(
                                color: const Color(0xFFA5B7C6),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  6.verticalSpace,
                  Row(
                    children: [
                      Text(
                        'ضريبة',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFF6F767E),
                          fontSize: 14.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                      Spacer(),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '0',
                              style: TextStyle(
                                color: const Color(0xFF6F767E),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w700,
                                height: 1.50,
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: const Color(0xFF6F767E),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            TextSpan(
                              text: 'جنيه',
                              style: TextStyle(
                                color: const Color(0xFFA5B7C6),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  6.verticalSpace,
                  Row(
                    children: [
                      Text(
                        'مبلغ التأمين',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFF6F767E),
                          fontSize: 14.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                      Spacer(),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '0',
                              style: TextStyle(
                                color: const Color(0xFF6F767E),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w700,
                                height: 1.50,
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: const Color(0xFF6F767E),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            TextSpan(
                              text: 'جنيه',
                              style: TextStyle(
                                color: const Color(0xFFA5B7C6),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        'مقدم الحجز',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFF6F767E),
                          fontSize: 14.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                      Spacer(),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '1000',
                              style: TextStyle(
                                color: const Color(0xFF6F767E),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w700,
                                height: 1.50,
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: const Color(0xFF6F767E),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            TextSpan(
                              text: 'جنيه',
                              style: TextStyle(
                                color: const Color(0xFFA5B7C6),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
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
                        'إجمالى التكلفة',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFF6F767E),
                          fontSize: 16.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),

                      Spacer(),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '9999.99',
                              style: TextStyle(
                                color: const Color(0xFFF38B4A),
                                fontSize: 18.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w800,
                                height: 1.50,
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: const Color(0xFF6F767E),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            TextSpan(
                              text: 'جنيه',
                              style: TextStyle(
                                color: const Color(0xFFA5B7C6),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
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
      ],
    );
  }
}

class TicketPainter extends CustomPainter {
  final Color borderColor;
  final Color bgColor;

  static final _cornerGap = 16.r;
  static final _cutoutRadius = 9.r;
  static final _cutoutDiameter = _cutoutRadius * 2;

  TicketPainter({required this.bgColor, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final maxWidth = size.width;
    final maxHeight = size.height;

    final cutoutStartPos = maxHeight - maxHeight * 0.3;
    final leftCutoutStartY = cutoutStartPos;
    final rightCutoutStartY = cutoutStartPos - _cutoutDiameter;

    final dottedLineY = cutoutStartPos - _cutoutRadius;
    double dottedLineStartX = _cutoutRadius;
    final double dottedLineEndX = maxWidth - _cutoutRadius;
    const double dashWidth = 8.5;
    const double dashSpace = 4;

    final paintBg =
        Paint()
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round
          ..color = bgColor;

    final paintBorder =
        Paint()
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..color = borderColor;

    final paintDottedLine =
        Paint()
          ..color = borderColor
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

  _drawCutout(Path path, double startX, double endY) {
    path.arcToPoint(
      Offset(startX, endY),
      radius: Radius.circular(_cutoutRadius),
      clockwise: false,
    );
  }

  _drawCornerArc(Path path, double endPointX, double endPointY) {
    path.arcToPoint(
      Offset(endPointX, endPointY),
      radius: Radius.circular(_cornerGap),
    );
  }

  @override
  bool shouldRepaint(TicketPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TicketPainter oldDelegate) => false;
}
