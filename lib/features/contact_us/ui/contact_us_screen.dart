import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/theme/app_text_styles.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// شاشة "اتصل بنا" — محتوى ثابت (مكاتب + قنوات تواصل + سوشيال ميديا).
/// مفيش cubit/repo لأنها معلومات ثابتة (زي more_screen).
class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  // بيانات ثابتة — لو اتغيّرت بعدين تتنقل لمصدر مركزي / API.
  static const List<_Office> _offices = [
    _Office(
      name: 'مكتب قنا - فرع نجع حمادى',
      address: 'حى شبرا  امام محطه مترو روض الفرج - شارع الفسطاط',
      phones: ['(+20) 1220789797', '(+20) 1220789797'],
    ),
    _Office(
      name: 'مكتب قنا - فرع نجع حمادى',
      address: 'حى شبرا  امام محطه مترو روض الفرج - شارع الفسطاط',
      phones: ['(+20) 1220789797', '(+20) 1220789797'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,
              Row(
                children: [
                  const CustomBackButtonWidget(),
                  12.horizontalSpace,
                  Text('اتصل بنا', style: AppTextStyles.font18BlackExtraBoldHeader),
                ],
              ),
              12.verticalSpace,
              Text(
                'ماتترددش انك تكلمنا في أي وقت على أرقامنا أو تشرفنا في مكاتبنا',
                style: AppTextStyles.font12greyRegular,
              ),
              24.verticalSpace,

              // ── مكاتبنا في مصر ──
              Text('مكاتبنا في مصر', style: AppTextStyles.font16BlackBold),
              16.verticalSpace,
              ..._offices.map((o) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _OfficeCard(office: o),
                  )),

              12.verticalSpace,
              // ── تواصل معنا على ──
              Text('تواصل معنا على', style: AppTextStyles.font16BlackBold),
              16.verticalSpace,
              _ContactChannelsCard(),

              28.verticalSpace,
              // ── تابعنا على ──
              Text('تابعنا على', style: AppTextStyles.font16BlackBold),
              16.verticalSpace,
              const _SocialRow(),
              24.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

class _Office {
  final String name;
  final String address;
  final List<String> phones;
  const _Office({
    required this.name,
    required this.address,
    required this.phones,
  });
}

class _OfficeCard extends StatelessWidget {
  final _Office office;
  const _OfficeCard({required this.office});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: ShapeDecoration(
        color: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFF3E2D6)),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // عرض ↗ (يسار)
              InkWell(
                onTap: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.open_in_new,
                        size: 13.r, color: AppColors.orangeColor),
                    4.horizontalSpace,
                    Text(
                      'عرض',
                      style: TextStyle(
                        color: AppColors.orangeColor,
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // اسم المكتب + علامة الموقع (يمين)
              Flexible(
                child: Text(
                  office.name,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.blacksoft,
                    fontSize: 13.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              6.horizontalSpace,
              CustomImageHandler(
                AppImages.iconsMarker,
                width: 16.r,
                height: 16.r,
                color: AppColors.orangeColor,
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            office.address,
            textAlign: TextAlign.right,
            style: AppTextStyles.font12greyRegular,
          ),
          8.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              for (final p in office.phones) ...[
                Text(p, style: AppTextStyles.font12greyRegular),
                16.horizontalSpace,
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactChannelsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: ShapeDecoration(
        color: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFEFEFEF)),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _ContactRow(
            title: 'الموقع الرسمي',
            value: 'www.evex-eg.com/eg',
            iconBg: const Color(0xFFEAF4FF),
            icon: Icon(Icons.link, size: 18.r, color: const Color(0xFF2F80ED)),
          ),
          Divider(color: const Color(0xFFF0F0F0), height: 1.h),
          _ContactRow(
            title: 'البريد الالكتروني',
            value: 'evex-eg@evex.com',
            iconBg: const Color(0xFFFDECEC),
            icon: CustomImageHandler(
              AppImages.iconsEmail,
              width: 18.r,
              height: 18.r,
              color: const Color(0xFFEB5757),
            ),
          ),
          Divider(color: const Color(0xFFF0F0F0), height: 1.h),
          _ContactRow(
            title: 'الواتساب',
            value: '(+20) 1220789797',
            iconBg: const Color(0xFFE7F7EE),
            icon: CustomImageHandler(
              AppImages.iconsWhatsapp,
              width: 20.r,
              height: 20.r,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final String title;
  final String value;
  final Color iconBg;
  final Widget icon;
  const _ContactRow({
    required this.title,
    required this.value,
    required this.iconBg,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: icon,
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.blacksoft,
                    fontSize: 13.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                2.verticalSpace,
                Text(value, style: AppTextStyles.font12greyRegular),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _social(CustomImageHandler(AppImages.iconsSocialTelegram,
            width: 44.r, height: 44.r)),
        _social(CustomImageHandler(AppImages.iconsSocialYoutube,
            width: 44.r, height: 44.r)),
        _social(CustomImageHandler(AppImages.iconsSocialTiktok,
            width: 44.r, height: 44.r)),
        _social(
          SizedBox(
            width: 44.r,
            height: 44.r,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomImageHandler(AppImages.iconsSocialInstagramBg,
                    width: 44.r, height: 44.r),
                CustomImageHandler(AppImages.iconsSocialInstagramGlyph,
                    width: 26.r, height: 26.r),
              ],
            ),
          ),
        ),
        _social(CustomImageHandler(AppImages.iconsSocialFacebook,
            width: 44.r, height: 44.r)),
      ],
    );
  }

  Widget _social(Widget child) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(22.r),
          child: child,
        ),
      );
}
