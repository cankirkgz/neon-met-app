import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:neon_met_app/routes/app_router.dart';
import 'package:neon_met_app/viewmodel/favorite_viewmodel.dart';
import 'package:neon_met_app/widgets/atoms/primary_button.dart';
import 'package:provider/provider.dart';

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
          left: 20,
          bottom: 30,
          child: SizedBox(
            width: screenWidth * 0.6,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Welcome to The Met",
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: "Explore Collection",
                    onPressed: () =>
                        AutoTabsRouter.of(context).setActiveIndex(1),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      final favVm = context.read<FavoriteViewModel>();
                      final favoriteObjects =
                          favVm.getFavoritesAsObjectModels();

                      context.router.push(
                        ArtworkListRoute(
                          title: "Your Favorites",
                          objects: favoriteObjects,
                        ),
                      );
                    },
                    child: const Text(
                      "Go to Favorites",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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
