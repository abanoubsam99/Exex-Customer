import 'package:evex_user/features/booking_services/booking_service_details/data/models/addition_model.dart';
import 'package:evex_user/features/booking_services/booking_service_details/logic/port_services_controller.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/addition_item.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/addition_item.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/offer_item_with_count.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/offfer_item_without_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdditionsSection extends GetView<PortServicesController> {
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
                color: const Color(0xFFF38B4A),
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
        Obx(
          () => ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            clipBehavior: Clip.none,
            itemCount: controller.addations.length,
            separatorBuilder: (context, index) => 12.verticalSpace,
            itemBuilder: (context, index) {
              AdditionModel additionModel = controller.addations[index];

              return Obx(
                () => AdditionItem(
                  title: additionModel.name ?? "",
                  price: (additionModel.price ?? 0).toString(),
                  hasCount: (additionModel.displayNumber ?? false),
                  initialCount:
                      controller.selectedAddations
                          .firstWhereOrNull((e) => e.id == additionModel.id)
                          ?.count ??
                      0,
                  giftCount:
                      (controller.serviceDetailsModel.value?.hasGift ?? false)
                          ? controller.serviceDetailsModel.value?.oldGifts
                              ?.firstWhereOrNull(
                                (g) => g.additionId == additionModel.id,
                              )
                              ?.number
                          : null,
                  isSelected:
                      controller.selectedAddations.contains(additionModel) ||
                      controller.checkGift(additionModel.id ?? 0),
                  onChanged: () {
                    if (controller.selectedAddations.contains(additionModel)) {
                      controller.selectedAddations.remove(additionModel);
                    } else {
                      controller.selectedAddations.add(additionModel);
                    }
                  },
                  onChangeCount: (count) {
                    controller.changeAdditionCount(additionModel, count);
                  },
                ),
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
              //           controller.selectedAddations
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
              //           controller.selectedAddations.contains(addationModel) ||
              //           controller.checkGift(addationModel.id ?? 0),
              //       onChanged: (count) {
              //         if (controller.selectedAddations.contains(
              //           addationModel,
              //         )) {
              //           controller.selectedAddations.remove(addationModel);
              //         } else {
              //           controller.selectedAddations.add(
              //             addationModel..count = count,
              //           );
              //         }
              //         controller.selectedAddations.refresh();
              //         controller.getTotalCost();
              //       },
              //     )
              //     : OfferItemWithoutCount(
              //       title: addationModel.name ?? "",
              //       trilling: addationModel.price.toString(),
              //       isSelected:
              //           controller.selectedAddations.contains(addationModel) ||
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
              //         if (controller.selectedAddations.contains(
              //           addationModel,
              //         )) {
              //           controller.selectedAddations.remove(addationModel);
              //         } else {
              //           controller.selectedAddations.add(addationModel);
              //         }
              //         controller.getTotalCost();
              //         controller.selectedAddations.refresh();
              //       },
              //     );
            },
          ),
        ),
      ],
    );
  }
}
