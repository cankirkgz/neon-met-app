import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:neon_met_app/core/constants/app_sizes.dart';
import 'package:neon_met_app/core/constants/app_string.dart';

class SplashAnimation extends StatelessWidget {
  const SplashAnimation({
    super.key,
    this.lottiePath = 'assets/lotties/loading.json',
    this.caption = AppStrings.splashCaption,
  });

  final String lottiePath;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(
          lottiePath,
          width: AppSizes.iconSplashSize,
          height: AppSizes.iconSplashSize,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: AppSizes.spacingL),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxTextWidth),
          child: Text(
            caption,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
