import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:neon_met_app/core/constants/app_durations.dart';
import 'package:neon_met_app/routes/app_router.dart';
import 'package:neon_met_app/widgets/organism/splash_animation.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static const page = SplashRoute();

  @override
  Widget build(BuildContext context) {
    Future.microtask(() async {
      await Future.delayed(AppDurations.splashDelay);
      if (context.mounted) {
        context.router.replace(const MainRoute());
      }
    });

    return const Scaffold(
      backgroundColor: AppColors.scaffoldLight,
      body: Center(
        child: SplashAnimation(),
      ),
    );
  }
}
