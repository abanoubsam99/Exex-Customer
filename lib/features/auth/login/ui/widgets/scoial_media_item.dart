import 'package:flutter/material.dart';

import '../../../../../core/ui/widgets/custom_image_handler.dart';

class ScoialMediaItemWidget extends StatelessWidget {
  const ScoialMediaItemWidget({super.key, required this.image, this.onTap});
  final String image;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              // Horizontal and vertical offset
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 0,
              spreadRadius: 1,
              // Horizontal and vertical offset
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomImageHandler(image),
        ),
      ),
    );
  }
}
