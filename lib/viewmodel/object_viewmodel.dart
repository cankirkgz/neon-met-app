import 'package:flutter/material.dart';
import 'package:neon_met_app/data/models/object_model.dart';
import 'package:neon_met_app/data/services/object_service.dart';

class ObjectViewModel extends ChangeNotifier {
  final _service = ObjectService();

  bool isLoading = false;
  String? errorMessage;

  List<ObjectModel> currentExhibitions = [];
  List<ObjectModel> famousArtworks = [];

  Future<void> _fetchAndStore({
    required Future<List<int>> Function() idFetcher,
    required void Function(List<ObjectModel>) store,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final ids = await idFetcher();
      final objects =
          await Future.wait(ids.take(10).map(_service.fetchObjectById));
      store(objects
          .where((e) => e.primaryImageSmall?.isNotEmpty ?? false)
          .toList());
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Şu anda sergilenen öne‑çıkan eserler
  Future<void> fetchCurrentExhibitions() async {
    await _fetchAndStore(
      idFetcher: () =>
          _service.searchObjectsOnView(onView: true, highlight: true),
      store: (list) => currentExhibitions = list,
    );
  }

  /// Popüler / klasik tablolar
  Future<void> fetchFamousArtworks() async {
    await _fetchAndStore(
      idFetcher: () => _service.searchObjects(query: 'painting'),
      store: (list) => famousArtworks = list,
    );
  }
}
