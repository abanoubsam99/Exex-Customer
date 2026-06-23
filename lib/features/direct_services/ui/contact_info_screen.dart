import 'dart:convert';

import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/helpers/launcher_helper.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

/// شاشة "معلومات التواصل" — بتعرض أرقام التاجر وعنوانه ومواعيد عمله،
/// كلها من بيانات الـ [Item] الجاية من شاشة التفاصيل.
class ContactInfoScreen extends StatelessWidget {
  final Item? port;
  const ContactInfoScreen({super.key, this.port});

  static const _orange = AppColors.primaryColor;

  @override
  Widget build(BuildContext context) {
    final phones = [port?.phoneNumber1, port?.phoneNumber2]
        .where((e) => e != null && e.trim().isNotEmpty)
        .cast<String>()
        .toList();
    final address = [port?.governorate, port?.city]
        .where((e) => e != null && e.trim().isNotEmpty)
        .join(' - ');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const CustomBackButtonWidget(),
                  12.horizontalSpace,
                  Text(
                    'معلومات التواصل',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 18.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.24,
                    ),
                  ),
                ],
              ),
              8.verticalSpace,
              Text(
                'للتواصل مع التاجر أو مقدم الخدمة بشكل مباشر',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 13.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              28.verticalSpace,
              _sectionTitle('أرقام الهاتف'),
              12.verticalSpace,
              _card(
                child: Row(
                  children: [
                    _circleIconButton(
                      icon: AppImages.iconsPhone,
                      iconColor: AppColors.callIconColor,
                      bg: AppColors.callbg,
                      onTap: phones.isEmpty
                          ? null
                          : () => LauncherHelper.call(phones.first),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: phones.isEmpty
                            ? [_value('غير متوفر')]
                            : phones
                                .map((p) => Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.h),
                                      child: _value(p),
                                    ))
                                .toList(),
                      ),
                    ),

                  ],
                ),
              ),
              24.verticalSpace,
              _sectionTitle(
                'العنوان',
                // trailing: ,
              ),
              12.verticalSpace,
              _card(
                child: Row(
                  children: [
                    _circleIconButton(
                      icon: AppImages.iconsMarker,
                      bg: AppColors.primaryAlpha1A,
                      iconColor: _orange,
                      onTap: () => _openMap(address),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _value(address.isEmpty ? 'غير متوفر' : address),
                          if (port?.address != null &&
                              port!.address!.trim().isNotEmpty) ...[
                            4.verticalSpace,
                            _subValue(port!.address!),
                          ],
                        ],
                      ),
                    ),
                    _showLink(
                      onTap: () => _openMap(address),
                    )
                  ],
                ),
              ),
              24.verticalSpace,
              _sectionTitle('أيام العمل'),
              12.verticalSpace,
              _card(
                child: Row(
                  children: [
                    _circleIconButton(
                      materialIcon: Icons.access_time_rounded,
                      bg: AppColors.cyanAlpha1A,
                      iconColor: AppColors.cyan,
                      onTap: null,
                    ),
                    12.horizontalSpace,

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _value(_workDaysText(port?.workDays)),
                          if (_hours != null) ...[
                            4.verticalSpace,
                            _subValue(_hours!),
                          ],
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The backend stores work days as a JSON-array string, e.g.
  /// `["السبت","الاحد","الجمعة"]`. We show it as a plain, comma-separated list
  /// (`السبت، الاحد، الجمعة`) — stripping the brackets/quotes — or a prompt when
  /// it's empty.
  String _workDaysText(String? raw) {
    final value = raw?.trim() ?? '';
    if (value.isEmpty) return 'مواعيد العمل';
    Iterable<String> days;
    try {
      final decoded = jsonDecode(value);
      days = decoded is List
          ? decoded.map((e) => e.toString())
          : value.split(',');
    } catch (_) {
      // Not valid JSON — strip the brackets/quotes manually.
      days = value.replaceAll(RegExp(r'[\[\]"]'), '').split(',');
    }
    final cleaned =
        days.map((e) => e.trim()).where((e) => e.isNotEmpty).join('، ');
    return cleaned.isEmpty ? 'مواعيد العمل' : cleaned;
  }

  String? get _hours {
    final open = port?.openingTime?.trim();
    final close = port?.closingTime?.trim();
    if ((open?.isNotEmpty ?? false) && (close?.isNotEmpty ?? false)) {
      return '($open - $close)';
    }
    return null;
  }

  Widget _sectionTitle(String text, {Widget? trailing}) {
    return Row(
      children: [
        Container(
          width: 6.r,
          height: 18.r,
          decoration: ShapeDecoration(
            color: _orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.r),
            ),
          ),
        ),
        8.horizontalSpace,
        Text(
          text,
          style: TextStyle(
            color: AppColors.blacksoft,
            fontSize: 15.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
            letterSpacing: -0.24,
          ),
        ),
        if (trailing != null) ...[const Spacer(), trailing],
      ],
    );
  }

  Widget _showLink({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageHandler(
            AppImages.iconsMarker,
            width: 14.r,
            height: 14.r,
            color: _orange,
          ),
          4.horizontalSpace,
          Text(
            'عرض',
            style: TextStyle(
              color: _orange,
              fontSize: 13.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.boarderColor),
        boxShadow: const [
          BoxShadow(
            color: AppColors.blackAlpha0F,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _value(String text) => Text(
        text,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          color: AppColors.blacksoft,
          fontSize: 12.r,
          fontFamily: 'Almarai',
          fontWeight: FontWeight.w700,
          height: 1.5,
        ),
      );

  Widget _subValue(String text) => Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: AppColors.blueGrey,
          fontSize: 13.r,
          fontFamily: 'Almarai',
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      );

  Widget _circleIconButton({
    String? icon,
    IconData? materialIcon,
    required Color bg,
    Color iconColor = Colors.white,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100.r),
      child: Container(
        width: 44.r,
        height: 44.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: materialIcon != null
            ? Icon(materialIcon, size: 22.r, color: iconColor)
            : CustomImageHandler(
                icon!,
                width: 20.r,
                height: 20.r,
                color: iconColor,
              ),
      ),
    );
  }

  Future<void> _openMap(String address) async {
    await LauncherHelper.openMaps(gps: port?.gps, address: address);
  }
}
