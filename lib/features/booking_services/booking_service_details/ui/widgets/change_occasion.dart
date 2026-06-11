import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_circle.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/gradient_text.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangeOccasion extends StatelessWidget {
  /// البوابة المختارة من الشاشة السابقة. لو اتبعتت بنعرض اسمها وموقعها الحقيقي،
  /// وإلا بنستخدم القيم الافتراضية (زي ما في شاشة تفاصيل الخدمة).
  final Item? port;

  const ChangeOccasion({super.key, this.port});

  String _location() {
    final parts = [port?.governorate, port?.city]
        .where((e) => e != null && e.trim().isNotEmpty)
        .cast<String>()
        .toList();
    if (parts.isEmpty) return 'اسيوط, اسيوط, مصر';
    return '${parts.join(', ')}, مصر';
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
        color: Color(0xFFF7F7F7),
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
              Stack(
                alignment: Alignment.center,
                children: [
                  CustomCircle(radius: 14.r, color: Color(0x6879E2B2)),
                  CustomCircle(radius: 6.r, color: Color(0xFF79E2B2)),
                ],
              ),
              6.horizontalSpace,
              Text(
                'متاح للحجز الفوري',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFF42C287),
                  fontSize: 14.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Spacer(),
              GradientText(
                'متجدد لحظه بلحظه',
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0, 0.64, 1],
                  colors: [
                    const Color(0xFF79E2B2),
                    const Color(0xFF55A07E),
                    const Color(0xFF79E2B2),
                  ],
                ),
                style: TextStyle(
                  color: const Color(0xFF99A2AC),
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
                color: const Color(0xFF2C262C),
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
                    Text(
                      '22 اكتوبر 2026',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFF2C262C),
                        fontSize: 14.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    6.horizontalSpace,
                    Transform.translate(
                      offset: Offset(0, 2.h),
                      child:
                          CustomCircle(radius: 5.r, color: Color(0xFFD9D9D9)),
                    ),
                    6.horizontalSpace,
                    Flexible(
                      child: Text(
                        _location(),
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF99A2AC),
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
                          CustomCircle(radius: 5.r, color: Color(0xFFD9D9D9)),
                    ),
                    6.horizontalSpace,
                    const Text(
                      'فرح',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFF99A2AC),
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
              CustomImageHandler(
                AppImages.iconsEdit,
                width: 14.r,
                height: 14.r,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
