import 'package:flutter/material.dart';
import 'package:neon_met_app/widgets/molecules/artwork_card.dart';

class ArtworkHorizontalList extends StatelessWidget {
  /// Dışarıdan gelen ArtworkCard widget’larının listesi
  final List<ArtworkCard> cards;

  /// Kartlar arasındaki boşluk
  final double spacing;

  /// İç kenar boşlukları (başlangıç & bitiş)
  final EdgeInsetsGeometry padding;

  const ArtworkHorizontalList({
    super.key,
    required this.cards,
    this.spacing = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            cards[i],
            if (i < cards.length - 1) SizedBox(width: spacing),
          ],
        ],
      ),
    );
  }
}
