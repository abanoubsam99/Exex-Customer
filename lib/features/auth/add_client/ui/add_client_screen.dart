import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:evex_user/core/localization/app_strings.dart';
import 'package:evex_user/core/ui/widgets/country_picker.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:evex_user/data/cubits/auth/add_client/add_client_cubit.dart';
import 'package:evex_user/data/cubits/auth/add_client/add_client_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class AddClientScreen extends StatelessWidget {
  const AddClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddClientCubit>();
    return Scaffold(
      body: SizedBox(
        height: 1.sh,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: const Alignment(1.5, -1),
                    end: const Alignment(-1, 0.2),
                    colors: [
                      AppColors.peachOrange.withValues(alpha: 0),
                      Colors.white,
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 493.h,
              width: double.infinity,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: CustomImageHandler(
                    AppImages.imagesFamily,
                    fit: BoxFit.cover,
                    width: 1.2.sw,
                    height: 1.sh,
                    alignment: const Alignment(0.8, 0),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0.h,
              child: Container(
                width: 1.sw,
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(65),
                      topRight: Radius.circular(65),
                    ),
                  ),
                  shadows: [
                    BoxShadow(
                      color: AppColors.blackAlpha66,
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
                  child: BlocBuilder<AddClientCubit, AddClientState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'أهلا بيك وسط عيلتك ..',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: AppColors.blacksoft,
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
                            controller: cubit.nameController,
                          ),
                          12.verticalSpace,
                          Text(
                            'المنطقة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.blacksoft,
                              fontSize: 14.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                              letterSpacing: -0.24,
                            ),
                          ),
                          Container(
                            width: 1.sw,
                            decoration: ShapeDecoration(
                              color: AppColors.boarderFillColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Row(
                                children: [
                                  // Country flag selector
                                  DropdownButtonFormField2(
                                    value: customCountries.first,
                                    items: customCountries.map((e) {
                                      return DropdownMenuItem(
                                        value: e,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 30.r,
                                              height: 30.r,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    'assets/flags/${e.code.toLowerCase()}.png',
                                                    package:
                                                        'flutter_intl_phone_field',
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (_) {},
                                    selectedItemBuilder: (_) => customCountries
                                        .map(
                                          (item) => Center(
                                            child: Container(
                                              width: 30.r,
                                              height: 30.r,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    'assets/flags/${item.code.toLowerCase()}.png',
                                                    package:
                                                        'flutter_intl_phone_field',
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    isDense: false,
                                    isExpanded: false,
                                    iconStyleData: const IconStyleData(
                                      iconSize: 0,
                                    ),
                                    dropdownStyleData: const DropdownStyleData(
                                      width: 300,
                                      maxHeight: 400,
                                    ),
                                    buttonStyleData: const ButtonStyleData(
                                      padding: EdgeInsets.zero,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      prefixIcon: CustomImageHandler(
                                        AppImages.iconsAngleSmallDown,
                                        color: AppColors.grey2,
                                      ),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                            minWidth: 0,
                                            minHeight: 0,
                                          ),
                                      constraints:
                                          BoxConstraints(maxWidth: 60.w),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 30.r,
                                    color: AppColors.blueGrey,
                                  ),
                                  5.horizontalSpace,
                                  // Governorate dropdown
                                  Expanded(
                                    child: DropdownButtonFormField<Governate>(
                                      isExpanded: true,
                                      hint: Text(
                                        AppStrings.governnorate.tr(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.r,
                                          fontFamily: 'Almarai',
                                          color: AppColors.blueGrey,
                                        ),
                                      ),
                                      value: state.selectedGovernorate,
                                      items: state.governorates
                                          .map(
                                            (g) => DropdownMenuItem(
                                              value: g,
                                              child:
                                                  Text(g.governorateNameAr ?? ''),
                                            ),
                                          )
                                          .toList(),
                                      iconSize: 0,
                                      onChanged: cubit.selectGovernorate,
                                      decoration: InputDecoration(
                                        prefixIcon: CustomImageHandler(
                                          AppImages.iconsAngleSmallDown,
                                          color: AppColors.grey2,
                                        ),
                                        prefixIconConstraints:
                                            const BoxConstraints(
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
                                    color: AppColors.blueGrey,
                                  ),
                                  5.horizontalSpace,
                                  // City dropdown
                                  Expanded(
                                    child: DropdownButtonFormField<City>(
                                      isExpanded: true,
                                      hint: Text(
                                        AppStrings.city.tr(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.r,
                                          fontFamily: 'Almarai',
                                          color: AppColors.blueGrey,
                                        ),
                                      ),
                                      value: state.selectedCity,
                                      items: state.cities
                                          .map(
                                            (c) => DropdownMenuItem(
                                              value: c,
                                              child: Text(c.cityNameAr ?? ''),
                                            ),
                                          )
                                          .toList(),
                                      iconSize: 0,
                                      onChanged: cubit.selectCity,
                                      decoration: InputDecoration(
                                        prefixIcon: CustomImageHandler(
                                          AppImages.iconsAngleSmallDown,
                                          color: AppColors.grey2,
                                        ),
                                        prefixIconConstraints:
                                            const BoxConstraints(
                                              minWidth: 0,
                                              minHeight: 0,
                                            ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          29.verticalSpace,
                          CustomButton(
                            text: 'اكتمال التسجيل',
                            isLoading: state.isLoading,
                            onTap: cubit.addClient,
                          ),
                          40.verticalSpace,
                        ],
                      );
                    },
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
