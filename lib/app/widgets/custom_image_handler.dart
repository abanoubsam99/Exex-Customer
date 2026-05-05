import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/MyColors.dart';
import '../constants/app_images.dart';
import '../constants/app_text_styles.dart';
import 'custom_image_handler.dart';

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

  @override
  Widget build(BuildContext context) {
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
          return Center(child: errorIcon ?? const Icon(Icons.error));
        },
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return Center(
            child: SizedBox(
              height: 32,
              width: 32,
              child: SvgPicture.asset(AppImages.imagesNewLogo),
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
      errorBuilder:
          (context, error, stackTrace) => SvgPicture.asset(
            AppImages.iconsLogo,
            colorFilter:
                color == null
                    ? null
                    : ColorFilter.mode(color!, BlendMode.srcIn),
          ),
    );
  }
}
