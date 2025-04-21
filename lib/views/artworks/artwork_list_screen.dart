import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
    super.key,
    required this.title,
    required this.objects,
  });

  @override
  Widget build(BuildContext context) {
    final favVm = context.watch<FavoriteViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
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
                  ? obj.artistDisplayName
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
                context.router.push(
                  ArtworkDetailRoute(objectId: obj.objectID),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
