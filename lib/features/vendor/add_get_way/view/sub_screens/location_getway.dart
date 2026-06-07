import 'package:evex/components/custom_dropdown_form_field.dart';
import 'package:evex/components/custom_image_handler.dart';
import 'package:evex/components/custom_loader.dart';
import 'package:evex/components/retry_widget.dart';
import 'package:evex/components/text_field_component.dart';
import 'package:evex/core/constants/app_images_path.dart';
import 'package:evex/core/localization/app_strings.dart';
import 'package:evex/core/theme/text_themes.dart';
import 'package:evex/core/utils/app_colors.dart';
import 'package:evex/feature/vendor/add_get_way/logic/controler/add_getway_contreoler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/utils/map_utils.dart';

class LocationGetway extends GetView<AddGetwayController> {
  const LocationGetway({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const CustomLoader()
          : controller.governates.value.isEmpty
              ? RetryWidget(onRetry: () {
                  controller.getGovernates();
                })
              : SingleChildScrollView(
                  child: Form(
                    key: Get.find<AddGetwayController>().locationDataFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'موقع بوابة الخدمات',
                          style: CustomTextTheme.font20BlackMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        6.verticalSpace,
                        Text(
                          AppStrings.enterDetailsadders.tr,
                          style: CustomTextTheme.font16Black
                              .copyWith(color: const Color(0xff6F767E)),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppColors.bgGray, width: 1.5)),
                          child: GestureDetector(
                            onTap: () {
                              controller.getlocation();
                            },
                            child: ListTile(
                              leading: const CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child:
                                      CustomImageHandler(AppImages.location)),
                              title: Text(
                                AppStrings.useCurrentLocation.tr,
                                style: CustomTextTheme.font16BlackBold,
                              ),
                              subtitle: Obx(
                                () => Text(
                                  controller.loc.value,
                                  style: CustomTextTheme.font14HintRegular
                                      .copyWith(
                                          color: const Color(0xff6F767E),
                                          fontSize: 12),
                                ),
                              ),
                              // trailing: const Icon(
                              //   Icons.keyboard_arrow_left,
                              //   size: 25,
                              // ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            color: AppColors.bgGrey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Obx(
                              () => controller.position.value == null
                                  ? SizedBox(
                                      height: 0.15.sh,
                                      width: 1.sw,
                                    )
                                  : SizedBox(
                                      height: 0.15.sh,
                                      width: 1.sw,
                                      child: FlutterMap(
                                          options: MapOptions(
                                            initialCenter: LatLng(
                                                controller.position.value
                                                        ?.latitude ??
                                                    0,
                                                controller.position.value
                                                        ?.longitude ??
                                                    0), // Center the map over London
                                            initialZoom: 18,
                                            onTap: (tapPosition, point) {
                                              MapUtils.openMap(
                                                controller.position.value
                                                        ?.latitude ??
                                                    0,
                                                controller.position.value
                                                        ?.longitude ??
                                                    0,
                                              );
                                            },
                                          ),
                                          children: [
                                            TileLayer(
                                              urlTemplate:
                                                  'https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png',
                                              subdomains: const ['a', 'b', 'c'],
                                              // urlTemplate:
                                              //     'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                                              // subdomains: const [
                                              //   'a',
                                              //   'b',
                                              //   'c',
                                              //   'd'
                                              // ],
                                              userAgentPackageName:
                                                  'com.evex.saas',
                                            ),
                                            MarkerLayer(
                                              markers: [
                                                Marker(
                                                  point: LatLng(
                                                      controller.position.value
                                                              ?.latitude ??
                                                          0,
                                                      controller.position.value
                                                              ?.longitude ??
                                                          0),
                                                  child: const Icon(
                                                    Icons.location_on,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ]),
                                    ),
                            ),
                          ),
                        ),
                        Text(
                          AppStrings.governnorate.tr,
                          style: CustomTextTheme.font16BlackMedium,
                        ),
                        6.verticalSpace,
                        CustomDropDownFormField(
                          hintText: 'قم باختيار المحافظة',
                          size: 30,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          items: controller.governates.value
                              .map((g) => DropdownMenuItem(
                                    value: g.governorateNameAr,
                                    child: Text(
                                      g.governorateNameAr ?? "",
                                      style: CustomTextTheme.font16BlackMedium,
                                    ),
                                  ))
                              .toList(),
                          onChanged: (p0) {
                            controller.selectedGovernate = p0;
                            controller.selectedCity!.value = '';
                            controller.getCities(gName: p0);
                          },
                          value: controller.selectedGovernate,
                          validator: (value) {
                            if (value == null) return 'يرجي اختيار محافظة';
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(AppStrings.city.tr,
                            style: CustomTextTheme.font16BlackMedium),
                        6.verticalSpace,
                        CustomDropDownFormField(
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            hintText: 'قم باختيار المدينة',
                            items: controller.cities.value
                                .map((g) => DropdownMenuItem(
                                      value: g.cityNameAr,
                                      child: Text(
                                        g.cityNameAr ?? "",
                                        style:
                                            CustomTextTheme.font16BlackMedium,
                                      ),
                                    ))
                                .toList(),
                            onChanged: (city) {
                              controller.selectedCity?.value = city;
                            },
                            value: controller.selectedCity!.value.isEmpty
                                ? null
                                : controller.selectedCity?.value,
                            validator: (value) {
                              if (value == null) return 'يرجي اختيار مدينة';
                              return null;
                            }),
                        10.verticalSpace,
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'العنوان بالتفاصيل',
                                  style: CustomTextTheme.font14BlackMedium),
                              TextSpan(
                                text: ' ( يفضل إدخال علامة مميزة )',
                                style: Get.textTheme.labelSmall!.copyWith(
                                  color: const Color(0xffA39FA2),
                                  fontSize: 12.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        10.verticalSpace,
                        TextFieldComponent(
                          hint: "العنوان بالتفاصيل",
                          fillColor: AppColors.buttonSecondaryColor,
                          controller: controller.addressDetails,
                        ),
                        15.verticalSpace
                      ],
                    ),
                  ),
                ),
    );
  }
}
