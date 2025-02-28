import 'package:flutter/material.dart';
import 'package:phoenix/widgets/shimmer_widget.dart';

class ShimmerWidget extends StatelessWidget {
  final double height;
  final double width;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerWidget({
    super.key,
    required this.height,
    required this.width,
    this.baseColor = const Color(0xFFBDBDBD), // Default grey
    this.highlightColor = const Color(0xFFFFFFFF), // Default white
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor.withValues(alpha: 0.4),
      highlightColor: highlightColor.withValues(alpha: 0.5),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: highlightColor,
        ),
      ),
    );
  }
}
