import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/cubits/booking_services/booking_service_details/booking_service_details_cubit.dart';
import 'package:evex_user/data/cubits/booking_services/booking_service_details/booking_service_details_state.dart';
import 'package:evex_user/data/models/port_service.dart';
import 'package:evex_user/data/models/service_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:evex_user/core/theme/app_colors.dart';

/// Bottom sheet عرض تفاصيل خدمة واحدة (صور + اسم + سعر + الوصف الكامل).
/// بيتفتح لما المستخدم يضغط على كارت خدمة من قائمة "الخدمات الأساسية".
class ServiceDetailsBottomSheet extends StatefulWidget {
  final PortService service;

  /// Whether a [BookingServiceDetailsCubit] is available to read the loaded
  /// [ServiceDetailsModel] (time chip + related occasions). The booking module
  /// provides it; the direct-payment module doesn't — there the sheet just
  /// shows name/price/description.
  final bool hasDetailsCubit;

  const ServiceDetailsBottomSheet({
    super.key,
    required this.service,
    this.hasDetailsCubit = false,
  });

  /// Helper لعرض الـ sheet بالشكل المتعارف عليه في المشروع.
  /// The sheet reads the loaded [ServiceDetailsModel] (time + related occasions)
  /// from the cubit when present, so its provider is forwarded via
  /// [BlocProvider.value]. In modules without that cubit (direct payment) the
  /// sheet still opens, just without the time chip / occasions.
  static Future<void> show(BuildContext context, PortService service) {
    BookingServiceDetailsCubit? cubit;
    try {
      cubit = context.read<BookingServiceDetailsCubit>();
    } catch (_) {
      cubit = null;
    }
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => cubit == null
          ? ServiceDetailsBottomSheet(service: service)
          : BlocProvider.value(
              value: cubit,
              child: ServiceDetailsBottomSheet(
                service: service,
                hasDetailsCubit: true,
              ),
            ),
    );
  }

  @override
  State<ServiceDetailsBottomSheet> createState() =>
      _ServiceDetailsBottomSheetState();
}

class _ServiceDetailsBottomSheetState extends State<ServiceDetailsBottomSheet> {
  final PageController _pageController = PageController();
  int _activeImage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.service.serviceImages ?? const <String>[];
    final details = widget.service.details?.trim();
    // Hide the price when the service is private OR the whole port keeps its
    // prices private (port-level displayPrice, read from the booking cubit).
    final port = widget.hasDetailsCubit
        ? context.read<BookingServiceDetailsCubit>().state.port
        : null;
    final hidePrice =
        widget.service.displayPrice || port?.displayPrice == true;
    // Max attendees the port can host (الحد الأقصى لعدد الحضور).
    final numberAllowed = port?.numberAllowed;
    return Container(
      width: 1.sw,
      constraints: BoxConstraints(maxHeight: 0.85.sh),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 80.w,
                  height: 4.r,
                  decoration: BoxDecoration(
                    color: AppColors.borderGrey,
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
              ),
              16.verticalSpace,
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: SizedBox(
                  height: 220.h,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(child: _buildImages(images)),
                      if (images.length > 1)
                        Positioned(
                          bottom: 10.h,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: AnimatedSmoothIndicator(
                              activeIndex: _activeImage,
                              count: images.length,
                              textDirection: TextDirection.rtl,
                              effect: ExpandingDotsEffect(
                                dotHeight: 7.r,
                                dotWidth: 7.r,
                                expansionFactor: 2,
                                activeDotColor: AppColors.primaryColor,
                                dotColor: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              18.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.service.name ?? '',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.blacksoft,
                        fontSize: 18.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w800,
                        height: 1.4,
                      ),
                    ),
                  ),
                  // Hide the price when the vendor keeps it private.
                  if (!hidePrice) ...[
                    12.horizontalSpace,
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${widget.service.priceAfterDiscount ?? 0}',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 20.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextSpan(
                            text: ' جنيه',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 14.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              16.verticalSpace,
              Flexible(
                child: SingleChildScrollView(
                  // Only the booking module has the details cubit (time chip +
                  // occasions). Elsewhere show the description on its own.
                  child: widget.hasDetailsCubit
                      ? BlocBuilder<BookingServiceDetailsCubit,
                          BookingServiceDetailsState>(
                          buildWhen: (p, c) =>
                              p.serviceDetails != c.serviceDetails,
                          builder: (context, state) {
                            // Only trust the loaded details when they belong to
                            // THIS service (getServiceData is async, so a
                            // previous service's details may linger for a frame).
                            final sd =
                                state.serviceDetails?.id == widget.service.id
                                    ? state.serviceDetails
                                    : null;
                            return _detailsBody(details, sd, numberAllowed);
                          },
                        )
                      : _detailsBody(details, null, numberAllowed),
                ),
              ),
              16.verticalSpace,
              CustomButton(
                text: 'اغلاق',
                isfilled: false,
                height: 52.h,
                onTap: () => Navigator.pop(context),
              ),
              8.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  /// The scrollable body: optional time chip + description + related occasions.
  /// [sd] is null when there's no details cubit (direct-payment module).
  /// [numberAllowed] is the port's max attendee capacity (الحد الأقصى لعدد الحضور).
  Widget _detailsBody(String? details, ServiceDetailsModel? sd,
      int? numberAllowed) {
    final occasions = sd?.occasions
            ?.map((o) => o.name?.trim() ?? '')
            .where((e) => e.isNotEmpty)
            .toList() ??
        const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Booking time window (صباحي / مسائي / يوم كامل).
        if (sd != null) ...[
          _timeChip(sd.time),
          16.verticalSpace,
        ],
        Text(
          (details != null && details.isNotEmpty)
              ? details
              : 'لا يوجد وصف متاح لهذه الخدمة',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: AppColors.descriptionText,
            fontSize: 13.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w400,
            height: 1.7,
          ),
        ),
        if (occasions.isNotEmpty) ...[
          16.verticalSpace,
          Text(
            'المناسبات المتعلقة بالخدمة',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 14.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
          6.verticalSpace,
          Text(
            occasions.join('، '),
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.descriptionText,
              fontSize: 13.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w400,
              height: 1.7,
            ),
          ),
        ],
        if (numberAllowed != null && numberAllowed > 0) ...[
          16.verticalSpace,
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'الحد الأقصى لعدد الحضور : ',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
                TextSpan(
                  text: '$numberAllowed',
                  style: TextStyle(
                    color: AppColors.descriptionText,
                    fontSize: 14.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ],
    );
  }

  /// Maps the service's `time` flag to its full booking-window description.
  /// am  → morning-only, pm → evening-only, anything else → full day.
  String _timeLabel(String? time) {
    switch (time?.trim().toLowerCase()) {
      case 'am':
        return 'صباحي ( حجز خلال الفترة الصباحية فقط )';
      case 'pm':
        return 'مسائي ( حجز خلال الفترة المسائية فقط )';
      default:
        return 'حجز اليوم بالكامل (غير مرتبط بتوقيت معين)';
    }
  }

  /// Bordered pill-box showing the service's booking time window:
  /// an orange "توقيت الخدمة" label followed by the window description.
  Widget _timeChip(String? time) {
    return Container(
      // padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: AppColors.peachOrange),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Text(
              'توقيت الخدمة',
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 12.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ),
          3.horizontalSpace,
          Expanded(
            child: Text(
              _timeLabel(time),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.descriptionText,
                fontSize: 12.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImages(List<String> images) {
    if (images.isEmpty) {
      return const CustomImageHandler(null);
    }
    return PageView.builder(
      controller: _pageController,
      itemCount: images.length,
      onPageChanged: (i) => setState(() => _activeImage = i),
      itemBuilder: (context, i) => CustomImageHandler(
        ImageUrlHelper.full(images[i]),
        smartFill: true,
      ),
    );
  }
}
