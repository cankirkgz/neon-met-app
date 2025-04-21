import 'package:hive/hive.dart';

part 'favorite_artwork.g.dart';

@HiveType(typeId: 0)
class FavoriteArtwork extends HiveObject {
  @HiveField(0)
  final int objectId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? image;

  @HiveField(3)
  final String? artist;

  @HiveField(4)
  final String? department;

  FavoriteArtwork({
    required this.objectId,
    required this.title,
    this.image,
    this.artist,
    this.department,
  });
}
