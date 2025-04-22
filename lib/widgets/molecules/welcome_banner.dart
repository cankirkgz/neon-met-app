import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_string.dart';
import 'package:provider/provider.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:neon_met_app/core/constants/app_sizes.dart';
import 'package:neon_met_app/routes/app_router.dart';
import 'package:neon_met_app/viewmodel/favorite_viewmodel.dart';
import 'package:neon_met_app/widgets/atoms/primary_button.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Image.asset(
          'assets/images/img_home_01.png',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          left: AppSizes.spacingM,
          bottom: AppSizes.spacingL + AppSizes.spacingS,
          child: SizedBox(
            width: screenWidth * 0.6,
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    AppStrings.welcome,
                    style: TextStyle(
                      fontSize: AppSizes.fontXXL + 11,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingM),
                  PrimaryButton(
                    text: AppStrings.exploreCollection,
                    onPressed: () =>
                        AutoTabsRouter.of(context).setActiveIndex(1),
                  ),
                  const SizedBox(height: AppSizes.spacingS + 4),
                  GestureDetector(
                    onTap: () {
                      final favVm = context.read<FavoriteViewModel>();
                      final favoriteObjects =
                          favVm.getFavoritesAsObjectModels();

                      context.router.push(
                        ArtworkListRoute(
                          title: AppStrings.goToFavorites,
                          objects: favoriteObjects,
                        ),
                      );
                    },
                    child: const Text(
                      AppStrings.goToFavorites,
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: AppSizes.fontL,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
