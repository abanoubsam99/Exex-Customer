import 'package:evex_user/core/ui/widgets/top_backround.dart';
import 'package:evex_user/features/auth/add_phone/logic/controller/add_phone_controller.dart';
import 'package:evex_user/features/auth/add_phone/view/widget/add_phone_body.dart';
import 'package:evex_user/features/auth/add_phone/view/widget/add_phone_top_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddPhoneScreen extends GetView<AddPhoneController> {
  const AddPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            TopBackround(height: 390.h),
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // color: Colors.red,
                      // height: 200.h,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: AddPhoneTopPart(),
                    ),
                    24.verticalSpace,
                    Container(
                      width: double.infinity,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.r),
                            topRight: Radius.circular(40.r),
                          ),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 54,
                            offset: Offset(0, -6),
                            spreadRadius: -30,
                          ),
                        ],
                      ),
                      child: AddPhoneBody(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
