import 'package:flutter/material.dart';

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

  static const double _imageHeight = 250;
  static const double _textBlockHeight = 80;

  const ArtworkCard({
    super.key,
    required this.image,
    required this.title,
    this.subTitle,
    this.width,
    this.isAsset = false,
    this.onPressed,
    this.showFavoriteButton = false, // Varsayılan olarak false
    this.isFavorite = false, // Varsayılan olarak false
    this.onFavoritePressed, // Butona tıklandığında çağrılacak fonksiyon
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
            child: const Text('Kapat'),
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

        double titleFontSize;
        double subtitleFontSize;
        if (cardWidth > screenWidth / 2) {
          titleFontSize = 18;
          subtitleFontSize = 14;
        } else if (cardWidth >= screenWidth * 0.25) {
          titleFontSize = 16;
          subtitleFontSize = 12;
        } else {
          titleFontSize = 14;
          subtitleFontSize = 10;
        }

        return GestureDetector(
          onTap: onPressed,
          child: Container(
            width: cardWidth,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(8)),
                      child: isAsset
                          ? Image.asset(
                              image,
                              width: cardWidth,
                              height: _imageHeight,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                debugPrint(
                                    'Failed to load asset image: $image');
                                return const Center(
                                    child: Icon(Icons.broken_image));
                              },
                            )
                          : Image.network(
                              image,
                              width: cardWidth,
                              height: _imageHeight,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/icons/image_not_found.png',
                                  width: cardWidth,
                                  height: _imageHeight,
                                  fit: BoxFit.fill,
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const SizedBox(
                                  height: _imageHeight,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              },
                            ),
                    ),
                    if (showFavoriteButton)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: onFavoritePressed,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isFavorite
                                      ? 'Added to favorites'
                                      : 'Add to favorites',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                // Fixed-size text block below image
                SizedBox(
                  height: _textBlockHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (subTitle != null && subTitle!.trim().isNotEmpty)
                          Text(
                            subTitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: subtitleFontSize,
                              color: Colors.grey,
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
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
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
