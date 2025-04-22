import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:neon_met_app/core/constants/app_sizes.dart';

class HighlightMessageCard extends StatelessWidget {
  final String imageName;
  final String text;

  const HighlightMessageCard({
    super.key,
    required this.imageName,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          "assets/images/$imageName",
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingM,
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.scaffoldLight,
              fontSize: AppSizes.fontHero,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
