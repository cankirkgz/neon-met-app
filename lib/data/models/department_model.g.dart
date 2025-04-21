// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentModel _$DepartmentModelFromJson(Map<String, dynamic> json) =>
    DepartmentModel(
      departmentId: (json['departmentId'] as num).toInt(),
      displayName: json['displayName'] as String,
    );

Map<String, dynamic> _$DepartmentModelToJson(DepartmentModel instance) =>
    <String, dynamic>{
      'departmentId': instance.departmentId,
      'displayName': instance.displayName,
    };

DepartmentModelResponse _$DepartmentModelResponseFromJson(
        Map<String, dynamic> json) =>
    DepartmentModelResponse(
      departments: (json['departments'] as List<dynamic>)
          .map((e) => DepartmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DepartmentModelResponseToJson(
        DepartmentModelResponse instance) =>
    <String, dynamic>{
      'departments': instance.departments,
    };
