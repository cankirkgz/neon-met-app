import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:neon_met_app/data/models/favorite_artwork.dart';
import 'package:neon_met_app/data/models/object_model.dart';
import 'package:neon_met_app/data/services/favorite_service.dart';
import 'package:neon_met_app/routes/app_router.dart';
import 'package:neon_met_app/widgets/molecules/artwork_card.dart';

@RoutePage()
class ArtworkListScreen extends StatefulWidget {
  final String title;
  final List<ObjectModel> objects;

  const ArtworkListScreen({
    super.key,
    required this.title,
    required this.objects,
  });

  @override
  State<ArtworkListScreen> createState() => _ArtworkListScreenState();
}

class _ArtworkListScreenState extends State<ArtworkListScreen> {
  final FavoriteService _favoriteService = FavoriteService();

  bool _isFavorite(int objectId) {
    return _favoriteService.isFavorite(objectId);
  }

  void _toggleFavorite(ObjectModel obj) async {
    setState(() {
      if (_favoriteService.isFavorite(obj.objectID)) {
        _favoriteService.removeFavorite(obj.objectID);
      } else {
        _favoriteService.addFavorite(
          FavoriteArtwork(
            objectId: obj.objectID,
            title: obj.title,
            image: obj.primaryImageSmall,
            artist: obj.artistDisplayName ?? obj.culture,
            department: obj.department,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: widget.objects.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final obj = widget.objects[index];
            return ArtworkCard(
              image: obj.primaryImageSmall ?? '',
              title: obj.title,
              subTitle: obj.artistDisplayName?.isNotEmpty == true
                  ? obj.artistDisplayName
                  : (obj.culture ?? 'Unknown'),
              onPressed: () {
                context.router.push(
                  ArtworkDetailRoute(objectId: obj.objectID),
                );
              },
              showFavoriteButton: true,
              isFavorite: _isFavorite(obj.objectID),
              onFavoritePressed: () => _toggleFavorite(obj),
            );
          },
        ),
      ),
    );
  }
}
