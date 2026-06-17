import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:evex_user/data/cubits/profile/profile_cubit.dart';
import 'package:evex_user/data/cubits/profile/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return Scaffold(
      body: Container(
        height: 1.sh,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.4],
            colors: [AppColors.peachBg1, Colors.white],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        16.verticalSpace,
                        const CustomBackButtonWidget(),
                        16.verticalSpace,
                        Text(
                          'تغيير كلمه المرور',
                          style: TextStyle(
                            fontSize: 20.r,
                            color: AppColors.black,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        4.verticalSpace,
                        Text(
                          'يمكنك تغير كلمه المرور فى اى وقت واعاده التسجيل',
                          style: TextStyle(
                            fontSize: 12.r,
                            color: AppColors.grey,
                            fontFamily: 'Almarai',
                          ),
                        ),
                        24.verticalSpace,
                        Form(
                          key: cubit.changePasswordFormKey,
                          child: Column(
                            children: [
                              TextFieldBuilder(
                                isPassword: true,
                                fillColor: AppColors.buttonSecondaryColor,
                                controller: cubit.currentPasswordController,
                                title: 'كلمه المرور الحاليه',
                                hintText: 'اكتب كلمه المرور الحاليه',
                                validator: (value) =>
                                    (value == null || value.isEmpty)
                                        ? 'يرجى إدخال كلمة المرور الحالية'
                                        : null,
                              ),
                              16.verticalSpace,
                              TextFieldBuilder(
                                isPassword: true,
                                fillColor: AppColors.buttonSecondaryColor,
                                controller: cubit.newPasswordController,
                                title: 'كلمه المرور الجديده',
                                hintText: 'اكتب كلمه المرور الجديده',
                                validator: (value) =>
                                    (value == null || value.length < 6)
                                        ? 'كلمة المرور 6 أحرف على الأقل'
                                        : null,
                              ),
                              16.verticalSpace,
                              TextFieldBuilder(
                                isPassword: true,
                                fillColor: AppColors.buttonSecondaryColor,
                                controller: cubit.confirmPasswordController,
                                title: 'تأكيد كلمة المرور',
                                hintText: 'اكتب كلمه المرور الجديده',
                                validator: (value) =>
                                    value == cubit.newPasswordController.text
                                        ? null
                                        : 'كلمة المرور غير متطابقة',
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        32.verticalSpace,
                        BlocBuilder<ProfileCubit, ProfileState>(
                          builder: (context, state) => CustomButton(
                            text: 'حفظ كلمه المرور',
                            isLoading: state.isLoading,
                            onTap: () {
                              if (cubit.changePasswordFormKey.currentState!
                                  .validate()) {
                                cubit.changePassword();
                              }
                            },
                          ),
                        ),
                        18.verticalSpace,
                        CustomButton(
                          bordereColor: AppColors.blacksoft,
                          backgroundColor: Colors.white,
                          fontColor: AppColors.blacksoft,
                          text: 'الغاء',
                          onTap: () => NavigationHelper.pop(),
                        ),
                        18.verticalSpace,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
