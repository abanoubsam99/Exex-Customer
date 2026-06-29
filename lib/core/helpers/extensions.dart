import 'package:flutter/widgets.dart';

extension StringExtension on String? {
  bool isNullOrEmpty() => this == null || this == "";
}

extension SafeAreaContext on BuildContext {
  /// Height of the bottom system inset — Android's on-screen nav buttons
  /// (back / home / recent) or iOS's home indicator. Add this to any element
  /// pinned to the screen bottom via `Positioned`/`Align` so it clears the
  /// system UI on both platforms instead of hiding behind it.
  double get bottomSafeInset => MediaQuery.viewPaddingOf(this).bottom;
}

extension ListExtension<T> on List<T>? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}