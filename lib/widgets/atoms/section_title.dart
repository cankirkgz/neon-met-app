import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';

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
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        InkWell(
          onTap: onPressed,
          child: Row(
            children: [
              const Text(
                "See all",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
              Image.asset(
                'assets/icons/img_forward.png',
              ),
            ],
          ),
        )
      ],
    );
  }
}
