import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_images.dart';
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
  });
  final dynamic path;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final double? height, width;
  final Color? color;
  final Icon? errorIcon;

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

  @override
  Widget build(BuildContext context) {
    // No image (null or empty url) → logo placeholder instead of a stock photo.
    if (path == null || (path is String && (path as String).trim().isEmpty)) {
      return _logoPlaceholder();
    }

    if (path is File) {
      return Image.file(
        path,
        fit: fit,
        color: color,
        height: height,
        width: width,
      );
    }

    if (path is Uint8List) {
      return Image.memory(
        path,
        fit: fit,
        color: color,
        height: height,
        width: width,
      );
    }

    if (path.startsWith('http') ||
        path.startsWith('https') ||
        path.startsWith('www.')) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: fit,
        width: width,
        height: height,
        // memCacheHeight: height?.toInt(),
        // memCacheWidth: width?.toInt(),
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
          fit: fit,
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
      fit: fit,
      alignment: alignment,
      color: color,
      height: height,
      width: width,
      // cacheHeight: height?.toInt(),
      // cacheWidth: width?.toInt(),
      // new_logo.png is a PNG, so it must be loaded with Image.asset, not
      // SvgPicture.asset (which only renders SVG and silently fails on a PNG).
      errorBuilder: (context, error, stackTrace) => _logoPlaceholder(),
    );
  }
}
