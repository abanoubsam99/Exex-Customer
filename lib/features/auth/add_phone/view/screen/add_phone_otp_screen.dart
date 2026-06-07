import 'package:evex_user/core/ui/widgets/top_backround.dart';
import 'package:evex_user/data/cubits/auth/add_phone/add_phone_cubit.dart';
import 'package:evex_user/features/auth/add_phone/view/widget/add_phone_otp_body.dart';
import 'package:evex_user/features/auth/add_phone/view/widget/add_phone_otp_top_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPhoneOtpScreen extends StatefulWidget {
  const AddPhoneOtpScreen({super.key});

  @override
  State<AddPhoneOtpScreen> createState() => _AddPhoneOtpScreenState();
}

class _AddPhoneOtpScreenState extends State<AddPhoneOtpScreen> {
  String _phone = '';

  @override
  void initState() {
    super.initState();
    _phone = ModalRoute.of(context)?.settings.arguments as String? ?? '';
    context.read<AddPhoneCubit>().initOtpScreen(_phone);
  }

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
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: AddPhoneOtpTopPart(phone: _phone),
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
                        shadows: const [
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 54,
                            offset: Offset(0, -6),
                            spreadRadius: -30,
                          ),
                        ],
                      ),
                      child: const AddPhoneOtpBody(),
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
