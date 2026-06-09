import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:evex_user/data/cubits/auth/add_phone/add_phone_cubit.dart';
import 'package:evex_user/data/cubits/auth/add_phone/add_phone_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPhoneBody extends StatelessWidget {
  const AddPhoneBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddPhoneCubit>();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 38.0.w),
      child: Form(
        key: cubit.formKey,
        child: Column(
          children: [
            TextFieldBuilder(
              controller: cubit.phoneController,
              countryController: cubit.countryCodeController,
              title: 'رقم الهاتف',
              fillColor: const Color(0xFFF4F4F4),
              bgColor: AppColors.whiteColor,
              keyboardType: TextInputType.phone,
              padding: const EdgeInsets.only(top: 8),
              isPhone: true,
            ),
            34.verticalSpace,
            BlocBuilder<AddPhoneCubit, AddPhoneState>(
              builder: (context, state) => CustomButton(
                text: "إرسال الرمز",
                isLoading: state is AddPhoneLoading,
                onTap: () {
                  if (cubit.formKey.currentState!.validate()) {
                    cubit.addPhone();
                  }
                },
                backgroundColor: AppColors.lightPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
