import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/theme/app_text_styles.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/cubits/contact_us/contact_us_cubit.dart';
import 'package:evex_user/data/cubits/contact_us/contact_us_state.dart';
import 'package:evex_user/data/models/branch.dart';
import 'package:evex_user/data/models/contact_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "Contact us" screen — offices + contact channels + social media,
/// fed from the contact-us APIs.
class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: BlocBuilder<ContactUsCubit, ContactUsState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.verticalSpace,
                  Row(
                    children: [
                      const CustomBackButtonWidget(),
                      12.horizontalSpace,
                      Text('اتصل بنا',
                          style: AppTextStyles.font18BlackExtraBoldHeader),
                    ],
                  ),
                  12.verticalSpace,
                  Text(
                    'ماتترددش انك تكلمنا في أي وقت على أرقامنا أو تشرفنا في مكاتبنا',
                    style: AppTextStyles.font12greyRegular,
                  ),
                  24.verticalSpace,
                  if (state.isLoading && state.contactInfo == null)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 80.h),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  else ...[
                    // ── مكاتبنا في مصر ──
                    if (state.branches.isNotEmpty) ...[
                      Text('مكاتبنا في مصر',
                          style: AppTextStyles.font16BlackBold),
                      16.verticalSpace,
                      ...state.branches.map((b) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: _OfficeCard(branch: b),
                          )),
                      12.verticalSpace,
                    ],

                    // ── تواصل معنا على ──
                    Text('تواصل معنا على', style: AppTextStyles.font16BlackBold),
                    16.verticalSpace,
                    _ContactChannelsCard(info: state.contactInfo),

                    28.verticalSpace,
                    // ── تابعنا على ──
                    Text('تابعنا على', style: AppTextStyles.font16BlackBold),
                    16.verticalSpace,
                    const _SocialRow(),
                    24.verticalSpace,
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OfficeCard extends StatelessWidget {
  final Branch branch;
  const _OfficeCard({required this.branch});

  @override
  Widget build(BuildContext context) {
    // The address is sometimes empty or just ".", fall back to the governorate.
    final addr = branch.address?.trim();
    final displayAddress =
        (addr == null || addr.isEmpty || addr == '.') ? (branch.governorate ?? '') : addr;
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
                  branch.name ?? '',
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
            displayAddress,
            textAlign: TextAlign.right,
            style: AppTextStyles.font12greyRegular,
          ),
          if (branch.phones.isNotEmpty) ...[
            8.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (final p in branch.phones) ...[
                  Text(p,
                      textDirection: TextDirection.ltr,
                      style: AppTextStyles.font12greyRegular),
                  16.horizontalSpace,
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ContactChannelsCard extends StatelessWidget {
  final ContactInfo? info;
  const _ContactChannelsCard({required this.info});

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
            title: 'الهاتف',
            value: info?.phoneNumber ?? '-',
            iconBg: const Color(0xFFEAF4FF),
            icon: Icon(Icons.phone_outlined,
                size: 18.r, color: const Color(0xFF2F80ED)),
          ),
          Divider(color: const Color(0xFFF0F0F0), height: 1.h),
          _ContactRow(
            title: 'البريد الالكتروني',
            value: info?.email ?? '-',
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
            value: info?.whatsappNumber ?? '-',
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
                Text(
                  value,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: AppTextStyles.font12greyRegular,
                ),
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
