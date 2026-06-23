import 'package:evex_user/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Global empty-state widget for every data-fetching list in the app.
///
/// Use it whenever a list/grid that loads data from the backend can come back
/// empty, so the look & feel stays consistent and can be tuned from one place.
///
/// Two variants:
/// * default (`scrollable: false`) — a padded, centered block. Drop it inside
///   an existing scroll view (e.g. a `SingleChildScrollView` column).
/// * `scrollable: true` — fills the viewport and stays pull-to-refreshable, so
///   it can be used directly as a [RefreshIndicator] child on empty lists.
class EmptyListWidget extends StatelessWidget {
  /// Message shown under the icon. Defaults to a generic "no data" line.
  final String? message;

  /// Icon displayed above the message.
  final IconData icon;

  /// Icon size (defaults to 64.r).
  final double? iconSize;

  /// When true, wraps the content in a scrollable so pull-to-refresh keeps
  /// working even while the list is empty.
  final bool scrollable;

  /// Override the surrounding padding.
  final EdgeInsetsGeometry? padding;

  const EmptyListWidget({
    super.key,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.iconSize,
    this.scrollable = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: iconSize ?? 64.r,
          color: AppColors.grey.withValues(alpha: 0.5),
        ),
        16.verticalSpace,
        Text(
          message ?? 'لا توجد بيانات',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 14.r,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );

    if (!scrollable) {
      return Padding(
        padding: padding ?? EdgeInsets.symmetric(vertical: 40.h),
        child: Center(child: content),
      );
    }

    // Scrollable variant: fills the available height so the centered content
    // looks right, while AlwaysScrollableScrollPhysics keeps RefreshIndicator
    // working on an empty list.
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: padding ?? EdgeInsets.symmetric(vertical: 80.h),
              child: Center(child: content),
            ),
          ),
        );
      },
    );
  }
}
