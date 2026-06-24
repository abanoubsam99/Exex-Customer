import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/core/ui/widgets/custom_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/models/port_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:evex_user/core/theme/app_colors.dart';

/// Bottom sheet عرض تفاصيل خدمة واحدة (صور + اسم + سعر + الوصف الكامل).
/// بيتفتح لما المستخدم يضغط على كارت خدمة من قائمة "الخدمات الأساسية".
class ServiceDetailsBottomSheet extends StatefulWidget {
  final PortService service;
  const ServiceDetailsBottomSheet({super.key, required this.service});

  /// Helper لعرض الـ sheet بالشكل المتعارف عليه في المشروع.
  static Future<void> show(BuildContext context, PortService service) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ServiceDetailsBottomSheet(service: service),
    );
  }

  @override
  State<ServiceDetailsBottomSheet> createState() =>
      _ServiceDetailsBottomSheetState();
}

class _ServiceDetailsBottomSheetState extends State<ServiceDetailsBottomSheet> {
  final PageController _pageController = PageController();
  int _activeImage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.service.serviceImages ?? const <String>[];
    final details = widget.service.details?.trim();
    return Container(
      width: 1.sw,
      constraints: BoxConstraints(maxHeight: 0.85.sh),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 80.w,
                  height: 4.r,
                  decoration: BoxDecoration(
                    color: AppColors.borderGrey,
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
              ),
              16.verticalSpace,
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: SizedBox(
                  height: 220.h,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(child: _buildImages(images)),
                      if (images.length > 1)
                        Positioned(
                          bottom: 10.h,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: AnimatedSmoothIndicator(
                              activeIndex: _activeImage,
                              count: images.length,
                              textDirection: TextDirection.rtl,
                              effect: ExpandingDotsEffect(
                                dotHeight: 7.r,
                                dotWidth: 7.r,
                                expansionFactor: 2,
                                activeDotColor: AppColors.primaryColor,
                                dotColor: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              18.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.service.name ?? '',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.blacksoft,
                        fontSize: 18.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w800,
                        height: 1.4,
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${widget.service.price ?? 0}',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 20.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: ' جنيه',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14.r,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
              16.verticalSpace,
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    (details != null && details.isNotEmpty)
                        ? details
                        : 'لا يوجد وصف متاح لهذه الخدمة',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 13.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w400,
                      height: 1.7,
                    ),
                  ),
                ),
              ),
              16.verticalSpace,
              CustomButton(
                text: 'اغلاق',
                isfilled: false,
                height: 52.h,
                onTap: () => Navigator.pop(context),
              ),
              8.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImages(List<String> images) {
    if (images.isEmpty) {
      return const CustomImageHandler(null);
    }
    return PageView.builder(
      controller: _pageController,
      itemCount: images.length,
      onPageChanged: (i) => setState(() => _activeImage = i),
      itemBuilder: (context, i) => CustomImageHandler(
        ImageUrlHelper.full(images[i]),
        smartFill: true,
      ),
    );
  }
}
