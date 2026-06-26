import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/data/cubits/booking_services/booking_service_details/booking_service_details_cubit.dart';
import 'package:evex_user/data/cubits/booking_services/booking_service_details/booking_service_details_state.dart';
import 'package:evex_user/core/ui/widgets/empty_list_widget.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/other_service_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class OtherServicesSection extends StatelessWidget {
  const OtherServicesSection({super.key});

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
              'خدمات أخرى',
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
        Text(
          'مُقدمه من نفس التاجر أو مقدم الخدمة',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 12.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        4.verticalSpace,
        BlocBuilder<BookingServiceDetailsCubit, BookingServiceDetailsState>(
          buildWhen: (p, c) => p.otherPorts != c.otherPorts,
          builder: (context, state) {
            final ports = state.otherPorts;
            if (ports.isEmpty) {
              return EmptyListWidget(
                message: 'لا توجد خدمات أخرى',
                icon: Icons.widgets_outlined,
                iconSize: 44.r,
                padding: EdgeInsets.symmetric(vertical: 20.h),
              );
            }
            return SizedBox(
              height: 150.h,
              child: ListView.separated(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemCount: ports.length,
                separatorBuilder: (context, index) => 16.horizontalSpace,
                itemBuilder: (context, index) {
                  final port = ports[index];
                  return GestureDetector(
                    // Open the selected vendor port in its own details screen.
                    onTap: () => NavigationHelper.pushNamed(
                      Routes.bookingServiceDetailsScreen,
                      arguments: port,
                    ),
                    child: OtherServiceCardItem(
                      images: _portImages(port),
                      title: port.portName ?? '',
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  /// The port's image paths — uses the main image from the Filter response.
  List<String> _portImages(Item port) {
    final main = port.theMainImageFileName?.trim();
    return (main != null && main.isNotEmpty) ? [main] : const [];
  }
}
