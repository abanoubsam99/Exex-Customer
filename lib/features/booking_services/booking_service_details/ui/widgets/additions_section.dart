import 'package:evex_user/data/cubits/booking_services/booking_service_details/booking_service_details_cubit.dart';
import 'package:evex_user/data/cubits/booking_services/booking_service_details/booking_service_details_state.dart';
import 'package:evex_user/core/ui/widgets/empty_list_widget.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/addition_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class AdditionsSection extends StatelessWidget {
  const AdditionsSection({super.key});

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
              'الإضافات',
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
        BlocBuilder<BookingServiceDetailsCubit, BookingServiceDetailsState>(
          builder: (context, state) {
            final cubit = context.read<BookingServiceDetailsCubit>();
            if (state.additions.isEmpty) {
              return EmptyListWidget(
                message: 'لا توجد إضافات متاحة',
                icon: Icons.add_box_outlined,
                iconSize: 44.r,
                padding: EdgeInsets.symmetric(vertical: 20.h),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              clipBehavior: Clip.none,
              itemCount: state.additions.length,
              separatorBuilder: (context, index) => 12.verticalSpace,
              itemBuilder: (context, index) {
                final additionModel = state.additions[index];
                final selected = state.selectedAdditions
                    .any((e) => e.id == additionModel.id);
                final giftMatches = (state.serviceDetails?.oldGifts ?? [])
                    .where((g) => g.additionId == additionModel.id);
                final giftCount =
                    (state.serviceDetails?.hasGift ?? false) &&
                            giftMatches.isNotEmpty
                        ? giftMatches.first.number
                        : null;
                return AdditionItem(
                  title: additionModel.name ?? '',
                  price: (additionModel.price ?? 0).toString(),
                  hasCount: additionModel.displayNumber ?? false,
                  initialCount: state.selectedAdditions
                          .firstWhere(
                            (e) => e.id == additionModel.id,
                            orElse: () => additionModel,
                          )
                          .count ??
                      0,
                  giftCount: giftCount,
                  isSelected:
                      selected || cubit.checkGift(additionModel.id ?? 0),
                  onChanged: () => cubit.toggleAddition(additionModel),
                  onChangeCount: (count) =>
                      cubit.changeAdditionCount(additionModel, count),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
