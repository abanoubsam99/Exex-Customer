import 'package:evex/components/custom_back_button.dart';
import 'package:evex/components/custom_button.dart';
import 'package:evex/components/toast_manager.dart';

import 'package:evex/core/localization/app_strings.dart';
import 'package:evex/core/utils/app_colors.dart';

import 'package:evex/feature/services_provider_complet_data/logic/controler/complet_data_controler.dart';
import 'package:evex/feature/services_provider_complet_data/view/widget/choose_services.dart';
import 'package:evex/feature/services_provider_complet_data/view/widget/addtion_information.dart';
import 'package:evex/feature/services_provider_complet_data/view/widget/location_data.dart';
import 'package:evex/feature/services_provider_complet_data/view/widget/vander_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/user_service/user_serivces.dart';
import '../../../../routes/app_routes.dart';

class BodyServicesProviderDAtaWidget extends GetView<CompletDataControler> {
  const BodyServicesProviderDAtaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        // LinearProgressIndicator
        Obx(
          () => SafeArea(
            child: LinearProgressIndicator(
              minHeight: 6,
              value: (controller.currentPage.value + 1) / 4,
              backgroundColor: Colors.grey[300],
              color: AppColors.darkPrimaryColor,
            ),
          ),
        ),
        // const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: CustomBackButtonWidget(
            onTap: () {
              if (controller.currentPage.value > 0) {
                controller.goToPreviousPage();
              } else {
                UserService().logout();
              }
            },
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: PageView(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: controller.onPageChanged,
              children: const [
                VenderData(),
                ChooseServices(),
                LocationData(),
                AddtionInformation(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // زر التنقل بين الصفحات
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Obx(() => CustomButton(
                text: controller.currentPage.value != 3 ? "التالي " : "تاكيد",
                onTap: () {
                  if (controller.currentPage.value == 0) {
                    if (controller.dataFormKey.currentState!.validate()) {
                      controller.goToPage(1); // الانتقال للصفحة الثانية
                    }
                  } else if (controller.currentPage.value == 1) {
                    // debugPrint(controller.serviceType);
                    if (controller.serviceType.isNotEmpty) {
                      controller.goToPage(2);
                    } else {
                      Get.snackbar(
                        AppStrings.error.tr,
                        AppStrings.pleaseChooseService.tr,
                        backgroundColor: Colors.red.withOpacity(0.7),
                        colorText: Colors.white,
                      );
                    }
                  } else if (controller.currentPage.value == 2) {
                    if (controller.locationDataFormKey.currentState!
                        .validate()) {
                      print(controller.locationDataFormKey.currentState!
                          .validate());
                      controller.goToPage(3);
                    }
                  } else {
                    if (controller.linksFormKey.currentState!.validate()) {
                      controller.completVanderData();
                    }
                  }
                },
              )),
        ),
        const SizedBox(height: 23),
      ],
    );
  }
}
