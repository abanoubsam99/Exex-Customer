import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/section_seperator.dart';
import 'package:evex_user/data/cubits/direct_services/direct_service_details_cubit.dart';
import 'package:evex_user/data/cubits/direct_services/direct_service_details_state.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/other_service_card_item.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/service_details_bottom_sheet.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/service_top_part.dart'
    show SocialNavButton;
import 'package:evex_user/features/direct_services/ui/widgets/direct_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:evex_user/core/theme/app_colors.dart';

const _orange = AppColors.primaryColor;

/// شاشة تفاصيل خدمة الدفع المباشر (نقاط + كاش باك + طريقة الاستخدام).
class DirectServiceDetailsScreen extends StatelessWidget {
  const DirectServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final port = context.read<DirectServiceDetailsCubit>().port;
    final desc = port?.portDescription?.toString().trim();
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => context.read<DirectServiceDetailsCubit>().loadData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DirectDetailsHeader(port: port),
            16.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                (desc != null && desc.isNotEmpty)
                    ? desc
                    : 'لا يوجد وصف متاح لهذه الخدمة',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.grey2,
                  fontSize: 13.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                  height: 1.54,
                ),
              ),
            ),
            20.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: const _ProductsSection(),
            ),
            22.verticalSpace,
            const SectionSeperator(),
            22.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: const _PointsSection(),
            ),
            22.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: const _HowToUseSection(),
            ),
            16.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _HelpRow(port: port),
            ),
            22.verticalSpace,
            const SectionSeperator(),
            22.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: const _OtherServicesSection(),
            ),
            32.verticalSpace,
          ],
        ),
      ),
      ),
    );
  }
}

// ─────────────────────────── Header ───────────────────────────
class _DirectDetailsHeader extends StatefulWidget {
  final Item? port;
  const _DirectDetailsHeader({this.port});

  @override
  State<_DirectDetailsHeader> createState() => _DirectDetailsHeaderState();
}

class _DirectDetailsHeaderState extends State<_DirectDetailsHeader> {
  final PageController _controller = PageController();
  int _active = 0;

  List<String> get _images {
    final imgs = widget.port?.portImages;
    if (imgs is List) {
      return imgs
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList();
    }
    return const [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openContact() {
    NavigationHelper.pushNamed(
      Routes.contactInfoScreen,
      arguments: widget.port,
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = _images;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 283.h,
          width: 1.sw,
          child: images.isEmpty
              ? CustomImageHandler(AppImages.imagesWedding5, fit: BoxFit.cover)
              : PageView.builder(
                  controller: _controller,
                  itemCount: images.length,
                  onPageChanged: (i) => setState(() => _active = i),
                  itemBuilder: (_, i) => CustomImageHandler(
                    ImageUrlHelper.full(images[i]) ?? AppImages.imagesWedding5,
                    fit: BoxFit.cover,
                    errorIcon: const Icon(Icons.broken_image_outlined),
                  ),
                ),
        ),
        // تدرّج أبيض تحت عشان الاسم يبان
        Container(
          width: 1.sw,
          height: 60.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.white,
                Colors.white.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              child: Row(
                children: [
                  SocialNavButton(
                    height: 36.r,
                    width: 36.r,
                    icon: AppImages.iconsChevronRightSolid,
                    onTap: () => NavigationHelper.pop(),
                  ),
                  const Spacer(),
                  SocialNavButton(icon: AppImages.iconsHeart, onTap: () {}),
                  6.horizontalSpace,
                  SocialNavButton(
                    icon: AppImages.iconsMarker,
                    onTap: _openContact,
                  ),
                  6.horizontalSpace,
                  SocialNavButton(
                    icon: AppImages.iconsPhone2,
                    onTap: _openContact,
                  ),
                  6.horizontalSpace,
                  SocialNavButton(icon: AppImages.iconsFolder, onTap: () {}),
                  6.horizontalSpace,
                  SocialNavButton(icon: AppImages.iconsShare, onTap: () {}),
                ],
              ),
            ),
          ),
        ),
        if (images.length > 1)
          Positioned(
            bottom: 38.h,
            child: AnimatedSmoothIndicator(
              activeIndex: _active,
              count: images.length,
              textDirection: TextDirection.ltr,
              effect: ExpandingDotsEffect(
                dotHeight: 8.r,
                dotWidth: 8.r,
                expansionFactor: 2,
                activeDotColor: _orange,
                dotColor: AppColors.dividerGrey,
              ),
            ),
          ),
        Positioned(
          bottom: -10.h,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.port?.portName ?? '',
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.blacksoft,
                      fontSize: 20.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.24,
                    ),
                  ),
                ),
                CustomImageHandler(
                  AppImages.iconsStar,
                  height: 26.r,
                  width: 26.r,
                ),
                4.horizontalSpace,
                Text(
                  '${widget.port?.rate ?? 0}',
                  style: TextStyle(
                    color: AppColors.blacksoft,
                    fontSize: 14.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────── Section header ───────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  const _SectionHeader(this.title, {this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
              title,
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
        if (subtitle != null) ...[
          8.verticalSpace,
          Text(
            subtitle!,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 12.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────── Products ───────────────────────────
class _ProductsSection extends StatelessWidget {
  const _ProductsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader('المنتجات والخدمات'),
        12.verticalSpace,
        BlocBuilder<DirectServiceDetailsCubit, DirectServiceDetailsState>(
          builder: (context, state) {
            if (state.isLoading && state.services.isEmpty) {
              return SizedBox(
                height: 180.h,
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            if (state.services.isEmpty) {
              return SizedBox(
                height: 80.h,
                child: Center(
                  child: Text(
                    'لا توجد منتجات متاحة',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 13.r,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
              );
            }
            return SizedBox(
              height: 190.h,
              child: ListView.separated(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemCount: state.services.length,
                separatorBuilder: (_, __) => 16.horizontalSpace,
                itemBuilder: (context, index) {
                  final service = state.services[index];
                  return DirectProductCard(
                    service: service,
                    onTap: () =>
                        ServiceDetailsBottomSheet.show(context, service),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────── Points ───────────────────────────
class _PointsSection extends StatelessWidget {
  const _PointsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DirectServiceDetailsCubit, DirectServiceDetailsState>(
      buildWhen: (p, c) => p.wallet != c.wallet,
      builder: (context, state) {
        final points = state.wallet?.numberOfPoints ?? 0;
        final value = state.wallet?.pointsValue ?? 0;
        return Row(
          children: [
            Expanded(
              child: _pointsCard(
                bg: AppColors.primaryAlpha1A,
                title: 'نقاطك الحالية',
                value: '$points',
                unit: 'نقطه',
                valueColor: _orange,
                icon: const Icon(Icons.star, color: _orange, size: 18),
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: _pointsCard(
                bg: AppColors.green2Alpha1A,
                title: 'قيمة النقاط',
                value: '$value',
                unit: 'جنيه',
                valueColor: AppColors.green2,
                icon: const Icon(
                  Icons.monetization_on,
                  color: AppColors.green2,
                  size: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _pointsCard({
    required Color bg,
    required String title,
    required String value,
    required String unit,
    required Color valueColor,
    required Widget icon,
  }) {
    return Container(
      height: 78.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              6.horizontalSpace,
              Text(
                title,
                style: TextStyle(
                  color: AppColors.blacksoft,
                  fontSize: 13.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          6.verticalSpace,
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$value ',
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 18.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: unit,
                  style: TextStyle(
                    color: AppColors.blueGrey,
                    fontSize: 12.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── How to use ───────────────────────────
class _HowToUseSection extends StatelessWidget {
  const _HowToUseSection();

  static const _steps = [
    'ادخل على محفظة evex لتعيين كلمة المرور الخاصة بك اضغط هنا',
    'اذهب للتاجر وقم باختيار مشترياتك او الخدمات المراد الحصول عليها',
    'يعطيك التاجر هاتفه لتكتب كلمة السر الخاصة بك بسرية تامة (حافظ على خصوصية تلك الخطوة)',
    'تخصم قيمة نقاطك الحالية من اصل المبلغ المطلوب دفعه نقداً للتاجر',
    'يصلك فوراً نقاط جديدة (كاش باك) في محفظتك على المبلغ المدفوع نقداً للتاجر',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          'طريقة الاستخدام',
          subtitle:
              'للإستفادة بنقاطك والحصول على كاش باك على سعر المنتج او الخدمة عند الدفع نقداً للتاجر',
        ),
        12.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: AppColors.boarderColor),
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < _steps.length; i++) ...[
                if (i > 0) 12.verticalSpace,
                Text(
                  '${i + 1}- ${_steps[i]}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w400,
                    height: 1.7,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────── Help row ───────────────────────────
class _HelpRow extends StatelessWidget {
  final Item? port;
  const _HelpRow({this.port});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'للمساعدة والاستفسار',
          style: TextStyle(
            color: AppColors.blacksoft,
            fontSize: 14.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
          ),
        ),
        6.horizontalSpace,
        GestureDetector(
          onTap: () => NavigationHelper.pushNamed(
            Routes.contactInfoScreen,
            arguments: port,
          ),
          child: Text(
            'اتصل بنا',
            style: TextStyle(
              color: _orange,
              fontSize: 14.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────── Other services ───────────────────────────
class _OtherServicesSection extends StatelessWidget {
  const _OtherServicesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          'خدمات أخرى',
          subtitle: 'مُقدمه من نفس التاجر أو مقدم الخدمة',
        ),
        12.verticalSpace,
        BlocBuilder<DirectServiceDetailsCubit, DirectServiceDetailsState>(
          buildWhen: (p, c) => p.services != c.services,
          builder: (context, state) {
            if (state.services.isEmpty) return const SizedBox.shrink();
            return SizedBox(
              height: 150.h,
              child: ListView.separated(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemCount: state.services.length,
                separatorBuilder: (_, __) => 16.horizontalSpace,
                itemBuilder: (context, index) {
                  final service = state.services[index];
                  return OtherServiceCardItem(
                    images: service.serviceImages ?? const [],
                    title: service.name ?? '',
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
