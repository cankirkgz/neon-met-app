// lib/viewmodel/search_collections_viewmodel.dart

import 'package:flutter/foundation.dart';
import 'package:neon_met_app/data/models/object_model.dart';
import 'package:neon_met_app/data/services/met_api_service.dart';

class SearchCollectionsViewModel extends ChangeNotifier {
  final _api = MetApiService();

  List<ObjectModel> allObjects = [];
  List<ObjectModel> filteredObjects = [];
  bool isLoading = false;
  String? error;

  int? _loadedDepartmentId; // ← ekledik
  int? get loadedDepartmentId => _loadedDepartmentId; // dışarı açtık

  Future<void> fetchObjects(int departmentId) async {
    // eğer aynı departman Id zaten yüklüyse tekrar yükleme
    if (_loadedDepartmentId == departmentId) return;

    _loadedDepartmentId = departmentId; // hangi departmanı çektiğimizi sakla
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final ids = await _api.fetchObjectIDsByDepartment(departmentId);
      final objects = await Future.wait(ids
          .take(50) // isterseniz sınır koyabilirsiniz
          .map((id) => _api.fetchObjectById(id)));
      allObjects = objects;
      filteredObjects = allObjects;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void filterObjects(String query) {
    filteredObjects = allObjects
        .where((o) => o.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
