import 'package:evex_user/core/helpers/date_format_helper.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/data/cubits/edit_reservation/edit_reservation_cubit.dart';
import 'package:evex_user/data/cubits/edit_reservation/edit_reservation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _orange = Color(0xFFF38B4A);

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
                      color: const Color(0xFF121212),
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
                buildWhen: (p, c) => p.isLoading != c.isLoading,
                builder: (context, lstate) {
                  if (lstate.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                    _label('تاريخ المناسبة'),
                    8.verticalSpace,
                    BlocBuilder<EditReservationCubit, EditReservationState>(
                      buildWhen: (p, c) => p.occasionDate != c.occasionDate,
                      builder: (context, state) => GestureDetector(
                        onTap: () => _pickDate(context, cubit, state.occasionDate),
                        child: Container(
                          height: 52.h,
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F4F4),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
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
                                  color: const Color(0xFF2C262C),
                                  fontSize: 14.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              Icon(Icons.keyboard_arrow_down_rounded,
                                  color: const Color(0xFF99A2AC), size: 22.r),
                            ],
                          ),
                        ),
                      ),
                    ),
                    20.verticalSpace,
                    _label('ملاحظات'),
                    8.verticalSpace,
                    TextFormField(
                      controller: cubit.notesController,
                      maxLines: 4,
                      textAlign: TextAlign.start,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: const Color(0xFF2C262C),
                        fontSize: 14.r,
                        fontFamily: 'Almarai',
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF4F4F4),
                        hintText: 'اكتب ملاحظاتك هنا',
                        hintStyle: TextStyle(
                          color: const Color(0xFF99A2AC),
                          fontSize: 13.r,
                          fontFamily: 'Almarai',
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
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
          color: const Color(0xFF2C262C),
          fontSize: 15.r,
          fontFamily: 'Almarai',
          fontWeight: FontWeight.w700,
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
