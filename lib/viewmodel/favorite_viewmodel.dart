// lib/viewmodel/favorite_viewmodel.dart

import 'package:flutter/foundation.dart';
import 'package:neon_met_app/data/models/favorite_artwork.dart';
import 'package:neon_met_app/data/models/object_model.dart';
import 'package:neon_met_app/data/services/favorite_service.dart';

class FavoriteViewModel extends ChangeNotifier {
  final _service = FavoriteService();
  List<FavoriteArtwork> _favorites = [];

  List<FavoriteArtwork> get favorites => _favorites;

  Future<void> init() async {
    await _service.init();
    _favorites = _service.getAllFavorites();
    notifyListeners();
  }

  bool isFavorite(int objectId) {
    return _favorites.any((f) => f.objectId == objectId);
  }

  Future<void> toggleFavorite(FavoriteArtwork artwork) async {
    if (isFavorite(artwork.objectId)) {
      await _service.removeFavorite(artwork.objectId);
    } else {
      await _service.addFavorite(artwork);
    }
    _favorites = _service.getAllFavorites();
    notifyListeners();
  }

  /// 🔁 HIVE'daki favorileri ObjectModel listesine çevir
  List<ObjectModel> getFavoritesAsObjectModels() {
    return _favorites.map((f) {
      return ObjectModel(
        objectID: f.objectId,
        title: f.title,
        primaryImageSmall: f.image,
        artistDisplayName: f.artist,
        department: f.department,
        // İsteğe bağlı olarak diğer alanlar null kalabilir
        primaryImage: null,
        objectDate: null,
        medium: null,
        culture: null,
        dimensions: null,
        creditLine: null,
        period: null,
        objectNumber: null,
        classification: null,
      );
    }).toList();
  }
}
