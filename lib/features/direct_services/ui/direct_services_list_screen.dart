import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/theme/app_colors.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/data/cubits/direct_services/direct_services_list_cubit.dart';
import 'package:evex_user/data/cubits/direct_services/direct_services_list_state.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/cubits/home/home_state.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// شاشة قائمة "الخدمات المباشرة" (مسار الدفع المباشر).
class DirectServicesListScreen extends StatelessWidget {
  const DirectServicesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              context.read<DirectServicesListCubit>().loadPorts(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                16.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const CustomBackButtonWidget(),
                        12.horizontalSpace,
                        Text(
                          'الخدمات المباشرة',
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
                    8.verticalSpace,
                    Text(
                      'دلوقتي تقدر تستخدم نقاطك وتستفيد بكاش باك على كل '
                      'مشترياتك من تجار evex',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              16.verticalSpace,
              const _TypeTabs(),
              18.verticalSpace,
              const _PromoBanner(),
              20.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: BlocBuilder<DirectServicesListCubit,
                    DirectServicesListState>(
                  builder: (context, state) {
                    final items = state.portsModel?.items ?? const <Item>[];
                    if (state.isLoading && items.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (items.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Text(
                          'لا توجد نتائج متاحة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 14.r,
                            fontFamily: 'Almarai',
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => 12.verticalSpace,
                      itemBuilder: (context, index) =>
                          _PortListItem(item: items[index], index: index),
                    );
                  },
                ),
              ),
              24.verticalSpace,
            ],
          ),
          ),
        ),
      ),
    );
  }
}

/// Tabs بأنواع الخدمة (القاعات/فوتوغرافر/...). الضغط بيعيد فلترة القائمة.
class _TypeTabs extends StatelessWidget {
  const _TypeTabs();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final types = state.selectedPaymentPort?.portTypeDtos ?? const [];
        if (types.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 34.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemCount: types.length,
            separatorBuilder: (_, __) => 10.horizontalSpace,
            itemBuilder: (context, index) {
              final type = types[index];
              final isSelected = state.selectedPaymentPortType?.id == type.id;
              return Center(
                child: GestureDetector(
                  onTap: () {
                    context.read<HomeCubit>().selectPaymentPortType(type);
                    context
                        .read<DirectServicesListCubit>()
                        .changeType(type.id);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 18.w),
                    decoration: ShapeDecoration(
                      color: isSelected ? AppColors.blacksoft : Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1.5,
                          color: AppColors.blacksoft,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      type.nameAr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.blacksoft,
                        fontSize: 13.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// بانر "عروض مميزة" — ثابت مؤقتاً (مفيش API مخصص للعروض هنا).
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: SizedBox(
          height: 140.h,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomImageHandler(AppImages.imagesWedding5, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.55),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 16.w,
                bottom: 20.h,
                child: SizedBox(
                  width: 220.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'قاعه البارون',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        'الذكر مبيعاً, استمتع بخصم يصل الى 50% على جميع قاعات البارون',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.r,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 12.w,
                bottom: 16.h,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Text(
                    'عروض مميزة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
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

/// كارت بوابة في القائمة: صورة بعليها بادج "+N صوره" + اسم + وصف.
class _PortListItem extends StatelessWidget {
  final Item item;
  final int index;
  const _PortListItem({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final imageOnRight = index % 2 == 0;
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        width: 113.w,
        height: 137.h,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomImageHandler(
                _firstImageUrl(item) ?? AppImages.imagesWedding5,
                fit: BoxFit.cover,
                errorIcon: const Icon(Icons.image_not_supported),
              ),
            ),
            Positioned(
              bottom: 8.h,
              left: 8.w,
              right: 8.w,
              child: _imagesBadge(item),
            ),
          ],
        ),
      ),
    );

    final panel = Expanded(
      child: Container(
        height: 110.h,
        decoration: ShapeDecoration(
          color: AppColors.dividerGreyAlpha33,
          shape: RoundedRectangleBorder(
            borderRadius: imageOnRight
                ? BorderRadius.horizontal(left: Radius.circular(16.r))
                : BorderRadius.horizontal(right: Radius.circular(16.r)),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              item.portName ?? '',
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.blacksoft,
                fontSize: 15.r,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                letterSpacing: -0.24,
              ),
            ),
            6.verticalSpace,
            Expanded(
              child: Text(
                _subtitle(item),
                textAlign: TextAlign.right,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.grey2,
                  fontSize: 12.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      onTap: () => NavigationHelper.pushNamed(
        Routes.directServiceDetailsScreen,
        arguments: item,
      ),
      child: Row(
        children: imageOnRight ? [panel, image] : [image, panel],
      ),
    );
  }

  Widget _imagesBadge(Item item) {
    final count = _portImages(item).length;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageHandler(
            AppImages.iconsFolder,
            width: 13.r,
            height: 13.r,
            color: AppColors.primaryColor,
          ),
          4.horizontalSpace,
          Text(
            '+$count صوره',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 11.r,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

List<String> _portImages(Item item) {
  final imgs = item.portImages;
  if (imgs is List) {
    return imgs
        .map((e) => e.toString())
        .where((e) => e.trim().isNotEmpty)
        .toList();
  }
  return const [];
}

String? _firstImageUrl(Item item) {
  final imgs = _portImages(item);
  if (imgs.isEmpty) return null;
  return ImageUrlHelper.full(imgs.first);
}

String _subtitle(Item item) {
  final desc = item.portDescription?.toString().trim();
  if (desc != null && desc.isNotEmpty) return desc;
  return [item.governorate, item.city]
      .where((e) => e != null && e.isNotEmpty)
      .join('، ');
}
