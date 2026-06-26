import 'package:evex_user/core/helpers/date_format_helper.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/cubits/edit_reservation/edit_reservation_cubit.dart';
import 'package:evex_user/data/cubits/edit_reservation/edit_reservation_state.dart';
import 'package:evex_user/data/models/addition_model.dart';
import 'package:evex_user/data/models/city.dart';
import 'package:evex_user/data/models/governate.dart';
import 'package:evex_user/features/booking_services/booking_service_details/ui/widgets/addition_item.dart';
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
                        _availabilityStatus(state),
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
                                  child: Text(g.governorateNameAr ?? '',
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
                                      Text(c.cityNameAr ?? '', style: _itemStyle)))
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
                        // ── Basic service (read-only) ──
                        _basicServiceSection(state),
                        // ── Additions & buffet (same styled rows as the
                        // booking/"adding" screen) ──
                        ..._additionsAndBuffet(cubit, state),
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
            // ── Bottom bar: total cost + save button (like the booking screen) ──
            Container(
              width: 1.sw,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 48,
                    offset: const Offset(0, -7),
                    spreadRadius: -6,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 16.h),
                child: BlocBuilder<EditReservationCubit, EditReservationState>(
                  builder: (context, state) {
                    final total = _additionsTotal(state);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              'إجمالي التكلفة',
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 18.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w800,
                                height: 1.50,
                              ),
                            ),
                            const Spacer(),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: total.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 20.r,
                                      fontFamily: 'Almarai',
                                      fontWeight: FontWeight.w800,
                                      height: 1.50,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' جنيه',
                                    style: TextStyle(
                                      color: AppColors.unitGrey,
                                      fontSize: 14.r,
                                      fontFamily: 'Almarai',
                                      fontWeight: FontWeight.w400,
                                      height: 1.50,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        12.verticalSpace,
                        CustomButton(
                          text: 'حفظ التعديلات',
                          height: 52.h,
                          isLoading: state.isSaving,
                          onTap: cubit.save,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Total shown in the bottom bar = the base service cost + the chosen
  /// additions/buffet (price × count).
  num _additionsTotal(EditReservationState state) {
    num total = state.model?.totalCost ?? 0;
    for (final a in state.additions) {
      total += (a.price ?? 0) * (state.additionCounts[a.id] ?? 0);
    }
    return total;
  }

  static String _money(num v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);

  /// "متاح / غير متاح" status for the chosen date (CheckReservationAvailability).
  Widget _availabilityStatus(EditReservationState state) {
    if (state.isCheckingAvailability) {
      return Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Row(
          children: [
            SizedBox(
              width: 14.r,
              height: 14.r,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
            8.horizontalSpace,
            Text(
              'جاري التحقق من الإتاحة...',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 12.r,
                fontFamily: 'Almarai',
              ),
            ),
          ],
        ),
      );
    }
    final av = state.availability;
    if (av == null) return const SizedBox.shrink();
    final available = av.allowedToReservation == true;
    final color = available ? AppColors.green : AppColors.coral;
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
          Container(
            width: 8.r,
            height: 8.r,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          8.horizontalSpace,
          Expanded(
            child: Text(
              available
                  ? 'متاح للحجز في هذا الميعاد'
                  : (av.verificationResultMessage ??
                      'غير متاح في هذا الميعاد'),
              style: TextStyle(
                color: color,
                fontSize: 12.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Read-only "الخدمات الأساسية" card — shows the booked service + its price.
  Widget _basicServiceSection(EditReservationState state) {
    final model = state.model;
    if (model == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        24.verticalSpace,
        _sectionHeader('الخدمات الأساسية'),
        12.verticalSpace,
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.fillGrey2),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  width: 64.r,
                  height: 64.r,
                  child: const CustomImageHandler(null, fit: BoxFit.cover),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.portName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _itemStyle,
                    ),
                    6.verticalSpace,
                    Text.rich(
                      textDirection: TextDirection.rtl,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${_money(model.totalCost)} ',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextSpan(
                            text: 'جنيه',
                            style: TextStyle(
                              color: AppColors.unitGrey,
                              fontSize: 12.r,
                              fontFamily: 'Almarai',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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

  /// The "الإضافات" + "البوفيه" sections, styled exactly like the booking
  /// ("adding") screen — same orange-bar headers and [AdditionItem] rows.
  /// Both are split out of the port's additions by [AdditionModel.specificToBuffet].
  List<Widget> _additionsAndBuffet(
    EditReservationCubit cubit,
    EditReservationState state,
  ) {
    final additions = state.additions
        .where((a) => a.id != null && a.specificToBuffet != true)
        .toList();
    final buffets = state.additions
        .where((a) => a.id != null && a.specificToBuffet == true)
        .toList();
    return [
      if (additions.isNotEmpty) ...[
        24.verticalSpace,
        _sectionHeader('الإضافات'),
        12.verticalSpace,
        ...additions.map((a) => _additionItem(cubit, state, a)),
      ],
      if (buffets.isNotEmpty) ...[
        16.verticalSpace,
        _sectionHeader('البوفيه'),
        12.verticalSpace,
        ...buffets.map((a) => _additionItem(cubit, state, a)),
      ],
    ];
  }

  /// Section title with the orange vertical bar (matches the booking screen).
  Widget _sectionHeader(String title) => Row(
        children: [
          Container(
            width: 6.r,
            height: 18.r,
            decoration: ShapeDecoration(
              color: _orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
          ),
          8.horizontalSpace,
          Text(
            title,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w700,
              letterSpacing: -0.24,
            ),
          ),
        ],
      );

  /// A single addition/buffet row reusing the booking screen's [AdditionItem]
  /// (orange +/- circular buttons, "LE" price, white rounded tile).
  Widget _additionItem(
    EditReservationCubit cubit,
    EditReservationState state,
    AdditionModel a,
  ) {
    final count = state.additionCounts[a.id] ?? 0;
    return AdditionItem(
      key: ValueKey(a.id),
      title: a.name ?? '',
      price: (a.price ?? 0).toString(),
      hasCount: a.displayNumber ?? false,
      initialCount: count,
      isSelected: count > 0,
      onChanged: () => cubit.setAdditionCount(a.id!, count > 0 ? 0 : 1),
      onChangeCount: (c) => cubit.setAdditionCount(a.id!, c),
    );
  }

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
