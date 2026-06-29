import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/cubits/main/main_cubit.dart';
import 'package:evex_user/data/cubits/main/main_state.dart';
import 'package:evex_user/data/cubits/wallet/wallet_cubit.dart';
import 'package:evex_user/data/cubits/wallet/wallet_state.dart';
import 'package:evex_user/data/repos/wallet_repo.dart';
import 'package:evex_user/features/wallet/ui/widgets/wallet_password_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WalletCubit(context.read<WalletRepo>())..getWalletData(),
      child: const _WalletView(),
    );
  }
}

class _WalletView extends StatefulWidget {
  const _WalletView();

  @override
  State<_WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<_WalletView> {
  /// Guards against stacking the PIN dialog when one is already open.
  bool _passwordDialogOpen = false;

  /// Prompts the user to create a wallet PIN when the backend reports
  /// `passwordChanged == false`. Only fires on an explicit false (not null/true)
  /// and never while a dialog is already open.
  void _maybePromptForPin(BuildContext context, WalletState state) {
    if (_passwordDialogOpen) return;
    final data = state.data;
    if (data == null || data.passwordChanged != false) return;
    _passwordDialogOpen = true;
    final cubit = context.read<WalletCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showWalletPasswordDialog(context, walletCubit: cubit);
      _passwordDialogOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Re-entering the wallet tab refreshes the data; the WalletCubit
        // listener below then re-prompts for a PIN if one still isn't set.
        BlocListener<MainCubit, MainState>(
          listenWhen: (p, c) => p.currentPage != c.currentPage,
          listener: (context, mainState) {
            if (mainState.currentPage == 2) {
              context.read<WalletCubit>().getWalletData();
            }
          },
        ),
        BlocListener<WalletCubit, WalletState>(listener: _maybePromptForPin),
      ],
      child: Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomBackButtonWidget(
                    onTap: () {
                      context.read<MainCubit>().goToTab(0);
                    },
                  ),
                  12.horizontalSpace,
                  Text(
                    'محفظة evex',
                    textAlign: TextAlign.right,
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
              24.verticalSpace,
              Container(
                width: 1.sw,
                height: 133.h,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.purple1.withValues(alpha: 0.7),
                      AppColors.purple3.withValues(alpha: 0.7),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 14.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'عروض محفظة evex',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w800,
                                height: 1.33,
                                letterSpacing: -0.24,
                              ),
                            ),
                            12.verticalSpace,
                            Text(
                              'دلوقتي تقدر تستفيد من نقاطك لما تدفع كاش لأى منتج أو خدمة من الخدمات المباشرة',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.67,
                                letterSpacing: -0.24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16.w,
                        top: 13.h,
                        bottom: 8.h,
                      ),
                      child: CustomImageHandler(
                        AppImages.imagesCoin,
                        // height: 112.r,
                        // width: 112.r,
                      ),
                    ),
                  ],
                ),
              ),
              24.verticalSpace,
              Row(
                children: [
                  Container(
                    width: 6.r,
                    height: 18.r,
                    decoration: ShapeDecoration(
                      color: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                  ),
                  8.horizontalSpace,
                  Text(
                    'معلومات النقاط',
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
              ),
              16.verticalSpace,
              BlocBuilder<WalletCubit, WalletState>(
                builder: (context, state) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 155.r,
                    height: 65.r,
                    decoration: ShapeDecoration(
                      color: AppColors.boarderColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${state.data?.numberOfPoints ?? 0}',
                                style: TextStyle(
                                  color: AppColors.green3,
                                  fontSize: 18.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.24,
                                ),
                              ),
                              TextSpan(
                                text: ' ',
                                style: TextStyle(
                                  color: AppColors.green3,
                                  fontSize: 18.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.24,
                                ),
                              ),
                              TextSpan(
                                text: 'نقطة',
                                style: TextStyle(
                                  color: AppColors.blueGrey,
                                  fontSize: 14.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          'رصيد النقاط',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: AppColors.blacksoft,
                            fontSize: 14.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  17.horizontalSpace,
                  Container(
                    width: 155.r,
                    height: 65.r,
                    decoration: ShapeDecoration(
                      color: AppColors.boarderColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${state.data?.pointsValue ?? 0}',
                                style: TextStyle(
                                  color: AppColors.periwinkle,
                                  fontSize: 18.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.24,
                                ),
                              ),
                              TextSpan(
                                text: ' ',
                                style: TextStyle(
                                  color: AppColors.periwinkle,
                                  fontSize: 18.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.24,
                                ),
                              ),
                              TextSpan(
                                text: 'جنيه',
                                style: TextStyle(
                                  color: AppColors.blueGrey,
                                  fontSize: 14.r,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          'قيمة النقاط',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: AppColors.blacksoft,
                            fontSize: 14.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ),
              32.verticalSpace,

              Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: CustomImageHandler(
                        AppImages.iconsInfo,
                        width: 16.r,
                        height: 16.r,
                      ),
                    ),
                    TextSpan(
                      text:
                          '  ينصح بتغيير الرقم السري للمحفظة بشكل دوري لضمان مستوى الأمان',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                        height: 1.69,
                        letterSpacing: -0.24,
                      ),
                    ),
                    TextSpan(
                      text: ' ',
                      style: TextStyle(
                        color: AppColors.blue3,
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        height: 1.69,
                        letterSpacing: -0.24,
                      ),
                    ),
                    TextSpan(
                      text: 'تغيير كلمة المرور للمحفظة',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        height: 1.69,
                        letterSpacing: -0.24,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              showWalletPasswordDialog(
                                context,
                                walletCubit: context.read<WalletCubit>(),
                                isChange: true,
                              );
                            },
                    ),
                    // WidgetSpan(
                    //   child: TextButton(
                    //     onPressed: () {},
                    //     child: Text(
                    //       'تغيير كلمة المرور للمحفظة',
                    //       style: TextStyle(
                    //         color: AppColors.primaryColor,
                    //         fontSize: 13,
                    //         fontFamily: 'Almarai',
                    //         fontWeight: FontWeight.w700,
                    //         height: 1.69,
                    //         letterSpacing: -0.24,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              16.verticalSpace,
              // Text.rich(
              //   TextSpan(
              //     children: [
              //       WidgetSpan(
              //         alignment: PlaceholderAlignment.top,
              //         child: CustomImageHandler(
              //           AppImages.iconsInfo,
              //           width: 16.r,
              //           height: 16.r,
              //         ),
              //       ),
              //       TextSpan(
              //         text:
              //             '  يمكنك اسخدام الرصيد النقدي فقط في خدمات الحجز الفوري ويمكنك استخدام قيمة النقاط فقط في خدمات الدفع المباشر',
              //         style: TextStyle(
              //           color: AppColors.grey,
              //           fontSize: 13.r,
              //           fontFamily: 'Almarai',
              //           fontWeight: FontWeight.w400,
              //           height: 1.69,
              //           letterSpacing: -0.24,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
