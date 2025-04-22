import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:neon_met_app/core/constants/app_sizes.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.error),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
        ),
        minimumSize: WidgetStateProperty.all(
          const Size(AppSizes.buttonWidth, AppSizes.buttonHeight),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).scaffoldBackgroundColor,
          fontSize: AppSizes.fontXL,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
