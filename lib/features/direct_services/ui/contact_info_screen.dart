import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/helpers/launcher_helper.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// شاشة "معلومات التواصل" — بتعرض أرقام التاجر وعنوانه ومواعيد عمله،
/// كلها من بيانات الـ [Item] الجاية من شاشة التفاصيل.
class ContactInfoScreen extends StatelessWidget {
  final Item? port;
  const ContactInfoScreen({super.key, this.port});

  static const _orange = Color(0xFFF38B4A);

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
                      color: const Color(0xFF121212),
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
                  color: const Color(0xFF6F767E),
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
                    12.horizontalSpace,
                    _circleIconButton(
                      icon: AppImages.iconsPhone,
                      bg: const Color(0xFF40C4D6),
                      onTap: phones.isEmpty
                          ? null
                          : () => LauncherHelper.call(phones.first),
                    ),
                  ],
                ),
              ),
              24.verticalSpace,
              _sectionTitle(
                'العنوان',
                trailing: _showLink(
                  onTap: () => _openMap(address),
                ),
              ),
              12.verticalSpace,
              _card(
                child: Row(
                  children: [
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
                    12.horizontalSpace,
                    _circleIconButton(
                      icon: AppImages.iconsMarker,
                      bg: const Color(0x1AF38B4A),
                      iconColor: _orange,
                      onTap: () => _openMap(address),
                    ),
                  ],
                ),
              ),
              24.verticalSpace,
              _sectionTitle('أيام العمل'),
              12.verticalSpace,
              _card(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _value(
                            (port?.workDays?.trim().isNotEmpty ?? false)
                                ? port!.workDays!
                                : 'مواعيد العمل',
                          ),
                          if (_hours != null) ...[
                            4.verticalSpace,
                            _subValue(_hours!),
                          ],
                        ],
                      ),
                    ),
                    12.horizontalSpace,
                    _circleIconButton(
                      icon: AppImages.iconsReceipt,
                      bg: const Color(0x1A40C4D6),
                      iconColor: const Color(0xFF40C4D6),
                      onTap: null,
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
            color: const Color(0xFF2C262C),
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
        border: Border.all(color: const Color(0xFFF2F4F7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
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
          color: const Color(0xFF2C262C),
          fontSize: 15.r,
          fontFamily: 'Almarai',
          fontWeight: FontWeight.w700,
          height: 1.5,
        ),
      );

  Widget _subValue(String text) => Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: const Color(0xFF99A2AC),
          fontSize: 13.r,
          fontFamily: 'Almarai',
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      );

  Widget _circleIconButton({
    required String icon,
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
        child: CustomImageHandler(
          icon,
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
