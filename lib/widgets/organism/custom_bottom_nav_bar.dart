import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:neon_met_app/core/constants/app_sizes.dart';
import 'package:neon_met_app/widgets/molecules/bottom_nav_item.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spacingXL),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusM),
          topRight: Radius.circular(AppSizes.radiusM),
          bottomLeft: Radius.circular(AppSizes.radiusXL),
          bottomRight: Radius.circular(AppSizes.radiusXL),
        ),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.scaffoldDark.withOpacity(0.2),
                blurRadius: AppSizes.shadowBlurLarge,
                offset: const Offset(0, AppSizes.shadowOffsetY),
              ),
              BoxShadow(
                color: AppColors.scaffoldDark.withOpacity(0.15),
                blurRadius: AppSizes.shadowBlurSmall,
              ),
            ],
          ),
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: AppSizes.bottomNavNotchMargin,
            elevation: AppSizes.bottomNavElevation,
            color: isDark ? Colors.grey[900] : AppColors.scaffoldLight,
            child: SizedBox(
              height: AppSizes.bottomNavHeight,
              child: Row(
                children: [
                  const SizedBox(width: AppSizes.outerNavPadding),
                  GestureDetector(
                    onTap: () => onItemSelected(0),
                    child: BottomNavItem(
                      icon: 'btn_tabbar_home_unselected.png',
                      selectedIcon: 'btn_tabbar_home_selected.png',
                      title: 'Home',
                      isSelected: selectedIndex == 0,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: AppSizes.fabNotchGap),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => onItemSelected(2),
                    child: BottomNavItem(
                      icon: 'btn_tabbar_info_unselected.png',
                      selectedIcon: 'btn_tabbar_info_selected.png',
                      title: 'Info',
                      isSelected: selectedIndex == 2,
                    ),
                  ),
                  const SizedBox(width: AppSizes.outerNavPadding),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
