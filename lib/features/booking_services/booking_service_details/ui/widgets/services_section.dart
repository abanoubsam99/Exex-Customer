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
          buildWhen: (p, c) => p.availability != c.availability,
          builder: (context, _) =>
              BlocBuilder<BookingServiceDetailsCubit, BookingServiceDetailsState>(
          builder: (context, state) {
            final cubit = context.read<BookingServiceDetailsCubit>();
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
              height: 192.h,
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
                    price: service.priceAfterDiscount ?? 0,
                    priceBeforeDiscount: service.priceBeforDiscount,
                    displayPrice: service.displayPrice,
                    isSelected: isSelected,
                    isAvailable: cubit.isServiceAvailable(service.id),
                    onSelectionChanged: () {
                      // الضغطة الأولى بتختار الخدمة بس (بتجيب بياناتها للحساب).
                      // الضغطة التانية على نفس الخدمة المختارة هي اللي بتفتح
                      // الـ bottom sheet بتفاصيلها (صور/اسم/سعر/وصف).
                      // خدمة غير متاحة في التاريخ المختار بتتمنع هنا (بتوست).
                      if (isSelected) {
                        ServiceDetailsBottomSheet.show(context, service);
                        return;
                      }
                      cubit.selectService(service);
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
