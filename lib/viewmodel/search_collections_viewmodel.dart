import 'package:flutter/material.dart';
import 'package:neon_met_app/data/models/object_model.dart';
import 'package:neon_met_app/data/services/met_api_service.dart';

class SearchCollectionsViewModel extends ChangeNotifier {
  final MetApiService _apiService = MetApiService();

  // Full fetched list
  List<ObjectModel> _allObjects = [];
  // Active filtered list
  List<ObjectModel> _filteredObjects = [];

  bool _isLoading = false;
  String? _error;

  /// Expose both lists
  List<ObjectModel> get allObjects => _allObjects;
  List<ObjectModel> get filteredObjects => _filteredObjects;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch initial objects (one-time API call)
  Future<void> fetchObjects(int departmentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final ids = await _apiService.fetchObjectIDsByDepartment(departmentId);
      final firstIds = ids.take(20);

      // Fetch all details in parallel
      _allObjects = await Future.wait(
        firstIds.map((id) => _apiService.fetchObjectById(id)),
      );

      // Initialize filtered list
      _filteredObjects = List.from(_allObjects);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// In-memory filtering without additional API calls
  void filterObjects(String query) {
    final lower = query.trim().toLowerCase();
    if (lower.isEmpty) {
      // Restore full list
      _filteredObjects = List.from(_allObjects);
    } else {
      _filteredObjects = _allObjects
          .where((obj) => obj.title.toLowerCase().contains(lower))
          .toList();
    }
    notifyListeners();
  }
}
