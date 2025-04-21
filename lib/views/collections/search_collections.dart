// lib/views/collections/search_collections.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:neon_met_app/data/models/favorite_artwork.dart';
import 'package:neon_met_app/routes/app_router.dart';
import 'package:neon_met_app/viewmodel/favorite_viewmodel.dart';
import 'package:neon_met_app/viewmodel/search_collections_viewmodel.dart';
import 'package:neon_met_app/widgets/atoms/search_field.dart';
import 'package:neon_met_app/widgets/molecules/artwork_card.dart';
import 'package:provider/provider.dart';
// lib/views/collections/search_collections.dart

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

    // Eğer bu departman için hiç yükleme yapılmadıysa tetikle
    if (vm.loadedDepartmentId != departmentId && !vm.isLoading) {
      Future.microtask(() => vm.fetchObjects(departmentId));
    }

    final filtered = vm.filteredObjects;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(departmentName,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // — SEARCH FIELD —
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: SearchField(onChanged: vm.filterObjects),
          ),

          // — CONTENT AREA —
          Expanded(
            child: Builder(builder: (_) {
              // Hata varsa göster
              if (vm.error != null) {
                return Center(child: Text("Hata: ${vm.error}"));
              }

              // **BU KISIM DEĞİŞTİ**: Eğer halen bu departmanId için yükleniyorsa
              // eski veriyi göstermeden yükleme ekranı çıkar
              if (vm.loadedDepartmentId != departmentId || vm.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // Filtrelenmiş sonuç yoksa
              if (filtered.isEmpty) {
                return const Center(
                  child: Text(
                    "No results found.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              // Nihai: grid göster
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  itemCount: filtered.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.6),
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
}
