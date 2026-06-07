
import 'package:flutter/material.dart';

class CustomCircle extends StatelessWidget {
  final double radius;
  final Color color;
  const CustomCircle({super.key, this.radius = 50, this.color = Colors.red});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
