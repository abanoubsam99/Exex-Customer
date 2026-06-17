import 'package:evex_user/core/helpers/date_format_helper.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/data/cubits/edit_reservation/edit_reservation_cubit.dart';
import 'package:evex_user/data/cubits/edit_reservation/edit_reservation_state.dart';
import 'package:evex_user/data/models/addition_model.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

const _orange = AppColors.primaryColor;

class EditReservationScreen extends StatelessWidget {
  const EditReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditReservationCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 0),
              child: Row(
                children: [
                  const CustomBackButtonWidget(),
                  12.horizontalSpace,
                  Text(
                    'تعديل الحجز',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 18.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<EditReservationCubit, EditReservationState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Occasion date ──
                        _label('تاريخ المناسبة'),
                        8.verticalSpace,
                        GestureDetector(
                          onTap: () =>
                              _pickDate(context, cubit, state.occasionDate),
                          child: _fieldBox(
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today_outlined,
                                    color: _orange, size: 18.r),
                                10.horizontalSpace,
                                Text(
                                  state.occasionDate != null
                                      ? DateFormatHelper.arabicDate(
                                          state.occasionDate!.toIso8601String())
                                      : 'حدد التاريخ',
                                  style: TextStyle(
                                    color: AppColors.blacksoft,
                                    fontSize: 14.r,
                                    fontFamily: 'Almarai',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Spacer(),
                                Icon(Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.blueGrey, size: 22.r),
                              ],
                            ),
                          ),
                        ),
                        20.verticalSpace,
                        // ── Governorate ──
                        _label('المحافظة'),
                        8.verticalSpace,
                        _dropdownField<Governate>(
                          hint: 'اختر المحافظة',
                          value: state.selectedGovernorate,
                          items: state.governorates
                              .map((g) => DropdownMenuItem(
                                  value: g,
                                  child: Text(g.governorateNameAr,
                                      style: _itemStyle)))
                              .toList(),
                          onChanged: cubit.selectGovernorate,
                        ),
                        20.verticalSpace,
                        // ── City ──
                        _label('المدينة'),
                        8.verticalSpace,
                        _dropdownField<City>(
                          hint: state.isLoadingCities
                              ? 'جاري التحميل...'
                              : 'اختر المدينة',
                          value: state.selectedCity,
                          items: state.cities
                              .map((c) => DropdownMenuItem(
                                  value: c,
                                  child:
                                      Text(c.cityNameAr, style: _itemStyle)))
                              .toList(),
                          onChanged: state.selectedGovernorate == null
                              ? null
                              : cubit.selectCity,
                        ),
                        20.verticalSpace,
                        // ── Occasion type ──
                        _label('نوع المناسبة'),
                        8.verticalSpace,
                        _dropdownField<int>(
                          hint: 'حدد نوع المناسبة',
                          // Guard: the bill sets the occasion id before the list
                          // loads — only bind the value once it exists in items.
                          value: state.occasions.any(
                                  (o) => o.id == state.selectedOccasionId)
                              ? state.selectedOccasionId
                              : null,
                          items: state.occasions
                              .where((o) => o.id != null)
                              .map((o) => DropdownMenuItem(
                                  value: o.id,
                                  child: Text(o.name ?? '', style: _itemStyle)))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) cubit.selectOccasion(v);
                          },
                        ),
                        // ── Additions ──
                        if (state.additions.isNotEmpty) ...[
                          20.verticalSpace,
                          _label('الإضافات'),
                          8.verticalSpace,
                          ...state.additions.where((a) => a.id != null).map(
                                (a) => Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: _additionTile(cubit, a,
                                      state.additionCounts[a.id] ?? 0),
                                ),
                              ),
                        ],
                        // ── Notes ──
                        20.verticalSpace,
                        _label('ملاحظات'),
                        8.verticalSpace,
                        TextFormField(
                          controller: cubit.notesController,
                          maxLines: 4,
                          textAlign: TextAlign.start,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: AppColors.blacksoft,
                            fontSize: 14.r,
                            fontFamily: 'Almarai',
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.boarderFillColor,
                            hintText: 'اكتب ملاحظاتك هنا',
                            hintStyle: TextStyle(
                              color: AppColors.blueGrey,
                              fontSize: 13.r,
                              fontFamily: 'Almarai',
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 14.w, vertical: 14.h),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: _orange),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 16.h),
              child: BlocBuilder<EditReservationCubit, EditReservationState>(
                buildWhen: (p, c) => p.isSaving != c.isSaving,
                builder: (context, state) => CustomButton(
                  text: 'حفظ التعديلات',
                  height: 54.h,
                  isLoading: state.isSaving,
                  onTap: cubit.save,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: TextStyle(
          color: AppColors.blacksoft,
          fontSize: 15.r,
          fontFamily: 'Almarai',
          fontWeight: FontWeight.w700,
        ),
      );

  TextStyle get _itemStyle => TextStyle(
        color: AppColors.blacksoft,
        fontSize: 14.r,
        fontFamily: 'Almarai',
        fontWeight: FontWeight.w700,
      );

  /// Filled rounded box used by every field (matches the rest of the screen).
  Widget _fieldBox({required Widget child}) => Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: AppColors.boarderFillColor,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: child,
      );

  /// A styled dropdown inside the shared field box. `onChanged: null` disables it.
  Widget _dropdownField<T>({
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?>? onChanged,
  }) =>
      _fieldBox(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            isExpanded: true,
            value: value,
            borderRadius: BorderRadius.circular(14.r),
            hint: Text(
              hint,
              style: TextStyle(
                color: AppColors.blueGrey,
                fontSize: 14.r,
                fontFamily: 'Almarai',
              ),
            ),
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.blueGrey),
            items: items,
            onChanged: onChanged,
          ),
        ),
      );

  /// A single addition row: name + price with a +/- stepper (quantity additions)
  /// or a tick toggle (gift / single additions).
  Widget _additionTile(EditReservationCubit cubit, AdditionModel a, int count) {
    final id = a.id!;
    final isCounter = a.displayNumber == true;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.boarderFillColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  a.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _itemStyle,
                ),
                if ((a.price ?? 0) > 0)
                  Text(
                    '${a.price} جنيه',
                    style: TextStyle(
                      color: AppColors.blueGrey,
                      fontSize: 12.r,
                      fontFamily: 'Almarai',
                    ),
                  ),
              ],
            ),
          ),
          if (isCounter)
            Row(
              children: [
                _circleBtn(Icons.remove,
                    () => cubit.setAdditionCount(id, count - 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text('$count', style: _itemStyle),
                ),
                _circleBtn(
                    Icons.add, () => cubit.setAdditionCount(id, count + 1)),
              ],
            )
          else
            GestureDetector(
              onTap: () => cubit.setAdditionCount(id, count > 0 ? 0 : 1),
              child: Icon(
                count > 0 ? Icons.check_box : Icons.check_box_outline_blank,
                color: _orange,
                size: 24.r,
              ),
            ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 26.r,
          height: 26.r,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderGrey),
          ),
          child: Icon(icon, size: 16.r, color: _orange),
        ),
      );

  Future<void> _pickDate(
    BuildContext context,
    EditReservationCubit cubit,
    DateTime? current,
  ) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('ar'),
      initialDate: (current != null && current.isAfter(now)) ? current : now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) cubit.setDate(picked);
  }
}
