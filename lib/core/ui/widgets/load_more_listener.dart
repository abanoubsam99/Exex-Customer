import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:evex_user/core/theme/app_colors.dart';

/// Shared "load more" trigger for paginated lists: fires [onLoadMore] once the
/// user scrolls within [threshold] pixels of the bottom of any scrollable [child].
///
/// The callback can fire on several consecutive scroll frames, so the cubit it
/// drives MUST guard against re-entrancy (e.g. `if (isLoadingMore || !hasMore)
/// return;`). Use it together with [PaginationLoader] as the list's footer.
class LoadMoreListener extends StatelessWidget {
  final Widget child;
  final VoidCallback onLoadMore;
  final double threshold;

  const LoadMoreListener({
    super.key,
    required this.child,
    required this.onLoadMore,
    this.threshold = 240,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final m = notification.metrics;
        if (m.axis == Axis.vertical &&
            m.pixels >= m.maxScrollExtent - threshold) {
          onLoadMore();
        }
        return false;
      },
      child: child,
    );
  }
}

/// Footer spinner shown at the end of a list while the next page is loading.
class PaginationLoader extends StatelessWidget {
  const PaginationLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(
        child: SizedBox(
          width: 24.r,
          height: 24.r,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
