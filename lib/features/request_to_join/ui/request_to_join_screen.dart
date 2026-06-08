import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/theme/app_text_styles.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/evex_text_form_field.dart';
import 'package:evex_user/core/ui/widgets/phone_field_component.dart';
import 'package:evex_user/data/cubits/request_to_join/request_to_join_cubit.dart';
import 'package:evex_user/data/cubits/request_to_join/request_to_join_state.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestToJoinScreen extends StatelessWidget {
  const RequestToJoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RequestToJoinCubit>();
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: BlocBuilder<RequestToJoinCubit, RequestToJoinState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.verticalSpace,
                  Row(
                    children: [
                      const CustomBackButtonWidget(),
                      12.horizontalSpace,
                      Expanded(
                        child: Text(
                          'طلب انضمام لشبكة تجار evex',
                          style: AppTextStyles.font18BlackExtraBoldHeader,
                        ),
                      ),
                    ],
                  ),
                  12.verticalSpace,
                  Text(
                    'انضم لينا كشريك نجاح لـ evex , واعرض خدماتك وعروضك لكل المستخدمين واستفيد بمميزات حصرية',
                    style: AppTextStyles.font14GreyRegularSubheader,
                  ),
                  20.verticalSpace,

                  // ── الكارت اللي فيه الفورم ──
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 20.h),
                    decoration: ShapeDecoration(
                      color: AppColors.whiteColor,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color(0xFFEDEDED)),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EvexTextFormField(
                          label: 'الاسم (ثلاثي)',
                          hint: 'مثال: الأول الأوسط الأخير',
                          textEditingController: cubit.nameController,
                          validator: (_) => null,
                        ),
                        16.verticalSpace,
                        _DropdownField<String>(
                          label: 'نوع الخدمة',
                          hint: 'حدد النوع',
                          value: state.selectedServiceType,
                          items: RequestToJoinCubit.serviceTypes
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: cubit.selectServiceType,
                        ),
                        16.verticalSpace,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _DropdownField<Governate>(
                                label: 'المحافظة',
                                hint: 'المحافظة',
                                value: state.selectedGovernorate,
                                items: state.governorates
                                    .map((g) => DropdownMenuItem(
                                          value: g,
                                          child: Text(g.governorateNameAr),
                                        ))
                                    .toList(),
                                onChanged: cubit.selectGovernorate,
                              ),
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: _DropdownField<City>(
                                label: 'المدينة',
                                hint: 'المدينة',
                                value: state.selectedCity,
                                items: state.cities
                                    .map((c) => DropdownMenuItem(
                                          value: c,
                                          child: Text(c.cityNameAr),
                                        ))
                                    .toList(),
                                onChanged: cubit.selectCity,
                              ),
                            ),
                          ],
                        ),
                        16.verticalSpace,
                        EvexTextFormField(
                          label: 'العنوان',
                          hint: 'اكتب العنوان',
                          textEditingController: cubit.addressController,
                          validator: (_) => null,
                        ),
                        16.verticalSpace,
                        Text('رقم الهاتف',
                            style: AppTextStyles.font16BlackRegularHeader),
                        4.verticalSpace,
                        PhoneFieldComponent(
                          hint: 'رقم الهاتف',
                          controller: cubit.phoneController,
                          countryController: cubit.countryController,
                          radius: 16,
                          fillColor: AppColors.boarderFillColor,
                          borderColor: AppColors.boarderFillColor,
                        ),
                        16.verticalSpace,
                        EvexTextFormField(
                          label: 'البريد الالكترونى',
                          hint: 'ادخل البريد الالكترونى',
                          keyboardType: TextInputType.emailAddress,
                          textEditingController: cubit.emailController,
                          validator: (_) => null,
                        ),
                        16.verticalSpace,
                        EvexTextFormField(
                          label: 'رابط الصفحة',
                          hint: 'مثال : صفحة فيس بوك',
                          textEditingController: cubit.pageLinkController,
                          validator: (_) => null,
                        ),
                        16.verticalSpace,
                        EvexTextFormField(
                          label: 'معلومات اخرى',
                          hint: 'شاركنا بمعلومات أخرى عنك',
                          maxlines: 3,
                          textEditingController: cubit.otherInfoController,
                          validator: (_) => null,
                        ),
                      ],
                    ),
                  ),

                  16.verticalSpace,
                  // ── سطر الاستفسار ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '(+20) 1220789797',
                        style: TextStyle(
                          color: const Color(0xFF2F80ED),
                          fontSize: 13.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      6.horizontalSpace,
                      Text(
                        'للاستفسار والمساعدة',
                        style: AppTextStyles.font12greyRegular,
                      ),
                      6.horizontalSpace,
                      Icon(Icons.info_outline,
                          size: 16.r, color: AppColors.grey),
                    ],
                  ),
                  20.verticalSpace,
                  CustomButton(
                    text: 'إرسال الطلب',
                    width: double.infinity,
                    height: 54.h,
                    isDisabled: state.isLoading,
                    onTap: cubit.submit,
                  ),
                  24.verticalSpace,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Dropdown بنفس شكل [EvexTextFormField] (label فوق + fill رمادي + radius 16).
class _DropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  const _DropdownField({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.font16BlackRegularHeader),
        4.verticalSpace,
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: const Color(0xFF99A2AC)),
          hint: Text(hint, style: AppTextStyles.font16GreyRegularHint),
          style: AppTextStyles.font16BlackRegularHeader,
          dropdownColor: AppColors.whiteColor,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.boarderFillColor,
            isDense: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(16.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.orangeColor),
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ],
    );
  }
}
