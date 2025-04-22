import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_sizes.dart';
import 'package:neon_met_app/core/constants/app_string.dart';
import 'package:neon_met_app/data/models/favorite_artwork.dart';
import 'package:neon_met_app/data/models/object_model.dart';
import 'package:neon_met_app/routes/app_router.dart';
import 'package:neon_met_app/viewmodel/favorite_viewmodel.dart';
import 'package:neon_met_app/widgets/molecules/artwork_card.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ArtworkListScreen extends StatelessWidget {
  final String title;
  final List<ObjectModel> objects;

  const ArtworkListScreen({
    super.key,
    required this.title,
    required this.objects,
  });

  @override
  Widget build(BuildContext context) {
    final favVm = context.watch<FavoriteViewModel>();
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final isTablet = size.shortestSide >= 600;
    final isPortraitPhone = !isLandscape && !isTablet;

    Widget buildCard(ObjectModel obj) {
      final isFav = favVm.isFavorite(obj.objectID);
      return ArtworkCard(
        image: obj.primaryImageSmall ?? '',
        title: obj.title,
        subTitle: obj.artistDisplayName?.isNotEmpty == true
            ? obj.artistDisplayName!
            : (obj.culture ?? AppStrings.unknown),
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
    }

    final appBar = AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      centerTitle: true,
    );

    // Responsive column count ve ratio
    int getCrossAxisCount() {
      if (isTablet) {
        return isLandscape ? 4 : 3;
      }
      return isLandscape ? 3 : 2;
    }

    double getAspectRatio() {
      if (isTablet) {
        return isLandscape ? 0.85 : 0.9;
      }
      return isLandscape ? 0.7 : 0.75;
    }

    double getMainSpacing() {
      return isTablet ? AppSizes.spacingL : AppSizes.spacingM;
    }

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.all(isTablet ? AppSizes.spacingL : AppSizes.spacingM),
          child: isPortraitPhone
              ? ListView.separated(
                  itemCount: objects.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: getMainSpacing()),
                  itemBuilder: (context, index) => buildCard(objects[index]),
                )
              : GridView.builder(
                  itemCount: objects.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: getCrossAxisCount(),
                    mainAxisSpacing: getMainSpacing(),
                    crossAxisSpacing: getMainSpacing(),
                    childAspectRatio: getAspectRatio(),
                  ),
                  itemBuilder: (context, index) => buildCard(objects[index]),
                ),
        ),
      ),
    );
  }
}
