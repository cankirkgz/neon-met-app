import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:neon_met_app/core/constants/app_sizes.dart';

class CenterNavButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const CenterNavButton({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.centerButtonSize,
        height: AppSizes.centerButtonSize,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : AppColors.scaffoldLight,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.scaffoldDark.withOpacity(0.15),
              blurRadius: AppSizes.shadowBlurM,
              offset: const Offset(0, AppSizes.shadowOffsetY),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            isSelected
                ? 'assets/icons/btn_tabbar_collection_selected.png'
                : 'assets/icons/btn_tabbar_collection_unselected.png',
          ),
        ),
      ),
    );
  }
}
