import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:neon_met_app/data/models/favorite_artwork.dart';
import 'package:neon_met_app/routes/app_router.dart';
import 'package:neon_met_app/viewmodel/favorite_viewmodel.dart';
import 'package:neon_met_app/viewmodel/search_collections_viewmodel.dart';
import 'package:neon_met_app/widgets/atoms/search_field.dart';
import 'package:neon_met_app/widgets/molecules/artwork_card.dart';
import 'package:provider/provider.dart';

@RoutePage()
class SearchCollectionsScreen extends StatelessWidget {
  final int departmentId;
  final String departmentName;

  const SearchCollectionsScreen({
    Key? key,
    required this.departmentId,
    required this.departmentName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchCollectionsViewModel>();
    final favVm = context.watch<FavoriteViewModel>();
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final isTablet = size.shortestSide >= 600;
    final isPortraitPhone = !isLandscape && !isTablet;

    // Initial load
    if (vm.loadedDepartmentId != departmentId && !vm.isLoading) {
      Future.microtask(() => vm.fetchObjects(departmentId));
    }

    final filtered = vm.filteredObjects;

    // Portrait phones: original layout
    if (isPortraitPhone) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
          title: Text(departmentName,
              style: const TextStyle(fontWeight: FontWeight.w500)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Search Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SearchField(onChanged: vm.filterObjects),
            ),
            // Content Area
            Expanded(
              child: Builder(builder: (_) {
                if (vm.error != null) {
                  return Center(child: Text("Hata: \${vm.error}"));
                }
                if (vm.loadedDepartmentId != departmentId || vm.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      "No results found.",
                      style: TextStyle(
                          fontSize: 16, color: AppColors.textSecondary),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    itemCount: filtered.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.6,
                    ),
                    itemBuilder: (context, index) {
                      final obj = filtered[index];
                      final isFav = favVm.isFavorite(obj.objectID);

                      return ArtworkCard(
                        image: obj.primaryImageSmall ?? '',
                        title: obj.title,
                        subTitle: obj.artistDisplayName ?? obj.culture ?? '',
                        showFavoriteButton: true,
                        isFavorite: isFav,
                        onFavoritePressed: () {
                          final fav = FavoriteArtwork(
                            objectId: obj.objectID,
                            title: obj.title,
                            image: obj.primaryImageSmall,
                            artist: obj.artistDisplayName ?? obj.culture,
                            department: obj.department,
                          );
                          favVm.toggleFavorite(fav);
                        },
                        onPressed: () {
                          context.router
                              .push(ArtworkDetailRoute(objectId: obj.objectID));
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

    // Landscape & tablets: split panels
    final crossCount = isTablet ? 4 : 3;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        title: Text(departmentName,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Row(
          children: [
            // Left: Search Panel
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: SearchField(onChanged: vm.filterObjects),
              ),
            ),
            // Divider
            Container(width: 1, color: AppColors.textSecondary[300]),
            // Right: Grid Results
            Expanded(
              flex: 3,
              child: Builder(builder: (_) {
                if (vm.error != null) {
                  return Center(child: Text("Hata: \${vm.error}"));
                }
                if (vm.loadedDepartmentId != departmentId || vm.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      "No results found.",
                      style: TextStyle(
                          fontSize: 16, color: AppColors.textSecondary),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView.builder(
                    itemCount: filtered.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossCount,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.6,
                    ),
                    itemBuilder: (context, index) {
                      final obj = filtered[index];
                      final isFav = favVm.isFavorite(obj.objectID);

                      return ArtworkCard(
                        image: obj.primaryImageSmall ?? '',
                        title: obj.title,
                        subTitle: obj.artistDisplayName ?? obj.culture ?? '',
                        showFavoriteButton: true,
                        isFavorite: isFav,
                        onFavoritePressed: () {
                          final fav = FavoriteArtwork(
                            objectId: obj.objectID,
                            title: obj.title,
                            image: obj.primaryImageSmall,
                            artist: obj.artistDisplayName ?? obj.culture,
                            department: obj.department,
                          );
                          favVm.toggleFavorite(fav);
                        },
                        onPressed: () {
                          context.router
                              .push(ArtworkDetailRoute(objectId: obj.objectID));
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
