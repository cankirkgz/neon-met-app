import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:neon_met_app/core/constants/app_sizes.dart';
import 'package:neon_met_app/core/constants/app_string.dart';

class ArtworkCard extends StatelessWidget {
  final String image;
  final bool isAsset;
  final String? subTitle;
  final String title;
  final double? width;
  final VoidCallback? onPressed;
  final bool showFavoriteButton;
  final bool isFavorite;
  final VoidCallback? onFavoritePressed;

  // Sabit image yüksekliği
  static const double _imageHeight = 250;

  const ArtworkCard({
    super.key,
    required this.image,
    required this.title,
    this.subTitle,
    this.width,
    this.isAsset = false,
    this.onPressed,
    this.showFavoriteButton = false,
    this.isFavorite = false,
    this.onFavoritePressed,
  });

  void _showFullDescription(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: subTitle != null ? Text(subTitle!) : null,
        content: Text(title),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = width ?? constraints.maxWidth;

        // Eşik değerleri
        final smallThreshold = screenWidth * 0.3;
        final mediumThreshold = screenWidth * 0.5;

        // Font boyutlarını belirle
        double titleFontSize, subtitleFontSize;
        if (cardWidth <= smallThreshold) {
          titleFontSize = AppSizes.fontM;
          subtitleFontSize = AppSizes.fontS;
        } else if (cardWidth <= mediumThreshold) {
          titleFontSize = AppSizes.fontL;
          subtitleFontSize = AppSizes.fontM;
        } else {
          titleFontSize = AppSizes.fontXL;
          subtitleFontSize = AppSizes.fontL;
        }

        return GestureDetector(
          onTap: onPressed,
          child: Container(
            width: cardWidth,
            decoration: BoxDecoration(
              color: AppColors.textSecondary[100],
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Görsel ve Favori Butonu
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppSizes.radiusS),
                      ),
                      child: isAsset
                          ? Image.asset(
                              image,
                              width: cardWidth,
                              height: _imageHeight,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Center(child: Icon(Icons.broken_image)),
                            )
                          : Image.network(
                              image,
                              width: cardWidth,
                              height: _imageHeight,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                'assets/icons/image_not_found.png',
                                width: cardWidth,
                                height: _imageHeight,
                                fit: BoxFit.cover,
                              ),
                              loadingBuilder: (_, child, progress) =>
                                  progress == null
                                      ? child
                                      : const SizedBox(
                                          height: _imageHeight,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                            ),
                    ),
                    if (showFavoriteButton)
                      Positioned(
                        top: AppSizes.spacingS,
                        right: AppSizes.spacingS,
                        child: GestureDetector(
                          onTap: onFavoritePressed,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.spacingS,
                              vertical: AppSizes.spacingXS,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusL),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: AppColors.scaffoldLight,
                                  size: AppSizes.fontM,
                                ),
                                const SizedBox(width: AppSizes.spacingXS),
                                Text(
                                  isFavorite
                                      ? AppStrings.addedToFavorites
                                      : AppStrings.addToFavorites,
                                  style: const TextStyle(
                                    color: AppColors.scaffoldLight,
                                    fontSize: AppSizes.fontS,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                // Metin Bloğu
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacingS,
                    vertical: AppSizes.spacingXS,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (subTitle != null && subTitle!.trim().isNotEmpty)
                        Text(
                          subTitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: subtitleFontSize,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      GestureDetector(
                        onTap: () => _showFullDescription(context),
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            color: AppColors.scaffoldDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
