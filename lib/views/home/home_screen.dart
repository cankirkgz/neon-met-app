import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:neon_met_app/core/constants/app_sizes.dart';
import 'package:neon_met_app/core/constants/app_string.dart';
import 'package:neon_met_app/data/models/favorite_artwork.dart';
import 'package:neon_met_app/viewmodel/favorite_viewmodel.dart';
import 'package:neon_met_app/viewmodel/object_viewmodel.dart';
import 'package:neon_met_app/widgets/atoms/section_title.dart';
import 'package:neon_met_app/widgets/molecules/artwork_card.dart';
import 'package:neon_met_app/widgets/molecules/welcome_banner.dart';
import 'package:neon_met_app/widgets/organism/artwork_horizontal_list.dart';
import 'package:provider/provider.dart';
import 'package:neon_met_app/routes/app_router.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ObjectViewModel>();
    final favVm = context.watch<FavoriteViewModel>();

    if (!vm.isLoading &&
        vm.currentExhibitions.isEmpty &&
        vm.famousArtworks.isEmpty &&
        vm.errorMessage == null) {
      Future.microtask(() {
        vm.fetchCurrentExhibitions();
        vm.fetchFamousArtworks();
      });
    }

    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final isTablet = size.shortestSide >= 600;
    final isPortraitPhone = !isLandscape && !isTablet;

    List<ArtworkCard> buildCards(List artworks) => artworks.map((obj) {
          final isFav = favVm.isFavorite(obj.objectID);
          return ArtworkCard(
            image: obj.primaryImageSmall ?? '',
            title: obj.title,
            subTitle: obj.artistDisplayName?.isNotEmpty == true
                ? obj.artistDisplayName!
                : (obj.culture ?? 'Unknown'),
            width: size.width * 0.4,
            showFavoriteButton: true,
            isFavorite: isFav,
            onFavoritePressed: () {
              final fav = FavoriteArtwork(
                objectId: obj.objectID,
                title: obj.title,
                image: obj.primaryImageSmall,
                artist: obj.artistDisplayName ?? obj.culture,
                department: obj.department,
              );
              favVm.toggleFavorite(fav);
            },
            onPressed: () {
              context.router.push(ArtworkDetailRoute(objectId: obj.objectID));
            },
          );
        }).toList();

    final currentCards = buildCards(vm.currentExhibitions);
    final famousCards = buildCards(vm.famousArtworks);

    const horizontalPadding = AppSizes.spacingXL;
    const verticalSpacing = AppSizes.spacingL;
    final logoSize = isLandscape ? size.height * 0.2 : size.width * 0.25;
    final bannerHeight = isLandscape ? size.height * 0.3 : size.height * 0.2;
    final cardWidth = isLandscape ? size.width * 0.25 : size.width * 0.6;

    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          vm.fetchCurrentExhibitions(),
          vm.fetchFamousArtworks(),
        ]);
      },
      child: isPortraitPhone
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 64),
                  Center(
                    child: Image.asset(
                      'assets/images/the_met_logo.png',
                      width: AppSizes.iconSplashSize,
                      height: AppSizes.iconSplashSize,
                      semanticLabel: AppStrings.theMetLogoAlt,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingL),
                  const WelcomeBanner(),
                  const SizedBox(height: AppSizes.spacingXL),
                  _LoadingOrContentSection(
                    title: AppStrings.homeTitleCurrentExhibitions,
                    isLoading: vm.isLoading,
                    hasError: vm.errorMessage != null,
                    errorMessage: vm.errorMessage,
                    items: currentCards,
                    onSeeAllPressed: () {
                      context.router.push(
                        ArtworkListRoute(
                          title: AppStrings.homeTitleCurrentExhibitions,
                          objects: vm.currentExhibitions,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSizes.spacingL),
                  _LoadingOrContentSection(
                    title: AppStrings.homeTitleFamousArtworks,
                    isLoading: vm.isLoading,
                    hasError: vm.errorMessage != null,
                    errorMessage: vm.errorMessage,
                    items: famousCards,
                    onSeeAllPressed: () {
                      context.router.push(
                        ArtworkListRoute(
                          title: AppStrings.homeTitleFamousArtworks,
                          objects: vm.famousArtworks,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 64),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: verticalSpacing),
                  Center(
                    child: Image.asset(
                      'assets/images/the_met_logo.png',
                      width: logoSize,
                      height: logoSize,
                      semanticLabel: AppStrings.theMetLogoAlt,
                    ),
                  ),
                  const SizedBox(height: verticalSpacing),
                  SizedBox(
                    width: double.infinity,
                    height: bannerHeight,
                    child: const WelcomeBanner(),
                  ),
                  const SizedBox(height: verticalSpacing * 2),
                  _ResponsiveSection(
                    title: AppStrings.homeTitleCurrentExhibitions,
                    isLoading: vm.isLoading,
                    hasError: vm.errorMessage != null,
                    errorMessage: vm.errorMessage,
                    items: currentCards,
                    cardWidth: cardWidth,
                    onSeeAllPressed: () {
                      context.router.push(
                        ArtworkListRoute(
                          title: AppStrings.homeTitleCurrentExhibitions,
                          objects: vm.currentExhibitions,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: verticalSpacing * 2),
                  _ResponsiveSection(
                    title: AppStrings.homeTitleFamousArtworks,
                    isLoading: vm.isLoading,
                    hasError: vm.errorMessage != null,
                    errorMessage: vm.errorMessage,
                    items: famousCards,
                    cardWidth: cardWidth,
                    onSeeAllPressed: () {
                      context.router.push(
                        ArtworkListRoute(
                          title: AppStrings.homeTitleFamousArtworks,
                          objects: vm.famousArtworks,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: verticalSpacing * 2),
                ],
              ),
            ),
    );
  }
}

class _LoadingOrContentSection extends StatelessWidget {
  const _LoadingOrContentSection({
    required this.title,
    required this.isLoading,
    required this.hasError,
    required this.errorMessage,
    required this.items,
    required this.onSeeAllPressed,
  });

  final String title;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final List<ArtworkCard> items;
  final VoidCallback onSeeAllPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: title, onPressed: onSeeAllPressed),
          const SizedBox(height: AppSizes.spacingS),
          if (hasError)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingXL),
              child: Center(
                child: Text(
                  errorMessage ?? '${AppStrings.homeErrorLoading} $title',
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            )
          else if (isLoading && items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSizes.spacingXL),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            ArtworkHorizontalList(cards: items),
        ],
      ),
    );
  }
}

class _ResponsiveSection extends StatelessWidget {
  const _ResponsiveSection({
    required this.title,
    required this.isLoading,
    required this.hasError,
    required this.errorMessage,
    required this.items,
    required this.cardWidth,
    required this.onSeeAllPressed,
  });

  final String title;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final List<ArtworkCard> items;
  final double cardWidth;
  final VoidCallback onSeeAllPressed;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final useWrap = isLandscape || isTablet;
    final horizontalPadding = AppSizes.spacingXL;
    final verticalSpacing = AppSizes.spacingL;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: title, onPressed: onSeeAllPressed),
          SizedBox(height: verticalSpacing),
          if (hasError)
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalSpacing * 2),
              child: Center(
                child: Text(
                  errorMessage ?? '${AppStrings.homeErrorLoading} $title',
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            )
          else if (isLoading && items.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalSpacing * 2),
              child: const Center(child: CircularProgressIndicator()),
            )
          else if (useWrap)
            Wrap(
              spacing: horizontalPadding,
              runSpacing: verticalSpacing,
              alignment: WrapAlignment.center,
              children: items
                  .map((card) => SizedBox(
                        width: cardWidth,
                        child: card,
                      ))
                  .toList(),
            )
          else
            ArtworkHorizontalList(cards: items),
        ],
      ),
    );
  }
}
