// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_artwork.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteArtworkAdapter extends TypeAdapter<FavoriteArtwork> {
  @override
  final int typeId = 0;

  @override
  FavoriteArtwork read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteArtwork(
      objectId: fields[0] as int,
      title: fields[1] as String,
      image: fields[2] as String?,
      artist: fields[3] as String?,
      department: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteArtwork obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.objectId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.artist)
      ..writeByte(4)
      ..write(obj.department);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteArtworkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
