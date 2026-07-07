import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/helpers/launcher_helper.dart';
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

/// Official website shown under "خدمة العملاء". Hardcoded for now — the API
/// doesn't return it yet; swap to a [ContactInfo] field once the backend adds it.
const String _officialWebsite = 'www.evexnow.com';

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
                          style: AppTextStyles.font14BlacksoftRegular.copyWith(
                            fontWeight: FontWeight.bold,
                              fontSize: 16.r

                          )),
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
                      const _SectionHeader('متواجدون في'),
                      16.verticalSpace,
                      ...state.branches.map((b) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: _OfficeCard(branch: b),
                          )),
                      12.verticalSpace,
                    ],

                    // ── تواصل معنا على ──
                    const _SectionHeader('تواصل معنا على'),
                    16.verticalSpace,
                    _ContactChannelsCard(info: state.contactInfo),

                    28.verticalSpace,
                    // ── تابعنا على ──
                    const _SectionHeader('تابعنا على'),
                    16.verticalSpace,
                    _SocialRow(info: state.contactInfo),
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

/// Small orange rounded bar shown before a header/title (matches Figma).
class _OrangeBar extends StatelessWidget {
  const _OrangeBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4.r,
      height: 18.r,
      decoration: ShapeDecoration(
        color: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }
}

/// Section header: an orange bar followed by a bold title.
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _OrangeBar(),
        8.horizontalSpace,
        Text(title, style: AppTextStyles.font14BlacksoftRegular.copyWith(
            fontWeight: FontWeight.bold,
          fontSize: 16.r
        )),
      ],
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
    final displayAddress = (addr == null || addr.isEmpty || addr == '.')
        ? [branch.governorate, branch.firstCity]
            .whereType<String>()
            .where((e) => e.trim().isNotEmpty)
            .join(' - ')
        : addr;
    Future<void> openLocation() async {
      final address = [branch.governorate, branch.firstCity, branch.address]
          .whereType<String>()
          .where((e) => e.trim().isNotEmpty && e != '.')
          .join(' ');
      await LauncherHelper.openMaps(gps: branch.gps, address: address);
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: ShapeDecoration(
        color: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.beige),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: AppColors.blackAlpha0F,
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
              // علامة الموقع داخل دائرة + اسم المكتب (يمين)
              Container(
                width: 30.r,
                height: 30.r,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primaryAlpha1A,
                  shape: BoxShape.circle,
                ),
                child: CustomImageHandler(
                  AppImages.iconsMarker,
                  width: 15.r,
                  height: 15.r,
                  color: AppColors.orangeColor,
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  branch.name ?? '',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.blacksoft,
                    fontSize: 15.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              8.horizontalSpace,
              // عرض ↗ (يسار)
              InkWell(
                onTap: () {
                  openLocation();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.open_in_new,
                        size: 14.r, color: AppColors.orangeColor),
                    4.horizontalSpace,
                    Text(
                      'عرض',
                      style: TextStyle(
                        color: AppColors.orangeColor,
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            displayAddress,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 13.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          if (branch.phones.isNotEmpty) ...[
            8.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (final p in branch.phones) ...[
                  Text(
                    p,
                    textDirection: TextDirection.ltr,
                    style: AppTextStyles.font12greyRegular,
                  ),
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
          side: const BorderSide(color: AppColors.fillGrey5),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _ContactRow(
            title: 'خدمة العملاء',
            value: info?.phoneNumber ?? '-',
            // Phone is the key number here — show it a touch bigger & darker.
            // valueStyle: TextStyle(
            //   color: AppColors.blacksoft,
            //   fontSize: 15.r,
            //   fontFamily: 'Almarai',
            //   fontWeight: FontWeight.w700,
            // ),
            iconBg: AppColors.blueBg1,
            icon: Icon(Icons.phone_outlined,
                size: 18.r, color: AppColors.blue1),
            onTap: () => LauncherHelper.call(info?.phoneNumber),
          ),
          Divider(color: AppColors.fillGrey1, height: 1.h),
          // الموقع الرسمي — ثابت مؤقتًا لحد ما الباك يرجّعه في الـ API.
          // TODO(backend): replace the static URL with a ContactInfo field.
          _ContactRow(
            title: 'الموقع الرسمي',
            value: _officialWebsite,
            iconBg: AppColors.blueBg2,
            icon: Icon(Icons.link_rounded, size: 20.r, color: AppColors.blue3),
            onTap: () => LauncherHelper.openUrl('https://$_officialWebsite'),
          ),
          Divider(color: AppColors.fillGrey1, height: 1.h),
          _ContactRow(
            title: 'البريد الالكتروني',
            value: info?.email ?? '-',
            iconBg: AppColors.redBg,
            icon: CustomImageHandler(
              AppImages.iconsEmail,
              width: 18.r,
              height: 18.r,
              color: AppColors.red4,
            ),
            onTap: () => LauncherHelper.email(info?.email),
          ),
          Divider(color: AppColors.fillGrey1, height: 1.h),
          _ContactRow(
            title: 'الواتساب',
            value: info?.whatsappNumber ?? '-',
            iconBg: AppColors.greenBg1,
            icon: CustomImageHandler(
              AppImages.iconsWhatsapp,
              width: 20.r,
              height: 20.r,
            ),
            onTap: () => LauncherHelper.whatsApp(info?.whatsappNumber),
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
  final VoidCallback? onTap;

  /// Optional override for the value's text style (e.g. a bigger phone number).
  final TextStyle? valueStyle;
  const _ContactRow({
    required this.title,
    required this.value,
    required this.iconBg,
    required this.icon,
    this.onTap,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
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
                    fontSize: 14.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                2.verticalSpace,
                Text(
                  value,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: valueStyle ?? AppTextStyles.font12greyRegular,
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  final ContactInfo? info;
  const _SocialRow({required this.info});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // No telegram link in the API; falls back to the X account.
        // _social(
        //   CustomImageHandler(AppImages.iconsSocialTelegram,
        //       width: 44.r, height: 44.r),
        //   info?.xAccount,
        // ),
        _social(
          CustomImageHandler(AppImages.iconsSocialYoutube,
              width: 44.r, height: 44.r),
          info?.youtube,
        ),
        _social(
          CustomImageHandler(AppImages.iconsSocialTiktok,
              width: 44.r, height: 44.r),
          info?.tiktok,
        ),
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
          info?.instagram,
        ),
        _social(
          CustomImageHandler(AppImages.iconsSocialFacebook,
              width: 44.r, height: 44.r),
          info?.facebook,
        ),
      ],
    );
  }

  Widget _social(Widget child, String? url) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: InkWell(
          onTap: () => LauncherHelper.openUrl(url),
          borderRadius: BorderRadius.circular(22.r),
          child: child,
        ),
      );
}
