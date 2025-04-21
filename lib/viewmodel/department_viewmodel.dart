import 'package:flutter/material.dart';
import 'package:neon_met_app/data/models/department_model.dart';
import 'package:neon_met_app/data/services/met_api_service.dart';

class DepartmentViewModel extends ChangeNotifier {
  final MetApiService _apiService = MetApiService();

  // Store the full list and the filtered list separately
  List<DepartmentModel> _allDepartments = [];
  List<DepartmentModel> _filteredDepartments = [];

  bool _isLoading = false;
  String? _errorMessage;

  final Map<int, String?> departmentImages = {};

  // Exposed getters
  List<DepartmentModel> get departments => _filteredDepartments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<DepartmentModel> get allDepartments => _allDepartments;

  /// Initial load of departments (single API call)
  Future<void> fetchDepartments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Fetch all departments once
      _allDepartments = await _apiService.fetchDepartments();
      // Initially show all
      _filteredDepartments = List.from(_allDepartments);

      // Fetch images asynchronously (won't block the UI)
      for (final dept in _allDepartments) {
        fetchDepartmentImage(dept.departmentId).then((url) {
          departmentImages[dept.departmentId] = url;
          notifyListeners();
        });
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch a representative image for a department
  Future<String?> fetchDepartmentImage(int departmentId) async {
    try {
      final objectIds =
          await _apiService.fetchObjectIDsByDepartment(departmentId);
      if (objectIds.isEmpty) return null;

      final object = await _apiService.fetchObjectById(objectIds.first);
      return (object.primaryImageSmall?.isNotEmpty == true)
          ? object.primaryImageSmall
          : null;
    } catch (e) {
      debugPrint("Departman görseli alınamadı: $e");
      return null;
    }
  }

  /// In-memory filtering without further API calls
  void filterDepartments(String query) {
    final lower = query.trim().toLowerCase();
    if (lower.isEmpty) {
      // Restore full list
      _filteredDepartments = List.from(_allDepartments);
    } else {
      _filteredDepartments = _allDepartments
          .where((dept) => dept.displayName.toLowerCase().contains(lower))
          .toList();
    }
    notifyListeners();
  }
}
