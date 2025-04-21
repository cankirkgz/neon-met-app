import 'package:dio/dio.dart';
import 'package:neon_met_app/data/models/object_model.dart';

class ObjectService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://collectionapi.metmuseum.org/public/collection/v1",
    ),
  );

  Future<ObjectModel> fetchObjectById(int objectId) async {
    final response = await _dio.get('/objects/$objectId');
    if (response.statusCode == 200) {
      return ObjectModel.fromJson(response.data);
    } else {
      throw Exception("Failed to fetch object details");
    }
  }

  Future<List<int>> fetchObjectIDsByDepartment(int departmentId) async {
    final response = await _dio.get('/search', queryParameters: {
      'departmentId': departmentId,
      'q': 'a', // herhangi bir şeyle eşleşen
    });

    if (response.statusCode == 200 && response.data['objectIDs'] != null) {
      return List<int>.from(response.data['objectIDs']);
    } else {
      throw Exception("Object IDs could not be retrieved");
    }
  }

  Future<List<int>> searchObjects({required String query}) async {
    final response = await _dio.get(
      '/search',
      queryParameters: {
        'q': query,
        'hasImages': true,
      },
    );

    if (response.statusCode == 200) {
      return List<int>.from(response.data['objectIDs'] ?? []);
    } else {
      throw Exception('Search failed');
    }
  }

  Future<List<int>> searchObjectsOnView({
    bool onView = true,
    bool highlight = false,
    int max = 40,
  }) async {
    final response = await _dio.get(
      '/search',
      queryParameters: {
        'q': '*', // boş arama => tüm objelerde filtre uygula
        'hasImages': true,
        'isOnView': onView,
        if (highlight) 'isHighlight': true,
      },
    );

    if (response.statusCode == 200) {
      final ids = List<int>.from(response.data['objectIDs'] ?? []);
      return ids.take(max).toList();
    } else {
      throw Exception('searchObjectsOnView failed');
    }
  }
}
