import 'package:evex/components/custom_dropdown_form_field.dart';
import 'package:evex/core/utils/app_colors.dart';
import 'package:evex/feature/vendor/add_get_way/data/model/workArea/work_area.dart';
import 'package:evex/feature/vendor/add_get_way/logic/controler/add_getway_contreoler.dart';
import 'package:evex/feature/vendor/vendor_home_feature/view/wedget/buttom_sheet_choose_city.dart';
import 'package:evex/feature/vendor/vendor_home_feature/view/wedget/itam_add.dart';
import 'package:evex/feature/vendor/vendor_home_feature/view/wedget/location_work.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/text_themes.dart';
import 'work_details.dart';

class LocationAvailabilty extends GetView<AddGetwayController> {
  const LocationAvailabilty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        child: Form(
          key: controller.loctionAvailnel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 26.verticalSpace,
              Text(
                "تحديد مناطق العمل",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor2,
                ),
              ),
              6.verticalSpace,
              Text(
                "يرجي إدخال البيانات الأتية ",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textfieldHintTxtColor,
                ),
              ),
              24.verticalSpace,
              Text("المحافظة",
                  style: CustomTextTheme.font16HintMedium
                      .copyWith(color: Colors.black)),
              8.verticalSpace,
              Obx(
                () => CustomDropDownFormField(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  color: AppColors.buttonSecondaryColor,
                  hintText: 'قم باختيار المحافظة',
                  items: controller.governates
                      .map((e) => DropdownMenuItem(
                            value: e.governorateNameAr ?? " ",
                            child: Text(e.governorateNameAr ?? " ",
                                style: CustomTextTheme.font16BlackBold),
                          ))
                      .toList(),
                  value: controller.currentSelectedGovernate,
                  onChanged: (v) async {
                    controller.currentSelectedGovernate = v;
                    controller.currentSelectedCities.value = [];
                    await controller.getCities(gName: v, isWorking: true);
                  },
                ),
              ),
              16.verticalSpace,
              Text("المدينة",
                  style: CustomTextTheme.font16HintMedium
                      .copyWith(color: Colors.black)),
              8.verticalSpace,
              CustomTextFiled(
                hint: 'اختر المدينة',
                textEditingController: TextEditingController(text: null
                    // controller.currentSelectedCities.isEmpty
                    //     ? null
                    //     : controller.currentSelectedCities.join(', ')

                    ),
                onTap: () {
                  Get.bottomSheet(const ButtomSheetChooseCity(),
                      isScrollControlled: true);
                },
              ),
              16.verticalSpace,
              GestureDetector(
                  onTap: () {
                    // print('object');
                    controller.workAreaData.value!.workAreaViewModels!
                        .removeWhere((element) =>
                            element.governorate ==
                            controller.currentSelectedGovernate);
                    controller.workAreaData.value!.workAreaViewModels!.addAll(
                        controller.currentSelectedCities
                            .map((e) => WorkAreaViewModel(
                                city: e,
                                governorate:
                                    controller.currentSelectedGovernate))
                            .toList());
                    controller.update();
                  },
                  child: const IteamAdd()),
              32.verticalSpace,
              GetBuilder<AddGetwayController>(builder: (x) {
                Map<String, List<String>> map = {};
                x.workAreaData.value!.workAreaViewModels!.map((e) {
                  if (map.containsKey(e.governorate)) {
                    map[e.governorate]!.add(e.city!);
                  } else {
                    map.addAll({
                      e.governorate!: [e.city!]
                    });
                  }
                }).toList();
                return ((controller.workAreaData.value?.workAreaViewModels ??
                            [])
                        .isEmpty)
                    ? const SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            const Divider(
                              height: 1,
                              color: AppColors.bgGray,
                            ),
                            16.verticalSpace,
                            Text(
                              "مناطق العمل ",
                              style: CustomTextTheme.font16HintMedium
                                  .copyWith(color: Colors.black),
                            ),
                            16.verticalSpace,
                            Column(
                              children: map.entries.map((e) {
                                return LocationWork(WorkAreaViewModel(
                                  city: e.value.join(', '),
                                  governorate: e.key,
                                ));
                              }).toList(),
                            ),
                          ]);
              })
            ],
          ),
        ),
      ),
    );
  }
}
