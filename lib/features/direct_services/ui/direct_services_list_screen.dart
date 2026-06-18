import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
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
                    8.verticalSpace,
                    Text(
                      'دلوقتي تقدر تستخدم نقاطك وتستفيد بكاش باك على كل '
                      'مشترياتك من تجار evex',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              16.verticalSpace,
              const _TypeTabs(),
              18.verticalSpace,
              const _PromoBanner(),
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
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Text(
                          'لا توجد نتائج متاحة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 14.r,
                            fontFamily: 'Almarai',
                          ),
                        ),
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

/// Tabs بأنواع الخدمة (القاعات/فوتوغرافر/...). الضغط بيعيد فلترة القائمة.
class _TypeTabs extends StatelessWidget {
  const _TypeTabs();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final types = state.selectedPaymentPort?.portTypeDtos ?? const [];
        if (types.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 34.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemCount: types.length,
            separatorBuilder: (_, __) => 10.horizontalSpace,
            itemBuilder: (context, index) {
              final type = types[index];
              final isSelected = state.selectedPaymentPortType?.id == type.id;
              return Center(
                child: GestureDetector(
                  onTap: () {
                    context.read<HomeCubit>().selectPaymentPortType(type);
                    context
                        .read<DirectServicesListCubit>()
                        .changeType(type.id);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 18.w),
                    decoration: ShapeDecoration(
                      color: isSelected ? AppColors.blacksoft : Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1.5,
                          color: AppColors.blacksoft,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      type.nameAr ?? type.nameEn ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.blacksoft,
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// بانر "عروض مميزة" — أول عرض مميز للنوع المختار من
/// `GetAllServicesByClient?specialOffer=true&portTypeId=...`. يختفي لو مفيش عروض.
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DirectServicesListCubit, DirectServicesListState>(
      buildWhen: (p, c) => p.specialOffers != c.specialOffers,
      builder: (context, state) {
        if (state.specialOffers.isEmpty) return const SizedBox.shrink();
        final offer = state.specialOffers.first;
        final imageUrl = offer.serviceImages.isNotEmpty
            ? ImageUrlHelper.full(offer.serviceImages.first)
            : null;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: GestureDetector(
            onTap: () => NavigationHelper.pushNamed(
              Routes.bookingServiceDetailsScreen,
              arguments: offer,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: SizedBox(
                height: 140.h,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomImageHandler(imageUrl, fit: BoxFit.cover),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            Colors.black.withValues(alpha: 0.0),
                            Colors.black.withValues(alpha: 0.55),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16.w,
                      bottom: 20.h,
                      child: SizedBox(
                        width: 220.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              offer.name,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            4.verticalSpace,
                            Text(
                              offer.details,
                              textAlign: TextAlign.right,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12.w,
                      bottom: 16.h,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Text(
                          'عروض مميزة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 8.h,
              left: 8.w,
              right: 8.w,
              child: _imagesBadge(item),
            ),
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
                Text(
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
                8.verticalSpace,
                Text(
                  _subtitle(item),
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.grey2,
                    fontSize: 12.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
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

List<String> _portImages(Item item) {
  final imgs = item.portImages;
  if (imgs is List) {
    return imgs
        .map((e) => e.toString())
        .where((e) => e.trim().isNotEmpty)
        .toList();
  }
  return const [];
}

String? _firstImageUrl(Item item) {
  final imgs = _portImages(item);
  if (imgs.isEmpty) return null;
  return ImageUrlHelper.full(imgs.first);
}

String _subtitle(Item item) {
  final desc = item.portDescription?.toString().trim();
  if (desc != null && desc.isNotEmpty) return desc;
  return [item.governorate, item.city]
      .where((e) => e != null && e.isNotEmpty)
      .join('، ');
}
