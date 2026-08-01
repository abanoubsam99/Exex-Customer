import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/empty_list_widget.dart';
import 'package:evex_user/core/ui/widgets/special_offers_carousel.dart';
import 'package:evex_user/data/cubits/direct_services/direct_services_list_cubit.dart';
import 'package:evex_user/data/cubits/direct_services/direct_services_list_state.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/cubits/home/home_state.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// شاشة قائمة "الخدمات المباشرة" (مسار الدفع المباشر).
class DirectServicesListScreen extends StatelessWidget {
  const DirectServicesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              context.read<DirectServicesListCubit>().loadPorts(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                16.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const CustomBackButtonWidget(),
                        12.horizontalSpace,
                        Text(
                          'الخدمات المباشرة',
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
                    // Selected category / port-type name (e.g. "اتيليه فساتين")
                    // — mirrors the Figma subtitle. Hidden when nothing was
                    // selected (e.g. opened from a deep link).
                    BlocSelector<HomeCubit, HomeState, String>(
                      selector: _selectedTypeName,
                      builder: (context, name) => name.isEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Text(
                                name,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w600,
                                  height: 1.6,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              16.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: const _CashbackBanner(),
              ),
              20.verticalSpace,
              BlocBuilder<DirectServicesListCubit, DirectServicesListState>(
                buildWhen: (p, c) => p.specialOffers != c.specialOffers,
                builder: (context, state) =>
                    SpecialOffersCarousel(offers: state.specialOffers),
              ),
              20.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: BlocBuilder<DirectServicesListCubit,
                    DirectServicesListState>(
                  builder: (context, state) {
                    final items = state.portsModel?.items ?? const <Item>[];
                    if (state.isLoading && items.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (items.isEmpty) {
                      return const EmptyListWidget(
                        message: 'لا توجد نتائج متاحة',
                        icon: Icons.search_off,
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => 12.verticalSpace,
                      itemBuilder: (context, index) =>
                          _PortListItem(item: items[index], index: index),
                    );
                  },
                ),
              ),
              24.verticalSpace,
            ],
          ),
          ),
        ),
      ),
    );
  }
}

/// كارت بوابة في القائمة: صورة بعليها بادج "+N صوره" + اسم + وصف.
class _PortListItem extends StatelessWidget {
  final Item item;
  final int index;
  const _PortListItem({required this.item, required this.index});

  // Image dimensions and how far it overlaps the panel — estimated from the
  // Figma screenshot (exact specs unavailable: Figma API was rate-limited).
  static const double _imageW = 120;
  static const double _imageH = 140;
  static const double _panelH = 116;
  static const double _overlap = 16;

  @override
  Widget build(BuildContext context) {
    // Figma: the first card shows the image on the right, then alternates.
    final imageRight = index % 2 == 0;

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        width: _imageW.w,
        height: _imageH.h,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomImageHandler(
                _firstImageUrl(item),
                smartFill: true,
              ),
            ),
            // Positioned(
            //   bottom: 8.h,
            //   left: 8.w,
            //   right: 8.w,
            //   child: _imagesBadge(item),
            // ),
          ],
        ),
      ),
    );

    // The panel slides under the image by [_overlap]; its text is padded on
    // that side so it stays clear of the floating image.
    final imageSidePad = (_overlap + 14).w;

    return GestureDetector(
      onTap: () => NavigationHelper.pushNamed(
        Routes.directServiceDetailsScreen,
        arguments: item,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final panel = Container(
            width: constraints.maxWidth - _imageW.w + _overlap.w,
            height: _panelH.h,
            decoration: ShapeDecoration(
              color: AppColors.fillGrey2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            padding: EdgeInsets.only(
              top: 14.h,
              bottom: 14.h,
              right: imageRight ? imageSidePad : 14.w,
              left: imageRight ? 14.w : imageSidePad,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Name + rating (stars shown even when the backend rate is 0).
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.portName ?? '',
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.blacksoft,
                          fontSize: 15.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.24,
                        ),
                      ),
                    ),
                    CustomImageHandler(
                      AppImages.iconsStar,
                      height: 20.r,
                      width: 20.r,
                    ),
                    2.horizontalSpace,
                    Text(
                      '${item.rate ?? 0}',
                      style: TextStyle(
                        color: AppColors.blacksoft,
                        fontSize: 12.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ],
                ),
                6.verticalSpace,
                Text(
                  _subtitle(item),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.grey2,
                    fontSize: 12.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                8.verticalSpace,
                // Starting price (cheapest service) — shown like the instant cards.
                Text.rich(
                  textAlign: TextAlign.right,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'يبدأ بـ ',
                        style: TextStyle(
                          color: const Color(0xFF2C262C),
                          fontSize: 12.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.24,
                        ),
                      ),
                      TextSpan(
                        text: '${item.cheapestServicePrice ?? '—'}',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 16.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: ' جنيه',
                        style: TextStyle(
                          color: AppColors.blueGrey,
                          fontSize: 11.r,
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

          return SizedBox(
            height: _imageH.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment:
                      imageRight ? Alignment.centerLeft : Alignment.centerRight,
                  child: panel,
                ),
                Align(
                  alignment:
                      imageRight ? Alignment.centerRight : Alignment.centerLeft,
                  child: image,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _imagesBadge(Item item) {
    final count = _portImages(item).length;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.image_outlined,
            size: 14.r,
            color: AppColors.primaryColor,
          ),
          4.horizontalSpace,
          Text(
            '+$count صوره',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 11.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// بانر الكاش باك أعلى شاشة الخدمات المباشرة: دايرة برتقالية فيها علامة "$"
/// على الشمال + سطرين "اللي هتدفعه كاش / هيرجعلك عليه كاش باك" على اليمين.
class _CashbackBanner extends StatelessWidget {
  const _CashbackBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.primaryColor),
      ),
      // RTL: text first (right side), coin badge last (far left) — matching the
      // design where the "$" circle sits on the left of the banner.
      child: Row(
        children: [
          // Orange coin badge with a cash "$" glyph.
          Container(
            width: 40.r,
            height: 40.r,
            decoration:  BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(topRight:Radius.circular(13.r),bottomRight: Radius.circular(13.r))
            ),
            alignment: Alignment.center,
            child: Text("\$",
              style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 26.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w400,
              // letterSpacing: -0.24,
            ), )
          ),
          12.horizontalSpace,
          Expanded(
            child: Text(
              'اللي هتدفعه كاش , هيرجعلك عليه كاش باك',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.descriptionText,
                fontSize: 12.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w800,
                letterSpacing: -0.24,
              ),
            ),
          ),

        ],
      ),
    );
  }
}

/// The selected direct-service category / port-type name shown under the title
/// (the port type takes precedence over the category), or '' when none.
String _selectedTypeName(HomeState s) {
  final t = s.selectedPaymentPortType;
  final c = s.selectedPaymentPort;
  return (t?.nameAr ?? t?.nameEn ?? c?.nameAr ?? c?.nameEn ?? '').trim();
}

List<String> _portImages(Item item) {
  final main = item.theMainImageFileName?.trim();
  return (main != null && main.isNotEmpty) ? [main] : const [];
}

String? _firstImageUrl(Item item) {
  final main = item.theMainImageFileName?.trim();
  if (main == null || main.isEmpty) return null;
  return ImageUrlHelper.full(main);
}

String _subtitle(Item item) {
  final desc = item.portDescription?.toString().trim();
  if (desc != null && desc.isNotEmpty) return desc;
  return [item.governorate, item.city]
      .where((e) => e != null && e.isNotEmpty)
      .join('، ');
}
