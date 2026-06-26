import 'package:evex_user/app/helpers/navigation_helper.dart';
import 'package:evex_user/core/constants/app_images.dart';
import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/ui/widgets/confirm_dialog.dart';
import 'package:evex_user/core/ui/widgets/custom_back_button.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/empty_list_widget.dart';
import 'package:evex_user/data/cubits/favorites/favorites_cubit.dart';
import 'package:evex_user/data/cubits/favorites/favorites_state.dart';
import 'package:evex_user/data/cubits/home/home_cubit.dart';
import 'package:evex_user/data/cubits/home/home_state.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

const _orange = AppColors.primaryColor;
const _coral = AppColors.salmon3;

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const CustomBackButtonWidget(),
                        12.horizontalSpace,
                        Text(
                          'تفضيلاتي',
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
                    16.verticalSpace,
                    const _IntroCard(),
                    8.verticalSpace,
                    TabBar(
                      labelColor: AppColors.blacksoft,
                      unselectedLabelColor: AppColors.grey,
                      indicatorColor: _orange,
                      indicatorSize: TabBarIndicatorSize.label,
                      dividerColor: AppColors.lineGrey,
                      labelStyle: TextStyle(
                        fontSize: 14.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 14.r,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w400,
                      ),
                      tabs: const [
                        Tab(text: 'خدمات الحجز الفوري'),
                        Tab(text: 'الخدمات المباشرة'),
                      ],
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    // الحجز الفوري (subscriptionType == 0)
                    _FavList(isDirect: false),
                    // الخدمات المباشرة (subscriptionType == 1)
                    _FavList(isDirect: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.peachBg4, AppColors.lightestPrimaryColor],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Icon(Icons.favorite, color: _orange, size: 40.r),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تفضيلاتي',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.blacksoft,
                    fontSize: 16.r,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                10.verticalSpace,
                Text(
                  'محتار ولسه بتختار ؟\n ضيف كل التجار المفضلين ليك هنا وقارن بسهولة',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12.r,
                    fontFamily: 'Almarai',
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          12.horizontalSpace,
          Image.asset(AppImages.iconsFavicon),

        ],
      ),
    );
  }
}

class _FavList extends StatelessWidget {
  /// `false` → instant-booking tab (subscriptionType 0),
  /// `true`  → direct-services tab (subscriptionType 1).
  final bool isDirect;
  const _FavList({required this.isDirect});

  @override
  Widget build(BuildContext context) {
    // Categories tell us which favorite belongs to which tab. They live in the
    // app-wide HomeCubit, so watch it to re-split once they finish loading.
    final home = context.watch<HomeCubit>().state;
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state.isLoading && state.favorites.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = _filterByType(state.favorites, home, isDirect: isDirect);
        return RefreshIndicator(
          onRefresh: () => context.read<FavoritesCubit>().loadFavorites(),
          child: items.isEmpty
              ? const EmptyListWidget(
                  scrollable: true,
                  message: 'لا توجد مفضلات',
                  icon: Icons.favorite_border,
                )
              : ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => 16.verticalSpace,
                  itemBuilder: (context, index) => _FavItem(item: items[index]),
                ),
        );
      },
    );
  }
}

/// Splits favorites by their port category's subscription type. Direct-service
/// categories carry `subscriptionType == 1` (HomeCubit.paymentPorts); anything
/// else (including instant-booking and unclassifiable items) belongs to the
/// instant-booking tab. When the categories haven't loaded yet we can't split,
/// so both tabs show everything rather than appearing empty.
List<Item> _filterByType(List<Item> all, HomeState home, {required bool isDirect}) {
  final directCategoryIds = home.paymentPorts.map((c) => c.id).toSet();
  final bookingCategoryIds = home.bookingPorts.map((c) => c.id).toSet();
  if (directCategoryIds.isEmpty && bookingCategoryIds.isEmpty) return all;
  return all.where((item) {
    final categoryId = item.portTypeDto?.portCategoryId;
    final isItemDirect =
        categoryId != null && directCategoryIds.contains(categoryId);
    return isDirect ? isItemDirect : !isItemDirect;
  }).toList();
}

class _FavItem extends StatelessWidget {
  final Item item;
  const _FavItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        width: 113.w,
        height: 137.h,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomImageHandler(
                _firstImageUrl(item),
                smartFill: true,
              ),
            ),
            Positioned(
              top: 8.h,
              left: 8.w,
              child: GestureDetector(
                onTap: () async {
                  final id = item.id;
                  if (id == null) return;
                  final cubit = context.read<FavoritesCubit>();
                  final ok = await ConfirmDialog.show(
                    context,
                    message: 'هل أنت متأكد أنك تريد إزالة هذا من المفضلة؟',
                  );
                  if (ok) cubit.removeFavorite(id);
                },
                child: Container(
                  width: 30.r,
                  height: 30.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.favorite, color: _coral, size: 16.r),
                ),
              ),
            ),
            // Positioned(
            //   bottom: 8.h,
            //   left: 8.w,
            //   right: 8.w,
            //   child: _imagesBadge(item),
            // ),
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
            borderRadius: BorderRadius.horizontal(left: Radius.circular(16.r)),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
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
                ),
                CustomImageHandler(AppImages.iconsStar, width: 18.r, height: 18.r),
                4.horizontalSpace,
                Text(
                  '${item.rate ?? 0}',
                  style: TextStyle(
                    color: AppColors.blacksoft,
                    fontSize: 12.r,
                    fontFamily: 'Almarai',
                  ),
                ),
              ],
            ),
            6.verticalSpace,
            Expanded(
              child: Text(
                _subtitle(item),
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.grey2,
                  fontSize: 12.r,
                  fontFamily: 'Almarai',
                  height: 1.35,
                ),
              ),
            ),
            Text.rich(
              textDirection: TextDirection.rtl,
              TextSpan(
                children: [
                  TextSpan(
                    text: 'يبدأ بـ ',
                    style: TextStyle(
                      color: AppColors.blacksoft,
                      fontSize: 12.r,
                      fontFamily: 'Almarai',
                    ),
                  ),
                  TextSpan(
                    text: '${item.cheapestServicePrice ?? '—'} ',
                    style: TextStyle(
                      color: _orange,
                      fontSize: 16.r,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: 'جنيه',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 11.r,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      onTap: () => NavigationHelper.pushNamed(
        Routes.bookingServiceDetailsScreen,
        arguments: item,
      ),
      child: Row(
        children: [image, panel],
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
            color: _orange,
          ),
          4.horizontalSpace,
          Text(
            '+$count صوره',
            style: TextStyle(
              color: _orange,
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
  final main = item.theMainImageFileName?.trim();
  return (main != null && main.isNotEmpty) ? [main] : const [];
}

String? _firstImageUrl(Item item) {
  final main = item.theMainImageFileName?.trim();
  if (main == null || main.isEmpty) return null;
  return ImageUrlHelper.full(main);
}

String _subtitle(Item item) {
  final desc = item.portDescription?.toString().trim();
  if (desc != null && desc.isNotEmpty) return desc;
  return [item.governorate, item.city]
      .where((e) => e != null && e.isNotEmpty)
      .join('، ');
}
