import 'dart:io';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_images.dart';
import '../../helpers/image_cache_manager.dart';
import '../../theme/app_colors.dart';

class CustomImageHandler extends StatelessWidget {
  const CustomImageHandler(
    this.path, {
    super.key,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.height,
    this.width,
    this.color,
    this.errorIcon,
    this.smartFill = false,
  });
  final dynamic path;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final double? height, width;
  final Color? color;
  final Icon? errorIcon;

  /// When true the image is shown in full (BoxFit.contain) on top of a blurred,
  /// zoomed-in copy of itself. This fills the box with no distortion and no
  /// empty bars, regardless of the image's aspect ratio — the right choice for
  /// API images that arrive in unpredictable sizes/ratios.
  final bool smartFill;

  /// Shown whenever there is no image to display (null/empty path) or one fails
  /// to load: the app logo centered on a light background — never a stock photo.
  Widget _logoPlaceholder() {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      color: AppColors.fillGrey2,
      child: FractionallySizedBox(
        widthFactor: 0.5,
        heightFactor: 0.5,
        child: Image.asset(AppImages.imagesNewLogo, fit: BoxFit.contain),
      ),
    );
  }

  /// Builds the raw image widget for the given [boxFit]. Kept separate so
  /// [smartFill] can render the same source twice (blurred cover + contain).
  Widget _image(BoxFit boxFit) {
    if (path is File) {
      return Image.file(
        path,
        fit: boxFit,
        alignment: alignment,
        color: color,
        height: height,
        width: width,
        // medium (trilinear) keeps downscaled photos sharp instead of the
        // soft/blurry look of the default low quality.
        filterQuality: FilterQuality.medium,
      );
    }

    if (path is Uint8List) {
      return Image.memory(
        path,
        fit: boxFit,
        alignment: alignment,
        color: color,
        height: height,
        width: width,
        filterQuality: FilterQuality.medium,
      );
    }

    if (path.startsWith('http') ||
        path.startsWith('https') ||
        path.startsWith('www.')) {
      return CachedNetworkImage(
        imageUrl: path,
        // Shared cache manager with a short stale period so backend image
        // changes (same URL, overwritten file) are picked up instead of being
        // served stale for the default 30 days.
        cacheManager: ImageCacheManager.instance,
        fit: boxFit,
        alignment: alignment is Alignment ? alignment as Alignment : Alignment.center,
        width: width,
        height: height,
        // medium (trilinear) keeps downscaled photos sharp instead of the
        // soft/blurry look of the default low quality.
        filterQuality: FilterQuality.medium,
        errorWidget: (BuildContext context, _, stackTrace) {
          return errorIcon != null
              ? Center(child: errorIcon)
              : _logoPlaceholder();
        },
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return Center(
            child: SizedBox(
              height: 32,
              width: 32,
              child: Image.asset(AppImages.imagesNewLogo),
            ),
          );
        },
      );
    }

    if (path.endsWith('.svg')) {
      return SizedBox(
        height: height,
        width: width,
        child: SvgPicture.asset(
          path,
          fit: boxFit,
          alignment: alignment,
          height: height,
          width: width,
          colorFilter:
              color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
        ),
      );
    }

    return Image.asset(
      path,
      fit: boxFit,
      alignment: alignment,
      color: color,
      height: height,
      width: width,
      filterQuality: FilterQuality.medium,
      // new_logo.png is a PNG, so it must be loaded with Image.asset, not
      // SvgPicture.asset (which only renders SVG and silently fails on a PNG).
      errorBuilder: (context, error, stackTrace) => _logoPlaceholder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // No image (null or empty url) → logo placeholder instead of a stock photo.
    if (path == null || (path is String && (path as String).trim().isEmpty)) {
      return _logoPlaceholder();
    }

    // smartFill: blurred zoomed copy behind + the full image (contain) in front.
    // Fills the box with no distortion and no empty bars for any aspect ratio.
    if (smartFill) {
      return SizedBox(
        height: height,
        width: width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background: same image cropped to cover, then blurred + dimmed.
            ClipRect(
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: _image(BoxFit.cover),
              ),
            ),
            Container(color: Colors.black.withValues(alpha: 0.08)),
            // Foreground: whole image, no crop, no stretch.
            _image(BoxFit.contain),
          ],
        ),
      );
    }

    return _image(fit);
  }
}
