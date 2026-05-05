import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:evexcustomer/app/constants/app_images.dart';
import 'package:evexcustomer/app/constants/cash_keys.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/widgets/country_picker.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/custom_image_handler.dart';
import '../../../app/widgets/text_field_builder_widget.dart';

class AddClientScreen extends StatelessWidget {
  const AddClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 1.sh,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(1.5, -1),
                    end: Alignment(-1, 0.2),
                    colors: [
                      Color(0xffF9C5A4).withValues(alpha: 0),
                      Colors.white,
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 493.h,

              width: double.infinity,
              child: CustomImageHandler(
                AppImages.iconsFamily,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              bottom: 0.h,
              child: Container(
                width: 1.sw,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(65),
                      topRight: Radius.circular(65),
                    ),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x66000000),
                      blurRadius: 66,
                      offset: Offset(0, -5),
                      spreadRadius: 24,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 37.w,
                    vertical: 32.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'أهلا بيك وسط عيلتك ..',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFF2C262C),
                          fontSize: 22.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w800,
                          height: 0.95,
                          letterSpacing: -0.24,
                        ),
                      ),
                      19.verticalSpace,
                      TextFieldBuilder(
                        title: 'الاسم الثلاثي',
                        hintText: 'باللغة العربية مثال : الأول الأوسط الأخير',
                        // controller: controller.nameController,
                      ),
                      12.verticalSpace,
                      Text(
                        'المنطقة',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF2C262C),
                          fontSize: 14.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                          letterSpacing: -0.24,
                        ),
                      ),
                      Container(
                        // height: 46.h,
                        width: 1.sw,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF4F4F4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Row(
                            children: [
                              // Expanded(
                              //   child: CountryPicker.compact(
                              //     value: customCountries.first,
                              //     items: [
                              //       ...customCountries.map(
                              //         (e) => DropdownMenuItem(
                              //           value: e,
                              //           child: Row(
                              //             children: [
                              //               Container(
                              //                 width: 30.r,
                              //                 height: 30.r,
                              //                 decoration: BoxDecoration(
                              //                   shape: BoxShape.circle,
                              //                   image: DecorationImage(
                              //                     image: AssetImage(
                              //                       'assets/flags/${e.code.toLowerCase()}.png',
                              //                       package:
                              //                           'flutter_intl_phone_field',
                              //                     ),
                              //                     fit: BoxFit.cover,
                              //                   ),
                              //                 ),
                              //               ),
                              //               SizedBox(width: 8.w),
                              //               Container(
                              //                 width: 1,
                              //                 height: 30.h,
                              //                 decoration: ShapeDecoration(
                              //                   shape: RoundedRectangleBorder(
                              //                     side: BorderSide(
                              //                       width: 0.5,
                              //                       strokeAlign:
                              //                           BorderSide
                              //                               .strokeAlignCenter,
                              //                       color: const Color(
                              //                         0xFF99A2AC,
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //               SizedBox(width: 8.w),

                              //               Text(
                              //                 e.nameTranslations['ar'] ?? e.name,
                              //                 textAlign: TextAlign.center,
                              //                 style: TextStyle(
                              //                   color: Colors.black,
                              //                   fontSize: 14.r,
                              //                   fontFamily: 'Almarai',
                              //                   fontWeight: FontWeight.w400,
                              //                   letterSpacing: -0.24,
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //     onChanged: (value) {},
                              //   ),
                              // ),
                              // DropdownButtonFormField2(
                              //   value: customCountries.first,
                              //   items: [
                              //     ...customCountries.map(
                              //       (e) => DropdownMenuItem(
                              //         value: e,
                              //         child: Row(
                              //           children: [
                              //             Container(
                              //               width: 30.r,
                              //               height: 30.r,
                              //               decoration: BoxDecoration(
                              //                 shape: BoxShape.circle,
                              //                 image: DecorationImage(
                              //                   image: AssetImage(
                              //                     'assets/flags/${e.code.toLowerCase()}.png',
                              //                     package:
                              //                         'flutter_intl_phone_field',
                              //                   ),
                              //                   fit: BoxFit.cover,
                              //                 ),
                              //               ),
                              //             ),
                              //             SizedBox(width: 8.w),
                              //             Container(
                              //               width: 1,
                              //               height: 30.h,
                              //               decoration: ShapeDecoration(
                              //                 shape: RoundedRectangleBorder(
                              //                   side: BorderSide(
                              //                     width: 0.5,
                              //                     strokeAlign:
                              //                         BorderSide
                              //                             .strokeAlignCenter,
                              //                     color: const Color(
                              //                       0xFF99A2AC,
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //             SizedBox(width: 8.w),
                              //
                              //             Text(
                              //               e.nameTranslations['ar'] ?? e.name,
                              //               textAlign: TextAlign.center,
                              //               style: TextStyle(
                              //                 color: Colors.black,
                              //                 fontSize: 14.r,
                              //                 fontFamily: 'Almarai',
                              //                 fontWeight: FontWeight.w400,
                              //                 letterSpacing: -0.24,
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              //   onChanged: (value) {},
                              //
                              //   validator: (value) {
                              //     return null;
                              //   },
                              //   selectedItemBuilder: (context) {
                              //     return customCountries
                              //         .map(
                              //           (item) => Center(
                              //             child: Row(
                              //               mainAxisSize: MainAxisSize.min,
                              //               children: [
                              //                 Container(
                              //                   width: 30.r,
                              //                   height: 30.r,
                              //                   decoration: BoxDecoration(
                              //                     shape: BoxShape.circle,
                              //                     image: DecorationImage(
                              //                       image: AssetImage(
                              //                         'assets/flags/${item.code.toLowerCase()}.png',
                              //                         package:
                              //                             'flutter_intl_phone_field',
                              //                       ),
                              //                       fit: BoxFit.cover,
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         )
                              //         .toList();
                              //   },
                              //   isDense: false,
                              //   isExpanded: false,
                              //   iconStyleData: IconStyleData(iconSize: 0),
                              //   dropdownStyleData: DropdownStyleData(
                              //     width: 300, // ← This is all you need!
                              //     maxHeight: 400,
                              //   ),
                              //   buttonStyleData: ButtonStyleData(
                              //     padding: EdgeInsets.zero,
                              //   ),
                              //   decoration: InputDecoration(
                              //     contentPadding: EdgeInsets.zero,
                              //     prefixIcon: CustomImageHandler(
                              //       AppImages.iconsAngleSmallDown,
                              //       color: Color(0xFF787878),
                              //     ),
                              //     prefixIconConstraints: BoxConstraints(
                              //       minWidth: 0,
                              //       minHeight: 0,
                              //     ),
                              //     constraints: BoxConstraints(maxWidth: 60.w),
                              //     border: InputBorder.none,
                              //   ),
                              // ),




                              // Flexible(
                              //   child: DropdownButtonFormField(
                              //     value: customCountries.first,
                              //     items: [
                              //       ...customCountries.map(
                              //         (e) => DropdownMenuItem(
                              //           value: e,
                              //           child: Row(
                              //             children: [
                              //               Container(
                              //                 width: 30.r,
                              //                 height: 30.r,
                              //                 decoration: BoxDecoration(
                              //                   shape: BoxShape.circle,
                              //                   image: DecorationImage(
                              //                     image: AssetImage(
                              //                       'assets/flags/${e.code.toLowerCase()}.png',
                              //                       package:
                              //                           'flutter_intl_phone_field',
                              //                     ),
                              //                     fit: BoxFit.cover,
                              //                   ),
                              //                 ),
                              //               ),
                              //               SizedBox(width: 8.w),
                              //               Container(
                              //                 width: 1,
                              //                 height: 30.h,
                              //                 decoration: ShapeDecoration(
                              //                   shape: RoundedRectangleBorder(
                              //                     side: BorderSide(
                              //                       width: 0.5,
                              //                       strokeAlign:
                              //                           BorderSide
                              //                               .strokeAlignCenter,
                              //                       color: const Color(
                              //                         0xFF99A2AC,
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //               SizedBox(width: 8.w),

                              //               Text(
                              //                 e.nameTranslations['ar'] ??
                              //                     e.name,
                              //                 textAlign: TextAlign.center,
                              //                 style: TextStyle(
                              //                   color: Colors.black,
                              //                   fontSize: 14.r,
                              //                   fontFamily: 'Almarai',
                              //                   fontWeight: FontWeight.w400,
                              //                   letterSpacing: -0.24,
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //     onChanged: (value) {},

                              //     validator: (value) {
                              //       return null;
                              //     },
                              //     selectedItemBuilder: (context) {
                              //       return customCountries
                              //           .map(
                              //             (item) => Center(
                              //               child: Row(
                              //                 mainAxisSize: MainAxisSize.min,
                              //                 children: [
                              //                   Container(
                              //                     width: 30.r,
                              //                     height: 30.r,
                              //                     decoration: BoxDecoration(
                              //                       shape: BoxShape.circle,
                              //                       image: DecorationImage(
                              //                         image: AssetImage(
                              //                           'assets/flags/${item.code.toLowerCase()}.png',
                              //                           package:
                              //                               'flutter_intl_phone_field',
                              //                         ),
                              //                         fit: BoxFit.cover,
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //             ),
                              //           )
                              //           .toList();
                              //     },
                              //     isDense: false,
                              //     isExpanded: false,
                              //     padding: EdgeInsets.zero,
                              //     iconSize: 0,
                              //     decoration: InputDecoration(
                              //       contentPadding: EdgeInsets.zero,
                              //       prefixIcon: CustomImageHandler(
                              //         AppImages.iconsAngleSmallDown,
                              //         color: Color(0xFF787878),
                              //       ),
                              //       prefixIconConstraints: BoxConstraints(
                              //         minWidth: 0,
                              //         minHeight: 0,
                              //       ),
                              //       constraints: BoxConstraints(maxWidth: 60.w),
                              //       border: InputBorder.none,
                              //     ),
                              //   ),
                              // ),
                              Container(
                                width: 1,
                                height: 30.r,
                                decoration: BoxDecoration(
                                  color: Color(0xFF99A2AC),
                                ),
                              ),
                              5.horizontalSpace,
                              // Expanded(
                              //   child: CustomDropDownFormField(
                              //     // title: AppStrings.governnorate,
                              //     hintText: AppStrings.governnorate,
                              //     icon: Icon(Icons.arrow_drop_down),
                              //     items: [
                              //       DropdownMenuItem(
                              //         value: 'القاهرة',
                              //         // alignment: Alignment.center,
                              //         child: Text('القاهرة'),
                              //       ),
                              //     ],
                              //     // items: controller.governates.value
                              //     //     .map((g) => DropdownMenuItem(
                              //     //           value: g.governorateNameAr,
                              //     //           // alignment: Alignment.center,
                              //     //           child: Text(
                              //     //             g.governorateNameAr ?? "",
                              //     //             style: CustomTextTheme.font16BlackMedium,
                              //     //           ),
                              //     //         ),)
                              //     //     .toList(),
                              //     onChanged: (p0) {
                              //       // controller.selectedCity.value = null;
                              //       // controller.selectedGovernateName.value = p0;
                              //       // controller.getCities(gName: p0);
                              //     },
                              //     // value: controller.selectedGovernateName.value,
                              //     validator: (value) {
                              //       if (value == null) {
                              //         return 'يرجي اختيار محافظة';
                              //       }
                              //       return null;
                              //     },
                              //   ),
                              // ),
                              Expanded(
                                child: DropdownButtonFormField(
                                  isExpanded: true,
                                  hint: Text(
                                    "المحافظة",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.r,
                                      fontFamily: 'Almarai',
                                      color: const Color(0xFF99A2AC),
                                    ),
                                  ),
                                  items:[],
                                  // value: controller.selectedgovernnorate.value,
                                  // items:
                                  // controller.governorates
                                  //     .map(
                                  //       (g) => DropdownMenuItem(
                                  //     value: g,
                                  //     // alignment: Alignment.center,
                                  //     child: Text(
                                  //       g.governorateNameAr,
                                  //     ),
                                  //   ),
                                  // )
                                  //     .toList(),
                                  iconSize: 0,
                                  onChanged: (value) {
                                    // controller.selectGovernorate(value);
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: CustomImageHandler(
                                      AppImages.iconsAngleSmallDown,
                                      color: Color(0xFF787878),
                                    ),
                                    prefixIconConstraints: BoxConstraints(
                                      minWidth: 0,
                                      minHeight: 0,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              8.horizontalSpace,
                              Container(
                                width: 1,
                                height: 30.r,
                                decoration: BoxDecoration(
                                  color: Color(0xFF99A2AC),
                                ),
                              ),
                              5.horizontalSpace,
                              Expanded(
                                child: DropdownButtonFormField(
                                  isExpanded: true,
                                  hint: Text(
                                    "المدينة",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.r,
                                      fontFamily: 'Almarai',
                                      color: const Color(0xFF99A2AC),
                                    ),
                                  ),
                                  // value: controller.selectedCity.value,
                                  items:[],
                                  // controller.cities
                                  //     .map(
                                  //       (c) => DropdownMenuItem(
                                  //     value: c,
                                  //     // alignment: Alignment.center,
                                  //     child: Text(c.cityNameAr),
                                  //   ),
                                  // )
                                  //     .toList(),
                                  iconSize: 0,
                                  onChanged: (value) {
                                    // controller.selectCity(value);
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: CustomImageHandler(
                                      AppImages.iconsAngleSmallDown,
                                      color: Color(0xFF787878),
                                    ),
                                    prefixIconConstraints: BoxConstraints(
                                      minWidth: 0,
                                      minHeight: 0,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              // Expanded(
                              //   child: CustomDropDownFormField(
                              //     // title: AppStrings.city,
                              //     hintText: AppStrings.city,
                              //     // value: controller.selectedCity.value,
                              //     items: [],
                              //     // items: controller.cities.value
                              //     //     .map((g) => DropdownMenuItem(
                              //     //           value: g.cityNameAr,
                              //     //           // alignment: Alignment.center,
                              //     //           child: Text(
                              //     //             g.cityNameAr ?? "",
                              //     //             style: CustomTextTheme.font16BlackMedium,
                              //     //           ),
                              //     //         ))
                              //     //     .toList(),
                              //     onChanged: (city) {
                              //       // controller.selectedCity.value = city;
                              //     },
                              //     validator: (value) {
                              //       if (value == null) {
                              //         return 'يرجي اختيار مدينة';
                              //       }
                              //       return null;
                              //     },
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      29.verticalSpace,
                      CustomButton(
                        text: 'اكتمال التسجيل',
                        onTap: () {
                          // controller.addClient();
                        },
                      ),
                      40.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
