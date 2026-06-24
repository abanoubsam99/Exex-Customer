import 'package:evex_user/core/helpers/image_url_helper.dart';
import 'package:evex_user/core/ui/widgets/custom_image_handler.dart';
import 'package:evex_user/core/ui/widgets/shimmer_skelton.dart';
import 'package:evex_user/core/ui/widgets/speech_bubble_border.dart';
import 'package:evex_user/data/models/port_category_with_port_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evex_user/core/theme/app_colors.dart';

/// Shared "service categories" block used by both the instant-booking and the
/// direct-payment sections (identical design now):
///   • big category cards — the selected one shows its label + a speech-bubble
///     tail; the rest show the icon only.
///   • if the selected category has port types → they show as chips below;
///     tapping a chip opens the ports list filtered by that type (portTypeId).
///   • a category with no port types opens the ports list directly (general →
///     no portTypeId, shows everything).
class ServiceCategorySection extends StatelessWidget {
  final String title;
  final bool isLoading;
  final List<PortCategoryWithPortTypes> categories;
  final PortCategoryWithPortTypes? selectedCategory;
  final PortTypeDto? selectedType;
  final ValueChanged<PortCategoryWithPortTypes> onSelectCategory;
  final ValueChanged<PortTypeDto> onSelectType;

  /// Opens the ports-list screen (reads the selected category/type from state).
  final VoidCallback onOpenPorts;

  const ServiceCategorySection({
    super.key,
    required this.title,
    required this.isLoading,
    required this.categories,
    required this.selectedCategory,
    required this.selectedType,
    required this.onSelectCategory,
    required this.onSelectType,
    required this.onOpenPorts,
  });

  /// How many cards fit across the row. The fraction is deliberate: it leaves
  /// part of the next card peeking at the edge so the user can tell the row
  /// scrolls horizontally (instead of looking like a fixed set of 3).
  static const double _visibleCards = 3.3;

  @override
  Widget build(BuildContext context) {
    final types = selectedCategory?.portTypeDtos ?? const <PortTypeDto>[];
    return LayoutBuilder(
      builder: (context, constraints) {
        final separator = 12.w;
        // Size each card so ~3.3 fit the available width → a partial card
        // always peeks, hinting the row is scrollable.
        final itemWidth =
            (constraints.maxWidth - 3 * separator) / _visibleCards;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            12.verticalSpace,
            if (isLoading)
              SizedBox(
                height: 116.h,
                child: ListView.separated(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, __) => SizedBox(width: separator),
                  itemBuilder: (_, __) =>
                      ShimmerSkelton(width: itemWidth, height: 100.h),
                ),
              )
            else
              SizedBox(
                height: 116.h,
                child: ListView.separated(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => SizedBox(width: separator),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _CategoryCard(
                      width: itemWidth,
                      category: category,
                      isSelected: selectedCategory?.id == category.id,
                      onTap: () {
                        onSelectCategory(category);
                        // No port types → open the ports list directly.
                        if (category.portTypeDtos.isEmpty) onOpenPorts();
                      },
                    );
                  },
                ),
              ),
            // ── Port-type chips for the selected category (if it has any) ──
            if (types.isNotEmpty) ...[
              14.verticalSpace,
              SizedBox(
                height: 34.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: types.length,
                  separatorBuilder: (_, __) => SizedBox(width: separator),
                  itemBuilder: (context, index) {
                    final type = types[index];
                    final isSelected = selectedType?.id == type.id;
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          onSelectType(type);
                          onOpenPorts();
                        },
                        // Width + spacing mirror the category card above so the
                        // two rows line up (and peek the same way).
                        child: Container(
                          width: itemWidth,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              vertical: 6.h, horizontal: 1.w),
                          decoration: ShapeDecoration(
                            color: isSelected
                                ? AppColors.blacksoft
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1.5, color: AppColors.blacksoft),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            type.nameAr ?? type.nameEn ?? '',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.blacksoft,
                              fontSize: 10.r,
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
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _header() => Row(
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
            title,
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
      );
}

class _CategoryCard extends StatelessWidget {
  final double width;
  final PortCategoryWithPortTypes category;
  final bool isSelected;
  final VoidCallback onTap;
  const _CategoryCard({
    required this.width,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = CustomImageHandler(
      ImageUrlHelper.full(category.iconePath),
      smartFill: false,
      height: 60.r,
      width: 60.r,
    );
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: width,
          height: 100.h,
          alignment: Alignment.center,
          // Horizontal padding kept tight so the label has ~94w to render —
          // long service names need the room to avoid early truncation.
          padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 5.h),
          decoration: isSelected
              ? ShapeDecoration(
                  color: Colors.white,
                  shape: SpeechBubbleBorder(
                    borderColor: AppColors.primaryColor,
                    borderWidth: 2,
                    tailPosition: 0.70,
                  ),
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8.r,
                      offset: Offset(0, 4.r),
                    ),
                  ],
                )
              : ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: AppColors.fillGrey2),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
          // Every card shows its label now (selected or not); only the border
          // style differs between selected/unselected.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              3.verticalSpace,
              Text(
                category.nameAr ?? category.nameEn ?? '',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11.r,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
