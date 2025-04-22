import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:neon_met_app/core/constants/app_sizes.dart';
import 'package:neon_met_app/core/constants/app_string.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const SectionTitle({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: AppSizes.fontXXL,
            fontWeight: FontWeight.bold,
          ),
        ),
        InkWell(
          onTap: onPressed,
          child: Row(
            children: [
              const Text(
                AppStrings.seeAll,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppSizes.fontL,
                ),
              ),
              const SizedBox(width: AppSizes.spacingXS),
              Image.asset('assets/icons/img_forward.png'),
            ],
          ),
        ),
      ],
    );
  }
}
