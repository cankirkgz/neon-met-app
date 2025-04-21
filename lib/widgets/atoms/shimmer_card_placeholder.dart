import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCardPlaceholder extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerCardPlaceholder({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.textSecondary[300]!,
      highlightColor: AppColors.textSecondary[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.textSecondary[300],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
