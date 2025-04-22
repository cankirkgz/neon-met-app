// lib/screens/artwork_detail_screen.dart
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:neon_met_app/core/constants/app_sizes.dart';
import 'package:neon_met_app/core/constants/app_string.dart';
import 'package:neon_met_app/data/models/favorite_artwork.dart';
import 'package:neon_met_app/data/models/object_model.dart';
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
    final isPortraitPhone = size.shortestSide < 600;

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
            body: Center(child: Text('${AppStrings.error}: ${snapshot.error}')),
          );
        }

        final obj = snapshot.data!;
        final favVm = context.watch<FavoriteViewModel>();
        final isFav = favVm.isFavorite(objectId);

        final appBar = AppBar(
          title: Text(obj.title,
              style: const TextStyle(fontWeight: FontWeight.w500)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? AppColors.error : AppColors.textSecondary[700],
              ),
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
        );

        return Scaffold(
          appBar: appBar,
          body: isPortraitPhone
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageSection(context, obj),
                      const SizedBox(height: AppSizes.spacingL),
                      _buildDetailsSection(obj),
                    ],
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSizes.spacingM),
                        child: _buildImageSection(context, obj),
                      ),
                    ),
                    Container(width: 1, color: AppColors.textSecondary[300]),
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSizes.spacingM),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
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
        const SizedBox(height: AppSizes.spacingM),
        Text(
          obj.artistDisplayName ?? obj.culture ?? AppStrings.unknown,
          style: const TextStyle(
            fontSize: AppSizes.fontL,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (obj.objectDate != null) ...[
          const SizedBox(height: AppSizes.spacingS),
          Text(obj.objectDate!,
              style: const TextStyle(color: AppColors.textSecondary)),
        ],
        if (obj.creditLine != null) ...[
          const SizedBox(height: AppSizes.spacingM),
          Text(obj.creditLine!,
              style: const TextStyle(fontSize: AppSizes.fontM)),
        ],
      ],
    );
  }

  Widget _buildDetailsSection(ObjectModel obj) {
    return Container(
      width: double.infinity,
      color: AppColors.mutedBackground,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingM,
        vertical: AppSizes.spacingL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Artwork Details',
            style: TextStyle(
                fontSize: AppSizes.fontXL, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSizes.spacingM),
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
      padding: const EdgeInsets.only(bottom: AppSizes.spacingM),
      child: RichText(
        text: TextSpan(
          text: '$title: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppSizes.fontM,
            color: AppColors.scaffoldDark,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
