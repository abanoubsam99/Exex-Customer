import 'package:evex_user/data/cubits/booking_services/booking_service_details/booking_service_details_cubit.dart';
import 'package:evex_user/data/cubits/booking_services/booking_service_details/booking_service_details_state.dart';
import 'package:evex_user/data/models/review.dart';
import 'package:evex_user/core/ui/widgets/empty_list_widget.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/review_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

/// "آراء العملاء" section. Pass [reviews] to render a specific list (e.g. the
/// direct-services module); leave it null to read the reviews from the
/// [BookingServiceDetailsCubit] (instant-booking module).
class ReviewsSection extends StatelessWidget {
  final List<Review>? reviews;
  const ReviewsSection({super.key, this.reviews});

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
              'آراء العملاء',
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
        12.verticalSpace,
        reviews != null
            ? _list(reviews!)
            : BlocBuilder<BookingServiceDetailsCubit,
                BookingServiceDetailsState>(
                buildWhen: (p, c) => p.reviews != c.reviews,
                builder: (context, state) => _list(state.reviews),
              ),
      ],
    );
  }

  Widget _list(List<Review> reviews) {
    if (reviews.isEmpty) {
      return EmptyListWidget(
        message:
            'رأيك يهمنا .. تقدر تشاركنا ب تقييمك لخدمة التاجر بعد إتمام مناسبتك',
        icon: Icons.star_border_rounded,
        iconSize: 44.r,
        padding: EdgeInsets.symmetric(vertical: 20.h),
      );
    }
    return SizedBox(
      height: 115.h,
      child: ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: reviews.length,
        separatorBuilder: (context, index) => 10.horizontalSpace,
        itemBuilder: (context, index) =>
            ReviewCardItem(review: reviews[index]),
      ),
    );
  }
}
