import 'package:hive/hive.dart';
import 'package:neon_met_app/data/models/favorite_artwork.dart';

class FavoriteService {
  static final FavoriteService _instance = FavoriteService._internal();
  factory FavoriteService() => _instance;

  late final Box<FavoriteArtwork> _box;

  FavoriteService._internal();

  Future<void> init() async {
    _box = Hive.box<FavoriteArtwork>('favorites');
  }

  List<FavoriteArtwork> getAllFavorites() {
    return _box.values.toList();
  }

  bool isFavorite(int objectId) {
    return _box.values.any((item) => item.objectId == objectId);
  }

  Future<void> addFavorite(FavoriteArtwork artwork) async {
    if (!isFavorite(artwork.objectId)) {
      await _box.add(artwork);
    }
  }

  Future<void> removeFavorite(int objectId) async {
    final key = _box.keys.firstWhere(
      (k) => _box.get(k)?.objectId == objectId,
      orElse: () => null,
    );
    if (key != null) {
      await _box.delete(key);
    }
  }
}
