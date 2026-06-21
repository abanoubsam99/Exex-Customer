// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_deep_link.dart';
import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/core/helpers/launcher_helper.dart';
import 'package:evex_user/core/ui/helpers/auth_guard.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:evex_user/data/cubits/booking_services/booking_service_details/booking_service_details_cubit.dart';
import 'package:evex_user/data/cubits/booking_services/booking_service_details/booking_service_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class ServiceTopPart extends StatefulWidget {
  const ServiceTopPart({super.key});

  @override
  State<ServiceTopPart> createState() => _ServiceTopPartState();
}

class _ServiceTopPartState extends State<ServiceTopPart> {
  int activeIndex = 0;

  /// Calls the port's phone number.
  Future<void> _callPort() async {
    final phone = context
        .read<BookingServiceDetailsCubit>()
        .state
        .port
        ?.phoneNumber1
        ?.trim();
    if (phone == null || phone.isEmpty) {
      ToastManager.showError('رقم الهاتف غير متاح');
      return;
    }
    await LauncherHelper.call(phone);
  }

  /// Opens the port's location on the maps app (GPS, else the address text).
  Future<void> _openLocation() async {
    final port = context.read<BookingServiceDetailsCubit>().state.port;
    final address = [port?.governorate, port?.city, port?.address]
        .whereType<String>()
        .where((e) => e.trim().isNotEmpty)
        .join(' ');
    await LauncherHelper.openMaps(gps: port?.gps, address: address);
  }

  /// Shares the port (name + deep link) via the system share sheet.
  Future<void> _sharePort() async {
    final cubit = context.read<BookingServiceDetailsCubit>();
    final name = cubit.state.port?.portName ?? 'EVEX';
    final link = AppDeepLink.portLink(cubit.currentPortId);
    await SharePlus.instance.share(
      ShareParams(text: '$name\n$link\n- عبر تطبيق EVEX'),
    );
  }

  /// The port's images as full URLs (empty when the backend returned none).
  /// Prefers the dedicated /api/Ports/GetPortImages gallery, falling back to the
  /// inline images that came with the ports list.
  List<String> _portImages(BookingServiceDetailsState state) {
    final dynamic imgs =
        state.portImages.isNotEmpty ? state.portImages : state.port?.portImages;
    if (imgs is List) {
      return imgs
          .map((e) => ImageUrlHelper.full(e.toString()))
          .whereType<String>()
          .toList();
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        BlocBuilder<BookingServiceDetailsCubit, BookingServiceDetailsState>(
          buildWhen: (p, c) =>
              p.port != c.port || p.portImages != c.portImages,
          builder: (context, state) {
            final images = _portImages(state);
            // No backend images → a single logo placeholder slide (no stock photo).
            final slides = images.isEmpty
                ? const [CustomImageHandler(null, fit: BoxFit.cover)]
                : images
                    .map((url) => SizedBox(
                          width: 1.sw,
                          child: CustomImageHandler(url, fit: BoxFit.cover),
                        ))
                    .toList();
            return CarouselSlider(
              items: slides,
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() {
                    activeIndex = index;
                  });
                },
                height: 283.h,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: images.length > 1,
                reverse: false,
                autoPlay: false,
                autoPlayInterval: const Duration(seconds: 7),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
            );
          },
        ),
        Container(
          width: 1.sw,
          height: 44.h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.white,
                Colors.white.withValues(alpha: 0.85),
                Colors.white.withValues(alpha: 0.0),
              ],
              // The corresponding stops for each color
              stops: [0.0, 0.58, 1.0],
            ),
          ),
        ),
        Positioned(
          top: 0,

          child: Container(
            width: 1.sw,
            height: 44.h,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white.withValues(alpha: 0.85),
                  Colors.white.withValues(alpha: 0.0),
                ],
                // The corresponding stops for each color
                stops: [0.18, 0.58, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          top: 40.h,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SocialNavButton(
                  height: 36.r,
                  width: 36.r,
                  icon: AppImages.iconsChevronRightSolid,
                  onTap: () {
                    NavigationHelper.pop();
                  },
                ),
                Spacer(),
                BlocBuilder<BookingServiceDetailsCubit,
                    BookingServiceDetailsState>(
                  buildWhen: (p, c) => p.isFavorite != c.isFavorite,
                  builder: (context, state) => SocialNavButton(
                    icon: AppImages.iconsHeart,
                    iconColor:
                        state.isFavorite ? AppColors.red2 : null,
                    onTap: () {
                      if (!AuthGuard.requireLogin(context)) return;
                      context
                          .read<BookingServiceDetailsCubit>()
                          .toggleFavorite();
                    },
                  ),
                ),
                6.horizontalSpace,
                SocialNavButton(
                  icon: AppImages.iconsMarker,
                  onTap: _openLocation,
                ),
                6.horizontalSpace,
                SocialNavButton(
                  icon: AppImages.iconsPhone2,
                  onTap: _callPort,
                ),
                6.horizontalSpace,
                SocialNavButton(icon: AppImages.iconsFolder, onTap: () {}),
                6.horizontalSpace,
                SocialNavButton(icon: AppImages.iconsShare, onTap: _sharePort),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 40.h,
          child: BlocBuilder<BookingServiceDetailsCubit,
              BookingServiceDetailsState>(
            buildWhen: (p, c) =>
                p.port != c.port || p.portImages != c.portImages,
            builder: (context, state) {
              final count = _portImages(state).length;
              if (count <= 1) return const SizedBox.shrink();
              return AnimatedSmoothIndicator(
                activeIndex: activeIndex,
                textDirection: TextDirection.ltr,
                count: count,
                effect: ExpandingDotsEffect(
                  dotHeight: 8.r,
                  dotWidth: 8.r,
                  expansionFactor: 2,
                  activeDotColor: AppColors.primaryColor,
                  dotColor: AppColors.dividerGrey,
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: -10.h,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: BlocBuilder<BookingServiceDetailsCubit,
                BookingServiceDetailsState>(
              buildWhen: (p, c) => p.port != c.port,
              builder: (context, state) => Row(
                children: [
                  Expanded(
                    child: Text(
                      state.port?.portName ?? '',
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
                  Transform.translate(
                    offset: Offset(0, -1.5.h),
                    child: CustomImageHandler(
                      AppImages.iconsStar,
                      height: 30.r,
                      width: 30.r,
                      fit: BoxFit.cover,
                    ),
                  ),
                  4.horizontalSpace,
                  Text(
                    '${state.port?.rate ?? 0}',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: AppColors.blacksoft,
                      fontSize: 14.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SocialNavButton extends StatelessWidget {
  final double? height;
  final double? width;

  final String icon;
  final Color? iconColor;
  final void Function()? onTap;
  const SocialNavButton({
    super.key,
    required this.icon,
    this.onTap,
    this.height,
    this.width,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusDirectional.circular(10.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: height ?? 32.r,
              height: width ?? 32.r,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10.r),
              ),
              alignment: Alignment.center,
              child: CustomImageHandler(
                icon,
                height: 18.r,
                width: 18.r,
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
