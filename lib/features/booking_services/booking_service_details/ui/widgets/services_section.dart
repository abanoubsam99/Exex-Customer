import 'package:evex_user/data/cubits/booking_services/booking_service_details/booking_service_details_cubit.dart';
import 'package:evex_user/data/cubits/booking_services/booking_service_details/booking_service_details_state.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/cubits/home/home_state.dart';
import 'package:evex_user/core/ui/widgets/empty_list_widget.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/service_card_item.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/service_details_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

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
                color: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),
            8.horizontalSpace,
            Text(
              'الخدمات الأساسية',
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
        8.verticalSpace,
        Row(
          children: [
            Container(
              width: 13.r,
              height: 13.r,
              decoration: ShapeDecoration(
                color: AppColors.greenSoft,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            6.horizontalSpace,
            Text(
              'خدمة متاحة',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 12.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w400,
                height: 1.30,
                letterSpacing: -0.24,
              ),
            ),
            const Spacer(),
            Container(
              width: 13.r,
              height: 13.r,
              decoration: ShapeDecoration(
                color: AppColors.coral,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            6.horizontalSpace,
            Text(
              'خدمة غير متاحة فى هذا اليوم',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 12.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w400,
                height: 1.30,
                letterSpacing: -0.24,
              ),
            ),
          ],
        ),
        10.verticalSpace,
        // Rebuild on a new availability response too: it decides which services
        // are still bookable on the picked date (backend `unreservedServices`).
        BlocBuilder<HomeCubit, HomeState>(
          // Rebuild on a new picked date too: it decides which special-price
          // period (and price/date range) each service card shows.
          buildWhen: (p, c) =>
              p.availability != c.availability || p.bookingDate != c.bookingDate,
          builder: (context, homeState) =>
              BlocBuilder<BookingServiceDetailsCubit, BookingServiceDetailsState>(
          builder: (context, state) {
            final cubit = context.read<BookingServiceDetailsCubit>();
            final pickedDate = homeState.bookingDate;
            if (state.services.isEmpty) {
              return EmptyListWidget(
                message: 'لا توجد خدمات متاحة',
                icon: Icons.design_services_outlined,
                iconSize: 44.r,
                padding: EdgeInsets.symmetric(vertical: 20.h),
              );
            }
            return SizedBox(
              // Headroom for the global 1.1 text scaling so the card content
              // (image + title + price row) never overflows.
              height: 200.h,
              child: ListView.separated(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemCount: state.services.length,
                separatorBuilder: (context, index) => 16.horizontalSpace,
                itemBuilder: (context, index) {
                  final service = state.services[index];
                  // Fall back to the port's gallery when the vendor didn't add
                  // any image for the service; the card itself shows the EVEX
                  // logo only when there's no port image either.
                  final serviceImages = service.serviceImages ?? const [];
                  final images = serviceImages.isNotEmpty
                      ? serviceImages
                      : state.portImages;
                  final isSelected = state.selectedService?.id == service.id;
                  return ServiceCardItem(
                    images: images,
                    title: service.name ?? '',
                    subtitle: service.details ?? '',
                    // Price for the picked date: the special-price period's
                    // price when it falls in one, otherwise the normal price.
                    price: service.effectivePrice(pickedDate),
                    // Struck price + badge follow the same period as the shown
                    // price.
                    priceBeforeDiscount:
                        service.effectivePriceBeforeDiscount(pickedDate),
                    discountPercentage:
                        service.effectiveDiscountPercentage(pickedDate),
                    // "20/6/2026 - 20/7/2026" for the matching period (empty
                    // otherwise, which hides the row).
                    dateRange: service.effectiveRangeLabel(pickedDate),
                    // Hide the price when the service is private OR the whole
                    // port keeps its prices private (port-level displayPrice).
                    displayPrice:
                        service.displayPrice || state.port?.displayPrice == true,
                    isSelected: isSelected,
                    isAvailable: cubit.isServiceAvailable(service.id),
                    onSelectionChanged: () {
                      // One tap = select the service AND open its details bottom
                      // sheet (images/name/price/description) together, so users
                      // don't have to tap twice. An already-selected service
                      // just re-opens the sheet. A service the picked date
                      // doesn't allow is blocked by selectService (toast, returns
                      // false) so its sheet never opens.
                      if (isSelected) {
                        ServiceDetailsBottomSheet.show(context, service);
                        return;
                      }
                      if (cubit.selectService(service)) {
                        ServiceDetailsBottomSheet.show(context, service);
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
        ),
      ],
    );
  }
}
