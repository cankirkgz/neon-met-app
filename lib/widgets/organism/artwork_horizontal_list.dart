import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_sizes.dart';
import 'package:neon_met_app/widgets/molecules/artwork_card.dart';

class ArtworkHorizontalList extends StatelessWidget {
  final List<ArtworkCard> cards;

  final double spacing;

  final EdgeInsetsGeometry padding;

  const ArtworkHorizontalList({
    super.key,
    required this.cards,
    this.spacing = AppSizes.spacingM,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
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
