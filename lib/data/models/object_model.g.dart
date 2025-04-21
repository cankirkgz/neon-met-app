// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectModel _$ObjectModelFromJson(Map<String, dynamic> json) => ObjectModel(
      objectID: (json['objectID'] as num).toInt(),
      title: json['title'] as String,
      artistDisplayName: json['artistDisplayName'] as String?,
      primaryImageSmall: json['primaryImageSmall'] as String?,
      primaryImage: json['primaryImage'] as String?,
      department: json['department'] as String?,
      objectDate: json['objectDate'] as String?,
      medium: json['medium'] as String?,
      culture: json['culture'] as String?,
      dimensions: json['dimensions'] as String?,
      creditLine: json['creditLine'] as String?,
      period: json['period'] as String?,
      objectNumber: json['objectNumber'] as String?,
      classification: json['classification'] as String?,
    );

Map<String, dynamic> _$ObjectModelToJson(ObjectModel instance) =>
    <String, dynamic>{
      'objectID': instance.objectID,
      'title': instance.title,
      'artistDisplayName': instance.artistDisplayName,
      'primaryImageSmall': instance.primaryImageSmall,
      'primaryImage': instance.primaryImage,
      'department': instance.department,
      'objectDate': instance.objectDate,
      'medium': instance.medium,
      'culture': instance.culture,
      'dimensions': instance.dimensions,
      'creditLine': instance.creditLine,
      'period': instance.period,
      'objectNumber': instance.objectNumber,
      'classification': instance.classification,
    };
