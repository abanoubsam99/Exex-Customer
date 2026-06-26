import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/theme/app_text_styles.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_dropdown_form_field.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:evex_user/data/cubits/request_to_join/request_to_join_cubit.dart';
import 'package:evex_user/data/cubits/request_to_join/request_to_join_state.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestToJoinScreen extends StatefulWidget {
  const RequestToJoinScreen({super.key});

  @override
  State<RequestToJoinScreen> createState() => _RequestToJoinScreenState();
}

class _RequestToJoinScreenState extends State<RequestToJoinScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RequestToJoinCubit>();
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: BlocBuilder<RequestToJoinCubit, RequestToJoinState>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 0),
                    child: Row(
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
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          12.verticalSpace,
                          Text(
                            'انضم لينا كشريك نجاح لـ evex , واعرض خدماتك وعروضك لكل المستخدمين واستفيد بمميزات حصرية',
                            style: AppTextStyles.font12greyRegular
                                .copyWith(height: 1.67),
                          ),
                          18.verticalSpace,

                          // ── كارت الفورم ──
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: AppColors.borderGrey),
                            ),
                            padding: const EdgeInsets.all(14).r,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFieldBuilder(
                                  title: 'الاسم (ثلاثي)',
                                  hintText: 'مثال: الأول الأوسط الأخير',
                                  controller: cubit.nameController,
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty)
                                          ? 'هذا الحقل مطلوب'
                                          : null,
                                  fillColor: AppColors.buttonSecondaryColor,
                                ),
                                12.verticalSpace,
                                CustomDropDownFormField(
                                  title: 'نوع الخدمة',
                                  hintText: 'حدد النوع',
                                  value: state.selectedServiceType,
                                  items: state.serviceTypes
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ))
                                      .toList(),
                                  onChanged: (v) =>
                                      cubit.selectServiceType(v as String?),
                                  validator: (v) =>
                                      v == null ? 'هذا الحقل مطلوب' : null,
                                ),
                                12.verticalSpace,
                                _GovCityRow(
                                  governorates: state.governorates,
                                  cities: state.cities,
                                  selectedGov: state.selectedGovernorate,
                                  selectedCity: state.selectedCity,
                                  onGov: cubit.selectGovernorate,
                                  onCity: cubit.selectCity,
                                ),
                                12.verticalSpace,
                                TextFieldBuilder(
                                  title: 'العنوان',
                                  hintText: 'اكتب العنوان',
                                  controller: cubit.addressController,
                                  validator: (_) => null,
                                  fillColor: AppColors.buttonSecondaryColor,
                                ),
                                12.verticalSpace,
                                TextFieldBuilder(
                                  title: 'رقم الهاتف',
                                  hintText: 'رقم الهاتف',
                                  isPhone: true,
                                  controller: cubit.phoneController,
                                  countryController: cubit.countryController,
                                  fillColor: AppColors.buttonSecondaryColor,
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty)
                                          ? 'هذا الحقل مطلوب'
                                          : null,
                                ),
                                12.verticalSpace,
                                TextFieldBuilder(
                                  title: 'البريد الالكترونى',
                                  hintText: 'ادخل البريد الالكترونى',
                                  keyboardType: TextInputType.emailAddress,
                                  controller: cubit.emailController,
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty)
                                          ? 'هذا الحقل مطلوب'
                                          : null,
                                  fillColor: AppColors.buttonSecondaryColor,
                                ),
                                12.verticalSpace,
                                TextFieldBuilder(
                                  title: 'رابط الصفحة',
                                  hintText: 'مثال : صفحة فيس بوك',
                                  controller: cubit.pageLinkController,
                                  validator: (_) => null,
                                  fillColor: AppColors.buttonSecondaryColor,
                                ),
                                12.verticalSpace,
                                TextFieldBuilder(
                                  title: 'معلومات اخرى',
                                  hintText: 'شاركنا بمعلومات أخرى عنك',
                                  maxLines: 3,
                                  controller: cubit.otherInfoController,
                                  validator: (_) => null,
                                  fillColor: AppColors.buttonSecondaryColor,
                                ),
                              ],
                            ),
                          ),

                          16.verticalSpace,
                          // ── سطر اتصل بنا ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => NavigationHelper.pushNamed(
                                    Routes.contactUsScreen),
                                child: Text(
                                  'اتصل بنا',
                                  style: TextStyle(
                                    color: AppColors.blue1,
                                    fontSize: 13.r,
                                    fontFamily: 'Almarai',
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.blue1,
                                  ),
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
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 12.h),
                    child: CustomButton(
                      text: 'إرسال الطلب',
                      width: double.infinity,
                      height: 54.h,
                      isLoading: state.isLoading,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          cubit.submit();
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GovCityRow extends StatelessWidget {
  final List<Governate> governorates;
  final List<City> cities;
  final Governate? selectedGov;
  final City? selectedCity;
  final ValueChanged<Governate?> onGov;
  final ValueChanged<City?> onCity;
  const _GovCityRow({
    required this.governorates,
    required this.cities,
    required this.selectedGov,
    required this.selectedCity,
    required this.onGov,
    required this.onCity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomDropDownFormField(
            title: 'المحافظة',
            hintText: 'المحافظة',
            value: selectedGov,
            items: governorates
                .map((g) => DropdownMenuItem(
                      value: g,
                      child: Text(g.governorateNameAr ?? ''),
                    ))
                .toList(),
            onChanged: (v) => onGov(v as Governate?),
            validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: CustomDropDownFormField(
            title: 'المدينة',
            hintText: 'المدينة',
            value: selectedCity,
            items: cities
                .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c.cityNameAr ?? ''),
                    ))
                .toList(),
            onChanged: (v) => onCity(v as City?),
            validator: (v) => v == null ? 'هذا الحقل مطلوب' : null,
          ),
        ),
      ],
    );
  }
}
