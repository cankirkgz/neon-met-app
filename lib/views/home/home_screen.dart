import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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

    // İlk yüklemeyi tetikle
    if (!vm.isLoading &&
        vm.currentExhibitions.isEmpty &&
        vm.famousArtworks.isEmpty &&
        vm.errorMessage == null) {
      Future.microtask(() {
        vm.fetchCurrentExhibitions();
        vm.fetchFamousArtworks();
      });
    }

    final cardWidth = MediaQuery.of(context).size.width * 0.4;

    final currentCards = vm.currentExhibitions.map((obj) {
      final isFav = favVm.isFavorite(obj.objectID);
      return ArtworkCard(
        image: obj.primaryImageSmall ?? '',
        title: obj.title,
        subTitle: obj.artistDisplayName?.isNotEmpty == true
            ? obj.artistDisplayName
            : (obj.culture ?? 'Unknown'),
        width: cardWidth,
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

    final famousCards = vm.famousArtworks.map((obj) {
      final isFav = favVm.isFavorite(obj.objectID);
      return ArtworkCard(
        image: obj.primaryImageSmall ?? '',
        title: obj.title,
        subTitle: obj.artistDisplayName?.isNotEmpty == true
            ? obj.artistDisplayName
            : (obj.culture ?? 'Unknown'),
        width: cardWidth,
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 64),
          Center(
            child: Image.asset(
              'assets/images/the_met_logo.png',
              width: 100,
              height: 100,
            ),
          ),
          const SizedBox(height: 24),
          const WelcomeBanner(),
          const SizedBox(height: 32),

          // Current Exhibitions Bölümü
          _LoadingOrContentSection(
            title: "Current Exhibitions",
            isLoading: vm.isLoading,
            hasError: vm.errorMessage != null,
            errorMessage: vm.errorMessage,
            items: currentCards,
            onSeeAllPressed: () {
              context.router.push(
                ArtworkListRoute(
                  title: "Current Exhibitions",
                  objects: vm.currentExhibitions,
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Famous Artworks Bölümü
          _LoadingOrContentSection(
            title: "Famous Artworks",
            isLoading: vm.isLoading,
            hasError: vm.errorMessage != null,
            errorMessage: vm.errorMessage,
            items: famousCards,
            onSeeAllPressed: () {
              context.router.push(
                ArtworkListRoute(
                  title: "Famous Artworks",
                  objects: vm.famousArtworks,
                ),
              );
            },
          ),

          const SizedBox(height: 64),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SectionTitle(title: title, onPressed: onSeeAllPressed),
          const SizedBox(height: 10),

          // Hata varsa
          if (hasError)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  errorMessage ?? "Failed to load $title",
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          // Yükleniyorsa ve henüz hiç veri yoksa
          else if (isLoading && items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            )
          // Veri geldiyse
          else
            ArtworkHorizontalList(cards: items),
        ],
      ),
    );
  }
}
