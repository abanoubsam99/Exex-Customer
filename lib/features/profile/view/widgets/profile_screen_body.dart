import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_endpoints.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/text_field_builder_widget.dart';
import 'package:evex_user/data/cubits/profile/profile_cubit.dart';
import 'package:evex_user/data/cubits/profile/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.4],
          colors: [Color(0xFFFEF3ED), Colors.white],
        ),
      ),
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<ProfileCubit>().getProfile();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomBackButtonWidget(),
                      InkWell(
                        onTap: () async {
                          await context.read<UserService>().logout();
                          NavigationHelper.pushNamedAndRemoveUntil(
                            Routes.loginScreen,
                          );
                        },
                        child: Container(
                          width: 40.r,
                          height: 40.r,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFFB7272),
                              width: 1.3,
                            ),
                            color: const Color(0xFFFFECEE),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: CustomImageHandler(
                            AppImages.iconsLogout,
                            height: 20.r,
                            width: 20.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final profile = state.profile;
                      return Column(
                        children: [
                          Center(
                            child: Container(
                              height: 100.r,
                              width: 100.r,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 3),
                              ),
                              child: ClipOval(
                                child: CustomImageHandler(
                                  profile?.imageName != null
                                      ? '${AppEndpoints.baseUrl}${profile!.imageName}'
                                      : AppImages.imagesNewLogo2,
                                ),
                              ),
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            profile?.userName ?? '',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w700,
                              height: 1.50,
                            ),
                          ),
                          if (profile?.userId != null)
                            Text(
                              '#${profile!.userId!.substring(profile.userId!.length - 6)}',
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                color: const Color(0xFF99A2AC),
                                fontSize: 14.r,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          12.verticalSpace,
                          16.verticalSpace,
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 16.h,
                              horizontal: 12.w,
                            ),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0xFFF2F4F7),
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: Column(
                              children: [
                                _userRowData(
                                  'الاسم الثلاثى',
                                  profile?.userName ?? '',
                                  AppImages.iconsProfile2user,
                                ),
                                _divider(),
                                _userRowData(
                                  'الهاتف',
                                  profile?.phoneNumber ?? 'NaN',
                                  AppImages.iconsPhone,
                                ),
                                _divider(),
                                _userRowData(
                                  'الايميل',
                                  profile?.email ?? 'NaN',
                                  AppImages.iconsEmail,
                                ),
                                _divider(),
                                _userRowData(
                                  'صلاحيات المستخدم',
                                  profile?.roles?.join('/') ?? 'NAN',
                                  AppImages.iconsLock,
                                ),
                                _divider(),
                                _userRowData(
                                  'العنوان',
                                  '${profile?.governorate ?? ''} - ${profile?.city ?? ''}',
                                  AppImages.iconsLocation2,
                                ),
                              ],
                            ),
                          ),
                          72.verticalSpace,
                          CustomButton(
                            text: 'تعديل البيانات الشخصيه',
                            onTap: () =>
                                NavigationHelper.pushNamed(Routes.editProfile),
                          ),
                          18.verticalSpace,
                          CustomButton(
                            bordereColor: const Color(0xff2C262C),
                            backgroundColor: Colors.white,
                            fontColor: const Color(0xff2C262C),
                            text: 'تغير كلمه المرور',
                            onTap: () {},
                          ),
                          18.verticalSpace,
                          CustomButton(
                            bordereColor: Colors.white,
                            backgroundColor: Colors.white,
                            fontColor: const Color(0xffD42D1C),
                            isfilled: false,
                            text: 'حذف الحساب',
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => _DeleteAccountDialog(
                                  cubit: context.read<ProfileCubit>(),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      width: double.infinity,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.5,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0xFFEDEDED),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
    );
  }

  Widget _userRowData(String label, String value, String icon) {
    return Row(
      children: [
        CustomImageHandler(
          icon,
          color: const Color(0xFFFFC9A9),
          height: 22.r,
          width: 22.r,
        ),
        4.horizontalSpace,
        Text(
          label,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: const Color(0xFF2C262C),
            fontSize: 14.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w400,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: const Color(0xFF99A2AC),
              fontSize: 14.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _DeleteAccountDialog extends StatefulWidget {
  final ProfileCubit cubit;
  const _DeleteAccountDialog({required this.cubit});

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  bool _showEmailField = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(18.r),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 28.r,
                    height: 28.r,
                    decoration: const ShapeDecoration(
                      color: Color(0xFFF2F4F7),
                      shape: OvalBorder(),
                    ),
                    child: Material(
                      shape: const OvalBorder(),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50.r),
                        onTap: () => NavigationHelper.pop(),
                        child: Center(
                          child: CustomImageHandler(
                            AppImages.iconsClose,
                            width: 16.r,
                            height: 16.r,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 68.r,
                height: 68.r,
                decoration: const ShapeDecoration(
                  shape: OvalBorder(
                    side: BorderSide(
                      width: 4,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0x19FE2B2C),
                    ),
                  ),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFFE2B2C),
                    shape: OvalBorder(),
                  ),
                  child: Center(
                    child: CustomImageHandler(
                      AppImages.iconsTrash,
                      color: Colors.white,
                      width: 20.r,
                      height: 20.r,
                    ),
                  ),
                ),
              ),
              22.verticalSpace,
              Text(
                'هل انت متأكد من انك تريد مسح الحساب الخاص بك نهائياً ؟',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF2C262C),
                  fontSize: 16.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w800,
                  height: 1.50,
                ),
              ),
              if (!_showEmailField) ...[
                16.verticalSpace,
                Container(
                  width: 271.r,
                  decoration: ShapeDecoration(
                    color: const Color(0x19FE2B2C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 12,
                    ).r,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: CustomImageHandler(
                            width: 14.r,
                            height: 14.r,
                            AppImages.iconsInfo2,
                          ),
                        ),
                        8.horizontalSpace,
                        Expanded(
                          child: Text(
                            'سيؤدى مسح الحساب الى مسح جميع الانشطه اللى قمت فيها طوال فتره الحساب ومسح جميع الحجوزات المتاحه والعملاء ولا يمكن نهائياً استرجاع اياً منهما لاحقاً',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: const Color(0xFF6F767E),
                              fontSize: 12.r,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w400,
                              height: 1.63,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              16.verticalSpace,
              if (_showEmailField) ...[
                TextFieldBuilder(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'اكتب البريد الإلكتروني',
                  title: 'البريد الإلكتروني',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال البريد الإلكتروني';
                    }
                    if (!value.contains('@')) {
                      return 'بريد إلكتروني غير صالح';
                    }
                    return null;
                  },
                ),
                16.verticalSpace,
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD92D20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {
                    if (!_showEmailField) {
                      setState(() => _showEmailField = true);
                    } else {
                      if (_formKey.currentState!.validate()) {
                        widget.cubit.deleteAccount(_emailController.text);
                      }
                    }
                  },
                  child: Text(
                    _showEmailField ? 'حذف الحساب نهائياً' : 'نعم، احذف حسابي',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.r,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
              ),
              8.verticalSpace,
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => NavigationHelper.pop(),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      color: const Color(0xFF2C262C),
                      fontSize: 14.r,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
