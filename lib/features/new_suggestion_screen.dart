import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/theme/app_text_styles.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_dropdown_form_field.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:evex_user/core/ui/widgets/title_inbox.dart';
import 'package:evex_user/data/cubits/new_suggestion/new_suggestion_cubit.dart';
import 'package:evex_user/data/models/occasion.dart';
import 'package:evex_user/data/cubits/new_suggestion/new_suggestion_state.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewSuggestionScreen extends StatefulWidget {
  const NewSuggestionScreen({super.key});

  @override
  State<NewSuggestionScreen> createState() => _NewSuggestionScreenState();
}

class _NewSuggestionScreenState extends State<NewSuggestionScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NewSuggestionCubit>();
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: BlocBuilder<NewSuggestionCubit, NewSuggestionState>(
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
                        Text('اقتراح جديد',
                            style: AppTextStyles.font18BlackExtraBoldHeader),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.verticalSpace,
                          Text(
                            'دورت على تاجر أو مقدم خدمة معين ومالقيتهوش ؟\nشاركنا بمعلومات عنه وسيب الباقي علينا',
                            style: AppTextStyles.font12greyRegular
                                .copyWith(height: 1.67),
                          ),
                          18.verticalSpace,

                          // ── كارت: معلومات عن التاجر ──
                          _Card(
                            title: 'معلومات عن التاجر',
                            children: [
                              TextFieldBuilder(
                                title: 'اسم التاجر أو مقدم الخدمة',
                                hintText: 'بيشوى باسم',
                                controller: cubit.nameController,
                                validator: (v) => (v == null || v.trim().isEmpty)
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
                                cities: state.merchantCities,
                                selectedGov: state.selectedMerchantGov,
                                selectedCity: state.selectedMerchantCity,
                                onGov: cubit.selectMerchantGov,
                                onCity: cubit.selectMerchantCity,
                                required: true,
                              ),
                              12.verticalSpace,
                              TextFieldBuilder(
                                title: 'رقم الهاتف',
                                hintText: 'رقم الهاتف',
                                isPhone: true,
                                controller: cubit.phoneController,
                                countryController: cubit.countryController,
                                fillColor: AppColors.buttonSecondaryColor,
                                validator: (v) => (v == null || v.trim().isEmpty)
                                    ? 'هذا الحقل مطلوب'
                                    : null,
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
                                title: 'رابط الصفحة',
                                hintText: 'مثال : صفحة فيس بوك',
                                controller: cubit.pageLinkController,
                                validator: (_) => null,
                                fillColor: AppColors.buttonSecondaryColor,
                              ),
                            ],
                          ),
                          20.verticalSpace,

                          // ── كارت: بيانات المناسبة ──
                          _Card(
                            title: 'بيانات المناسبة المراد حجزها',
                            children: [
                              CustomDropDownFormField(
                                title: 'نوع المناسبة',
                                hintText: 'حدد نوع المناسبة',
                                value: state.selectedOccasion,
                                items: state.occasions
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e.name ?? ''),
                                        ))
                                    .toList(),
                                onChanged: (v) =>
                                    cubit.selectOccasion(v as Occasion?),
                              ),
                              12.verticalSpace,
                              TextFieldBuilder(
                                title: 'تاريخ المناسبة',
                                hintText: 'حدد تاريخ المناسبة',
                                isDatePicker: true,
                                readOnly: true,
                                controller: cubit.occasionDateController,
                                validator: (_) => null,
                                fillColor: AppColors.buttonSecondaryColor,
                                minDate: DateTime.now().add(
                                    const Duration(days: 7)),
                              ),
                              12.verticalSpace,
                              _GovCityRow(
                                governorates: state.governorates,
                                cities: state.eventCities,
                                selectedGov: state.selectedEventGov,
                                selectedCity: state.selectedEventCity,
                                onGov: cubit.selectEventGov,
                                onCity: cubit.selectEventCity,
                                required: false,
                              ),
                            ],
                          ),
                          24.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 12.h),
                    child: CustomButton(
                      text: 'إرسال الإقتراح',
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

/// كارت بحدود + هيدر رمادي ([TitleInBox]) زي بقية الفورمات.
class _Card extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Card({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleInBox(title: title),
          Padding(
            padding: const EdgeInsets.all(14).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

/// صف المحافظة + المدينة (يمين: محافظة / يسار: مدينة).
class _GovCityRow extends StatelessWidget {
  final List<Governate> governorates;
  final List<City> cities;
  final Governate? selectedGov;
  final City? selectedCity;
  final ValueChanged<Governate?> onGov;
  final ValueChanged<City?> onCity;
  final bool required;
  const _GovCityRow({
    required this.governorates,
    required this.cities,
    required this.selectedGov,
    required this.selectedCity,
    required this.onGov,
    required this.onCity,
    this.required = false,
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
            icon: CustomImageHandler(AppImages.iconsArrowDown, width: 18),
            items: governorates
                .map((g) => DropdownMenuItem(
                      value: g,
                      child: Text(g.governorateNameAr ?? ''),
                    ))
                .toList(),
            onChanged: (v) => onGov(v as Governate?),
            validator: required
                ? (v) => v == null ? 'هذا الحقل مطلوب' : null
                : null,
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: CustomDropDownFormField(
            title: 'المدينة',
            hintText: 'المدينة',
            value: selectedCity,
            icon: CustomImageHandler(AppImages.iconsArrowDown, width: 18),
            items: cities
                .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c.cityNameAr ?? ''),
                    ))
                .toList(),
            onChanged: (v) => onCity(v as City?),
            validator: required
                ? (v) => v == null ? 'هذا الحقل مطلوب' : null
                : null,
          ),
        ),
      ],
    );
  }
}
