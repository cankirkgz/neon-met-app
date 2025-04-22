import 'package:flutter/foundation.dart';
import 'package:neon_met_app/data/models/object_model.dart';
import 'package:neon_met_app/data/services/met_api_service.dart';

class SearchCollectionsViewModel extends ChangeNotifier {
  final MetApiService _api = MetApiService();

  final List<ObjectModel> _allObjects = [];
  List<ObjectModel> _filteredObjects = [];
  List<ObjectModel> get filteredObjects => _filteredObjects;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  int? _loadedDepartmentId;
  int? get loadedDepartmentId => _loadedDepartmentId;

  Future<void> fetchObjects(int departmentId) async {
    if (_loadedDepartmentId == departmentId) return;

    _loadedDepartmentId = departmentId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final ids = await _api.fetchObjectIDsByDepartment(departmentId);
      final objects = await Future.wait(
        ids.take(50).map(_api.fetchObjectById),
      );
      _allObjects
        ..clear()
        ..addAll(objects);

      _filteredObjects = List.from(_allObjects);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
