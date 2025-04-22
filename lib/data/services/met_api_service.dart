import 'package:dio/dio.dart';
import 'package:neon_met_app/data/models/department_model.dart';
import 'package:neon_met_app/data/models/object_model.dart';

class MetApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://collectionapi.metmuseum.org/public/collection/v1/',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<List<DepartmentModel>> fetchDepartments() async {
    try {
      final response = await _dio.get('departments');
      if (response.statusCode == 200) {
        final data = DepartmentModelResponse.fromJson(response.data);
        return data.departments;
      } else {
        throw Exception('Departmanlar alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Hata oluştu: $e');
    }
  }

  Future<List<int>> fetchObjectIDsByDepartment(int departmentId) async {
    try {
      final response = await _dio.get('search', queryParameters: {
        'departmentId': departmentId,
        'q': 'a',
        'hasImages': true,
      });

      if (response.statusCode == 200 && response.data['objectIDs'] != null) {
        return List<int>.from(response.data['objectIDs']);
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Departmana ait objeler alınamadı: $e');
    }
  }

  Future<ObjectModel> fetchObjectById(int objectId) async {
    try {
      final response = await _dio.get('objects/$objectId');
      if (response.statusCode == 200) {
        return ObjectModel.fromJson(response.data);
      } else {
        throw Exception("Obje bilgisi alınamadı: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception('Obje detayları alınamadı: $e');
    }
  }
}
