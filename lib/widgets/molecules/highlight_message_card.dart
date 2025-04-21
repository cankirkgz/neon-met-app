import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';

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
      alignment: Alignment.center, // <-- tüm çocukları ortala
      children: [
        // Arka plan görseli
        Image.asset(
          "assets/images/$imageName",
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        // Ortadaki metin
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.scaffoldLight,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
