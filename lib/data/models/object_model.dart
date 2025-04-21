import 'package:json_annotation/json_annotation.dart';

part 'object_model.g.dart';

@JsonSerializable()
class ObjectModel {
  final int objectID;
  final String title;
  final String? artistDisplayName;
  final String? primaryImageSmall;
  final String? primaryImage;
  final String? department;
  final String? objectDate;
  final String? medium;
  final String? culture;
  final String? dimensions;
  final String? creditLine;
  final String? period;
  final String? objectNumber;
  final String? classification; // ✅ Eklendi

  ObjectModel({
    required this.objectID,
    required this.title,
    this.artistDisplayName,
    this.primaryImageSmall,
    this.primaryImage,
    this.department,
    this.objectDate,
    this.medium,
    this.culture,
    this.dimensions,
    this.creditLine,
    this.period,
    this.objectNumber,
    this.classification, // ✅ Constructor'a eklendi
  });

  factory ObjectModel.fromJson(Map<String, dynamic> json) =>
      _$ObjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$ObjectModelToJson(this);
}
