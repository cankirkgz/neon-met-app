import 'package:flutter/material.dart';
import 'package:auto_route/annotations.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:neon_met_app/data/models/object_model.dart';
import 'package:neon_met_app/data/models/favorite_artwork.dart';
import 'package:neon_met_app/data/services/met_api_service.dart';
import 'package:neon_met_app/viewmodel/favorite_viewmodel.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ArtworkDetailScreen extends StatelessWidget {
  final int objectId;

  const ArtworkDetailScreen({Key? key, required this.objectId})
      : super(key: key);

  Future<ObjectModel> _fetchObject() =>
      MetApiService().fetchObjectById(objectId);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final isTablet = size.shortestSide >= 600;
    final isPortraitPhone = !isLandscape && !isTablet;

    return FutureBuilder<ObjectModel>(
      future: _fetchObject(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Hata: \${snapshot.error}')),
          );
        }

        final obj = snapshot.data!;
        final favVm = context.watch<FavoriteViewModel>();
        final isFav = favVm.isFavorite(objectId);

        if (isPortraitPhone) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
              title: Text(obj.title,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav
                          ? AppColors.error
                          : AppColors.textSecondary[700]),
                  onPressed: () {
                    final fav = FavoriteArtwork(
                      objectId: obj.objectID,
                      title: obj.title,
                      image: obj.primaryImageSmall,
                      artist: obj.artistDisplayName ?? obj.culture,
                      department: obj.department,
                    );
                    favVm.toggleFavorite(fav);
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSection(context, obj),
                  const SizedBox(height: 24),
                  _buildDetailsSection(obj),
                ],
              ),
            ),
          );
        }

        // Landscape or tablet: two-column layout
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
            title: Text(obj.title,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                    color:
                        isFav ? AppColors.error : AppColors.textSecondary[700]),
                onPressed: () {
                  final fav = FavoriteArtwork(
                    objectId: obj.objectID,
                    title: obj.title,
                    image: obj.primaryImageSmall,
                    artist: obj.artistDisplayName ?? obj.culture,
                    department: obj.department,
                  );
                  favVm.toggleFavorite(fav);
                },
              ),
            ],
          ),
          body: Row(
            children: [
              // Left: Image and summary
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildImageSection(context, obj),
                ),
              ),
              // Divider
              Container(width: 1, color: AppColors.textSecondary[300]),
              // Right: Details list
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildDetailsSection(obj),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSection(BuildContext context, ObjectModel obj) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: obj.primaryImageSmall != null &&
                      obj.primaryImageSmall!.isNotEmpty
                  ? Image.network(
                      obj.primaryImageSmall!,
                      width: screenWidth,
                      height: screenWidth,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/icons/image_not_found.png',
                      width: screenWidth,
                      height: screenWidth,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            obj.artistDisplayName ?? obj.culture ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (obj.objectDate != null) ...[
            const SizedBox(height: 8),
            Text(obj.objectDate!,
                style: const TextStyle(color: AppColors.textSecondary)),
          ],
          if (obj.creditLine != null) ...[
            const SizedBox(height: 12),
            Text(obj.creditLine!, style: const TextStyle(fontSize: 15)),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailsSection(ObjectModel obj) {
    return Container(
      width: double.infinity,
      color: AppColors.mutedBackground,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Artwork Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _detailItem('Title', obj.title),
          _detailItem('Date', obj.objectDate),
          _detailItem('Geography', obj.department),
          _detailItem('Culture', obj.culture),
          _detailItem('Medium', obj.medium),
          _detailItem('Dimensions', obj.dimensions),
          _detailItem('Classification', obj.classification),
          _detailItem('Credit Line', obj.creditLine),
          _detailItem('Object Number', obj.objectNumber),
        ],
      ),
    );
  }

  Widget _detailItem(String title, String? value) {
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(
        text: TextSpan(
          text: '$title: ',
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.scaffoldDark),
          children: [
            TextSpan(
                text: value,
                style: const TextStyle(fontWeight: FontWeight.normal))
          ],
        ),
      ),
    );
  }
}
