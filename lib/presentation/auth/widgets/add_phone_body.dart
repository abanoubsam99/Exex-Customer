
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/constants/MyColors.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../app/widgets/text_field_builder_widget.dart';

class AddPhoneBody extends StatelessWidget  {
  const AddPhoneBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 38.0.w),
      child: Form(
        // key: controller.formKey,
        child: Column(
          children: [
            TextFieldBuilder(
              // controller: controller.phoneController,
              // countryController: controller.countryCodeController,
              title: 'رقم الهاتف',
              fillColor: Color(0xFFF4F4F4),
              bgColor: AppColors.whiteColor,
              keyboardType: TextInputType.phone,
              padding: const EdgeInsets.only(top: 8),
              isPhone: true,
            ),
            34.verticalSpace,
            CustomButton(
              text: "إرسال الرمز",
              onTap: () {
                // if (controller.formKey.currentState!.validate()) {
                //   controller.addPhone();
                // }
              },
              backgroundColor: AppColors.lightPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
