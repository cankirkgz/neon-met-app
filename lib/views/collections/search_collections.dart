import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:neon_met_app/core/constants/app_sizes.dart';
import 'package:neon_met_app/core/constants/app_string.dart';
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
    super.key,
    required this.departmentId,
    required this.departmentName,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchCollectionsViewModel>();
    final favVm = context.watch<FavoriteViewModel>();
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final isTablet = size.shortestSide >= 600;
    final isPortraitPhone = !isLandscape && !isTablet;

    if (vm.loadedDepartmentId != departmentId && !vm.isLoading) {
      Future.microtask(() => vm.fetchObjects(departmentId));
    }

    final filtered = vm.filteredObjects;

    Widget buildContent() {
      if (vm.error != null) {
        return Center(child: Text('${AppStrings.error}: ${vm.error}'));
      }
      if (vm.loadedDepartmentId != departmentId || vm.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (filtered.isEmpty) {
        return const Center(
          child: Text(
            AppStrings.noResultsFound,
            style: TextStyle(
              fontSize: AppSizes.fontL,
              color: AppColors.textSecondary,
            ),
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingM),
        child: GridView.builder(
          itemCount: filtered.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isPortraitPhone ? 2 : (isTablet ? 4 : 3),
            mainAxisSpacing: AppSizes.spacingM,
            crossAxisSpacing: AppSizes.spacingM,
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
                context.router.push(ArtworkDetailRoute(objectId: obj.objectID));
              },
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        title: Text(
          departmentName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: isPortraitPhone
            ? Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.spacingL,
                      vertical: AppSizes.spacingM,
                    ),
                    child: SearchField(),
                  ),
                  Expanded(child: buildContent()),
                ],
              )
            : Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(AppSizes.spacingL),
                      child: SearchField(),
                    ),
                  ),
                  Container(width: 1, color: AppColors.textSecondary[300]),
                  Expanded(flex: 3, child: buildContent()),
                ],
              ),
      ),
    );
  }
}
