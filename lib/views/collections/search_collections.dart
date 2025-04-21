import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:neon_met_app/routes/app_router.dart';
import 'package:neon_met_app/viewmodel/search_collections_viewmodel.dart';
import 'package:neon_met_app/widgets/atoms/search_field.dart';
import 'package:neon_met_app/widgets/molecules/artwork_card.dart';
import 'package:provider/provider.dart';

@RoutePage()
class SearchCollectionsScreen extends StatelessWidget {
  final int departmentId;
  final String departmentName;

  const SearchCollectionsScreen({
    super.key,
    required this.departmentId,
    required this.departmentName,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchCollectionsViewModel>();

    if (!vm.isLoading && vm.allObjects.isEmpty && vm.error == null) {
      Future.microtask(() {
        context.read<SearchCollectionsViewModel>().fetchObjects(departmentId);
      });
    }

    final allLoaded = vm.allObjects.isNotEmpty;
    final filtered = vm.filteredObjects;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Search The Collections",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // — SEARCH FIELD —
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: SearchField(
              onChanged: vm.filterObjects,
            ),
          ),

          // — CONTENT AREA —
          Expanded(
            child: Builder(builder: (_) {
              // Error state
              if (vm.error != null) {
                return Center(child: Text("Hata: ${vm.error}"));
              }
              // Initial load spinner (only before any data loaded)
              if (vm.isLoading && !allLoaded) {
                return const Center(child: CircularProgressIndicator());
              }
              // No matches for current query
              if (filtered.isEmpty) {
                return const Center(
                  child: Text(
                    "No results found.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }
              // Finally: show the filtered grid
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  itemCount: filtered.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.6,
                  ),
                  itemBuilder: (context, index) {
                    final obj = filtered[index];
                    return ArtworkCard(
                      image: obj.primaryImageSmall ?? '',
                      title: obj.title,
                      subTitle: obj.artistDisplayName ?? obj.culture ?? '',
                      onPressed: () {
                        context.router.push(
                          ArtworkDetailRoute(objectId: obj.objectID),
                        );
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
