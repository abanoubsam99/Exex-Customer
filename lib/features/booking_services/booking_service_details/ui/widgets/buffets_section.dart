import 'package:evex_user/data/cubits/booking_services/booking_service_details/booking_service_details_cubit.dart';
import 'package:evex_user/data/cubits/booking_services/booking_service_details/booking_service_details_state.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/addition_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuffetsSection extends StatelessWidget {
  const BuffetsSection({super.key});

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
                color: const Color(0xFFF38B4A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),
            8.horizontalSpace,
            Text(
              'البوفيه',
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
            return ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              clipBehavior: Clip.none,
              itemCount: state.buffets.length,
              separatorBuilder: (context, index) => 12.verticalSpace,
              itemBuilder: (context, index) {
                final additionModel = state.buffets[index];
                final selected =
                    state.selectedBuffets.any((e) => e.id == additionModel.id);
                final giftCount =
                    (state.serviceDetails?.hasGift ?? false)
                        ? state.serviceDetails?.oldGifts
                            ?.firstWhere(
                              (g) => g.additionId == additionModel.id,
                              orElse: () =>
                                  throw Exception('not found'),
                            )
                            .number
                        : null;
                return AdditionItem(
                  title: additionModel.name ?? '',
                  price: (additionModel.price ?? 0).toString(),
                  hasCount: additionModel.displayNumber ?? false,
                  initialCount: state.selectedBuffets
                          .firstWhere(
                            (e) => e.id == additionModel.id,
                            orElse: () => additionModel,
                          )
                          .count ??
                      0,
                  giftCount: giftCount,
                  isSelected:
                      selected || cubit.checkGift(additionModel.id ?? 0),
                  onChanged: () => cubit.toggleBuffet(additionModel),
                  onChangeCount: (count) =>
                      cubit.changeBuffetCount(additionModel, count),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
