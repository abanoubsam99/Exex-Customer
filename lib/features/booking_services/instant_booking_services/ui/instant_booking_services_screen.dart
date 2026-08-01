import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/helpers/auth_guard.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/empty_list_widget.dart';
import 'package:evex_user/core/ui/widgets/load_more_listener.dart';
import 'package:evex_user/core/ui/widgets/special_offers_carousel.dart';
import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/data/cubits/booking_services/instant_booking/instant_booking_cubit.dart';
import 'package:evex_user/data/cubits/booking_services/instant_booking/instant_booking_state.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/cubits/home/home_state.dart';
import 'package:evex_user/data/cubits/ports_filter/ports_filter_cubit.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/features/booking_services/instant_booking_services/ui/widgets/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/custom_bottom_sheet.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class InstantBookingServicesScreen extends StatelessWidget {
  const InstantBookingServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => context.read<InstantBookingCubit>().loadPorts(),
        child: LoadMoreListener(
          onLoadMore: () => context.read<InstantBookingCubit>().loadMorePorts(),
          child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              60.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CustomBackButtonWidget(),
                        12.horizontalSpace,
                        Text(
                          'خدمات الحجز الفوري',
                          textAlign: TextAlign.right,
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
                    // Text(
                    //   'دلوقتي ولأول مرة في مصر, عرفنا تاريخ مناسبتك وهنعرفك فوراً الخدمات المتاحة للحجز',
                    //   textAlign: TextAlign.right,
                    //   style: TextStyle(
                    //     color: AppColors.grey,
                    //     fontSize: 13.r,
                    //     fontFamily: 'Almarai',
                    //     fontWeight: FontWeight.w400,
                    //     height: 1.69,
                    //   ),
                    // ),
                    // Selected category / port-type name (e.g. "قاعة اون اير")
                    // picked on home — shown above the filter, like the design.
                    BlocSelector<HomeCubit, HomeState, String>(
                      selector: _selectedBookingTypeName,
                      builder: (context, name) => name.isEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  name,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16.r,
                                    fontFamily: 'Almarai',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    Row(
                      children: [
                        Text(
                          "اكتب تاريخ مناسبتك واعرف الخدمات المتاحه حالاً ..",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: AppColors.descriptionText,
                            fontSize: 12.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    16.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          // Picking the occasion date is a logged-in-only action,
                          // but guests see it at full opacity (no dimming/blur) —
                          // they just get a login prompt on tap via onBeforePick.
                          // Show the session date so it survives leaving and
                          // re-entering the screen.
                          child: BlocSelector<HomeCubit, HomeState, DateTime?>(
                            selector: (s) => s.bookingDate,
                            builder: (context, sessionDate) => DatePicker(
                              title: 'تاريخ المناسبة',
                              initialDate: sessionDate,
                              onBeforePick: () =>
                                  AuthGuard.requireLogin(context),
                              onChanged: (date) {
                                context
                                    .read<InstantBookingCubit>()
                                    .setDate(date);
                                context.read<HomeCubit>().setBookingDate(date);
                              },
                            ),
                          ),
                        ),
                        12.horizontalSpace,
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                    value: context.read<InstantBookingCubit>(),
                                  ),
                                  // Reuse the screen-scoped cubit so the sheet
                                  // reopens with the user's last filter draft.
                                  BlocProvider.value(
                                    value: context.read<PortsFilterCubit>(),
                                  ),
                                ],
                                child: const CustomBottomSheet(),
                              ),
                            );
                          },
                          child: Container(
                            // padding: const EdgeInsets.all(8),
                            height: 46.r,
                            width: 46.r,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: AppColors.primaryColor,
                            ),
                            child: Center(
                              child: CustomImageHandler(
                                AppImages.iconsSliders,
                                height: 24.r,
                                width: 24.r,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    26.verticalSpace,
                  ],
                ),
              ),
              BlocBuilder<InstantBookingCubit, InstantBookingState>(
                buildWhen: (p, c) => p.specialOffers != c.specialOffers,
                builder: (context, state) =>
                    SpecialOffersCarousel(offers: state.specialOffers),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: BlocBuilder<InstantBookingCubit, InstantBookingState>(
                  builder: (context, state) {
                    final items = state.portsModel?.items ?? const [];
                    if (state.isLoading && items.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
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
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: () => NavigationHelper.pushNamed(
                            Routes.bookingServiceDetailsScreen,
                            arguments: item,
                          ),
                          child: Directionality(
                            textDirection: index % 2 == 1
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: SizedBox(
                                    width: 113.w,
                                    height: 137.h,
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: CustomImageHandler(
                                            _portImageUrl(item),
                                            smartFill: true,
                                          ),
                                        ),
                                        // Positioned(
                                        //   bottom: 8.h,
                                        //   left: 8.w,
                                        //   child: _imagesBadge(item),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 89.h,
                                    decoration: ShapeDecoration(
                                      color: AppColors.dividerGreyAlpha33,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: index % 2 == 1
                                            ? BorderRadius.only(
                                                topRight: Radius.circular(16.r),
                                                bottomRight:
                                                    Radius.circular(16.r),
                                              )
                                            : BorderRadius.only(
                                                topLeft: Radius.circular(16.r),
                                                bottomLeft:
                                                    Radius.circular(16.r),
                                              ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 4.h,
                                      ),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    item.portName ?? '',
                                                    textAlign: TextAlign.right,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.blacksoft,
                                                      fontSize: 15.r,
                                                      fontFamily: 'Almarai',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      letterSpacing: -0.24,
                                                    ),
                                                  ),
                                                ),
                                                CustomImageHandler(
                                                  AppImages.iconsStar,
                                                  height: 24.r,
                                                  width: 24.r,
                                                ),
                                                Text(
                                                  '${item.rate ?? 0}',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.blacksoft,
                                                    fontSize: 12.r,
                                                    fontFamily: 'Almarai',
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.33,
                                                    letterSpacing: -0.24,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Text(
                                                _portSubtitle(item),
                                                textAlign: TextAlign.right,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: AppColors.grey2,
                                                  fontSize: 12.r,
                                                  fontFamily: 'Almarai',
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.33,
                                                  letterSpacing: -0.24.w,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Spacer(),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'يبدأ بـ ',
                                                        style: TextStyle(
                                                          color: const Color(
                                                            0xFF2C262C,
                                                          ),
                                                          fontSize: 12.r,
                                                          fontFamily: 'Almarai',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.25,
                                                          letterSpacing: -0.24,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${item.cheapestServicePrice ?? '—'}',
                                                        style: TextStyle(
                                                          color: const Color(
                                                            0xFFF38B4A,
                                                          ),
                                                          fontSize: 16.r,
                                                          fontFamily: 'Almarai',
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          height: 1.50,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: ' جنيه',
                                                        style: TextStyle(
                                                          color: const Color(
                                                            0xFF6F767E,
                                                          ),
                                                          fontSize: 11.r,
                                                          fontFamily: 'Almarai',
                                                          fontWeight:
                                                              FontWeight.w400,
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
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => 8.verticalSpace,
                    );
                  },
                ),
              ),
              // Footer spinner while the next page of ports loads.
              BlocBuilder<InstantBookingCubit, InstantBookingState>(
                buildWhen: (p, c) => p.isLoadingMore != c.isLoadingMore,
                builder: (context, state) => state.isLoadingMore
                    ? const PaginationLoader()
                    : const SizedBox.shrink(),
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

/// Builds a full image URL for a port if it has a main image, otherwise null
/// (the caller falls back to a placeholder asset).
String? _portImageUrl(Item item) {
  final main = item.theMainImageFileName?.trim();
  if (main != null && main.isNotEmpty) {
    return ImageUrlHelper.full(main);
  }
  return null;
}

/// Number of images the port has (for the "+N صوره" badge).
int _portImagesCount(Item item) {
  final main = item.theMainImageFileName?.trim();
  return (main != null && main.isNotEmpty) ? 1 : 0;
}

/// "+N صوره" pill shown on the port card image (hidden when there are none).
Widget _imagesBadge(Item item) {
  final count = _portImagesCount(item);
  if (count <= 0) return const SizedBox.shrink();
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.image_outlined, size: 14.r, color: AppColors.primaryColor),
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

/// The selected instant-booking category / port-type name shown under the
/// header (the port type takes precedence over the category), or '' when none.
String _selectedBookingTypeName(HomeState s) {
  final t = s.selectedBookingPortType;
  final c = s.selectedBookingPort;
  return (t?.nameAr ?? t?.nameEn ?? c?.nameAr ?? c?.nameEn ?? '').trim();
}

/// Subtitle line for a port card: its description, or its location as a fallback.
String _portSubtitle(Item item) {
  final desc = item.portDescription?.toString().trim();
  if (desc != null && desc.isNotEmpty) return desc;
  return [item.governorate, item.city]
      .where((e) => e != null && e.isNotEmpty)
      .join('، ');
}

// The special-offers banner + its painters now live in the shared
// [SpecialOffersCarousel] widget (core/ui/widgets/special_offers_carousel.dart).
