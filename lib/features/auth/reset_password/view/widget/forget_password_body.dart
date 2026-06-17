import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:evex_user/data/cubits/auth/forget_password/forget_password_cubit.dart';
import 'package:evex_user/data/cubits/auth/forget_password/forget_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordBody extends StatelessWidget {
  const ForgetPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgetPasswordCubit>();
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
              fillColor: AppColors.boarderFillColor,
              bgColor: AppColors.whiteColor,
              keyboardType: TextInputType.phone,
              padding: const EdgeInsets.only(top: 8),
              isPhone: true,
            ),
            34.verticalSpace,
            BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
              builder: (context, state) => CustomButton(
                text: "إرسال الرمز",
                isLoading: state is ForgetPasswordLoading,
                onTap: () {
                  if (cubit.formKey.currentState!.validate()) {
                    cubit.forgetPassword();
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
