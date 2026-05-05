import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'addition_item.dart';

class BuffetsSection  extends StatelessWidget  {
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
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          clipBehavior: Clip.none,
          itemCount: 5,
          separatorBuilder: (context, index) => 12.verticalSpace,
          itemBuilder: (context, index) {

            return AdditionItem(
              title:  "name",
              price: "6",
              hasCount: false,
              initialCount:0,
              giftCount:1,
              isSelected:false,
              onChanged: () {
                // if (controller.selectedBuffets.contains(additionModel)) {
                //   controller.selectedBuffets.remove(additionModel);
                // } else {
                //   controller.selectedBuffets.add(additionModel);
                // }
              },
              onChangeCount: (count) {
                // controller.changeBuffetCount(additionModel, count);
              },
            );

            // return AdditionItem(additionModel: additionModel);

            // return (controller.addations[index].displayNumber ?? false)
            //     ? OfferItemWithCount(
            //       title: addationModel.name ?? "",
            //       onChangeCount: (count) {
            //         controller.changeAddCount(addationModel, count);
            //       },
            //       trilling: (addationModel.price ?? 0).toString(),
            //       initialCount:
            //           controller.selectedBuffets
            //               .firstWhereOrNull((e) => e.id == addationModel.id)
            //               ?.count ??
            //           0,
            //       giftCount:
            //           (controller.serviceDetailsModel.value?.hasGift ?? false)
            //               ? controller.serviceDetailsModel.value?.oldGifts
            //                   ?.firstWhereOrNull(
            //                     (g) => g.additionId == addationModel.id,
            //                   )
            //                   ?.number
            //               : null,
            //       isSelected:
            //           controller.selectedBuffets.contains(addationModel) ||
            //           controller.checkGift(addationModel.id ?? 0),
            //       onChanged: (count) {
            //         if (controller.selectedBuffets.contains(
            //           addationModel,
            //         )) {
            //           controller.selectedBuffets.remove(addationModel);
            //         } else {
            //           controller.selectedBuffets.add(
            //             addationModel..count = count,
            //           );
            //         }
            //         controller.selectedBuffets.refresh();
            //         controller.getTotalCost();
            //       },
            //     )
            //     : OfferItemWithoutCount(
            //       title: addationModel.name ?? "",
            //       trilling: addationModel.price.toString(),
            //       isSelected:
            //           controller.selectedBuffets.contains(addationModel) ||
            //           controller.checkGift(addationModel.id ?? 0),
            //       isGift:
            //           ((controller.serviceDetailsModel.value?.hasGift ??
            //                   false)
            //               ? controller.serviceDetailsModel.value?.oldGifts
            //                   ?.firstWhereOrNull(
            //                     (g) => g.additionId == addationModel.id,
            //                   )
            //                   ?.number
            //               : null) !=
            //           null,
            //       onChanged: () {
            //         if (controller.selectedBuffets.contains(
            //           addationModel,
            //         )) {
            //           controller.selectedBuffets.remove(addationModel);
            //         } else {
            //           controller.selectedBuffets.add(addationModel);
            //         }
            //         controller.getTotalCost();
            //         controller.selectedBuffets.refresh();
            //       },
            //     );
          },
        ),
      ],
    );
  }
}
