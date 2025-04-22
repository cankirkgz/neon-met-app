import 'package:json_annotation/json_annotation.dart';

part 'department_model.g.dart';

@JsonSerializable()
class DepartmentModel {
  final int departmentId;
  final String displayName;

  DepartmentModel({required this.departmentId, required this.displayName});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentModelToJson(this);
}

@JsonSerializable()
class DepartmentModelResponse {
  final List<DepartmentModel> departments;

  DepartmentModelResponse({required this.departments});

  factory DepartmentModelResponse.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentModelResponseToJson(this);
}
