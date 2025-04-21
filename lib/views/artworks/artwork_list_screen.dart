import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:neon_met_app/data/models/favorite_artwork.dart';
import 'package:neon_met_app/data/models/object_model.dart';
import 'package:neon_met_app/routes/app_router.dart';
import 'package:neon_met_app/viewmodel/favorite_viewmodel.dart';
import 'package:neon_met_app/widgets/molecules/artwork_card.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ArtworkListScreen extends StatelessWidget {
  final String title;
  final List<ObjectModel> objects;

  const ArtworkListScreen({
    Key? key,
    required this.title,
    required this.objects,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favVm = context.watch<FavoriteViewModel>();
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final isTablet = size.shortestSide >= 600;
    final isPortraitPhone = !isLandscape && !isTablet;

    // Portrait phones: original list view
    if (isPortraitPhone) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: objects.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final obj = objects[index];
              final isFav = favVm.isFavorite(obj.objectID);
              return ArtworkCard(
                image: obj.primaryImageSmall ?? '',
                title: obj.title,
                subTitle: obj.artistDisplayName?.isNotEmpty == true
                    ? obj.artistDisplayName!
                    : (obj.culture ?? 'Unknown'),
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
                  context.router
                      .push(ArtworkDetailRoute(objectId: obj.objectID));
                },
              );
            },
          ),
        ),
      );
    }

    // Landscape & tablets: grid layout
    final crossCount = isTablet ? 3 : 2;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: objects.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final obj = objects[index];
              final isFav = favVm.isFavorite(obj.objectID);
              return ArtworkCard(
                image: obj.primaryImageSmall ?? '',
                title: obj.title,
                subTitle: obj.artistDisplayName?.isNotEmpty == true
                    ? obj.artistDisplayName!
                    : (obj.culture ?? 'Unknown'),
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
                  context.router
                      .push(ArtworkDetailRoute(objectId: obj.objectID));
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
