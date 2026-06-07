import 'dart:io';

import 'package:evex/components/custom_back_button.dart';
import 'package:evex/components/custom_button.dart';
import 'package:evex/components/custom_loader.dart';
import 'package:evex/components/retry_widget.dart';
import 'package:evex/components/toast_manager.dart';
import 'package:evex/core/services/network_service/endpoints.dart';

import 'package:evex/core/theme/text_themes.dart';
import 'package:evex/feature/vendor/add_get_way/logic/controler/add_getway_image_controler.dart';
import 'package:evex/feature/vendor/services/add_offer/logic/controler/image_controler.dart';
import 'package:evex/feature/vendor/services/add_offer/view/widget/iteam_image_widget.dart';
import 'package:evex/feature/vendor/services/add_offer/view/widget/upload_image_widget.dart';
import 'package:evex/feature/vendor/services/home_services/logic/controller/services_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddGetWayImagesScreen extends GetView<AddGetWayImageControler> {
  const AddGetWayImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop && result != null) {
          await Future.delayed(Duration.zero, () {
            Get.back(result: true);
            ToastManager.showSuccess('لم يتم اضافة صور جديدة', true);
          });
        }
        // Allow default back behavior
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 16.h),
          child: CustomButton(
              text: "حفظ الالبوم",
              onTap: () {
                print(controller.selectedImages.length);

                if (controller.selectedImages.isEmpty) {
                  Navigator.of(context).pop(); //nvigate back with overlay
                  ToastManager.showSuccess('لم يتم اضافة صور جديدة', true);
                } else {
                  controller.sendImages();
                }
              }),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32.h),
              CustomBackButtonWidget(onTap: () {
                Get.back();
                ToastManager.showSuccess('لم يتم اضافة صور جديدة', true);
              }),
              SizedBox(height: 16.h),
              Text(
                "إضافة البوم الصور",
                style: CustomTextTheme.font20BlackMedium,
              ),
              SizedBox(height: 10.h),
              Text(
                "يرجي اختيار صور مناسبة لعرضها في الخدمة او العرض",
                style: CustomTextTheme.font16HintMedium,
              ),
              SizedBox(height: 32.h),
              Text(
                "رفع الصور",
                style: CustomTextTheme.font16BlackMedium,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // controller.getimagesByServicesid();
                  Get.bottomSheet(
                    Container(
                      height: 100.h,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 10),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                controller
                                    .pickAndSendImages(ImageSource.camera);
                                Get.back();
                              },
                              child: const Row(
                                children: [
                                  Text("الكاميرا"),
                                  Spacer(),
                                  Icon(Icons.camera_alt_outlined),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                            InkWell(
                              onTap: () {
                                controller
                                    .pickAndSendImages(ImageSource.gallery);
                                Get.back();
                              },
                              child: const Row(
                                children: [
                                  Text("المعرض"),
                                  Spacer(),
                                  Icon(Icons.image),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: const UploadWidget(),
              ),
              const SizedBox(height: 24),
              Text(
                "ألبوم الصور",
                style: CustomTextTheme.font16BlackMedium,
              ),
              SizedBox(height: 10.h),
              GetBuilder<AddGetWayImageControler>(
                builder: (controller) {
                  return controller.isLoading
                      ? const Center(child: CustomLoader())
                      : controller.isError
                          ? RetryWidget(
                              onRetry: () async =>
                                  await controller.getimagesByPortid(),
                            )
                          : controller.images.isEmpty
                              ? Center(
                                  child: Text(
                                  "لا يوجد صور",
                                  style: CustomTextTheme.font16HintBold,
                                ))
                              : Obx(
                                  () => Column(
                                    children: List.generate(
                                      controller.images.length,
                                      (index) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: IteamImage(
                                          image: controller.images[index]
                                                  .contains("Uploads")
                                              ? EndPoints.baseUrl +
                                                  (controller.images[index] ??
                                                      '')
                                              : controller.images[index],
                                          onDelete: () {
                                            if (!controller.images[index]
                                                .startsWith("Uploads")) {
                                              controller.removeIfExists(File(
                                                  controller.images[index] ??
                                                      ''));
                                              controller.images.removeAt(index);

                                              // تحديث الحالة إذا كنت تستخدم GetX
                                            } else {
                                              controller.removeImage(
                                                  imagee: controller
                                                          .images[index] ??
                                                      '');
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
