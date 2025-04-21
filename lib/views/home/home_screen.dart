import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:neon_met_app/routes/app_router.dart';
import 'package:neon_met_app/viewmodel/object_viewmodel.dart';
import 'package:neon_met_app/widgets/atoms/section_title.dart';
import 'package:neon_met_app/widgets/molecules/artwork_card.dart';
import 'package:neon_met_app/widgets/molecules/welcome_banner.dart';
import 'package:neon_met_app/widgets/organism/artwork_horizontal_list.dart';
import 'package:provider/provider.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ObjectViewModel>();

    if (!vm.isLoading &&
        vm.currentExhibitions.isEmpty &&
        vm.famousArtworks.isEmpty) {
      Future.microtask(() {
        final notifier = context.read<ObjectViewModel>();
        notifier.fetchCurrentExhibitions();
        notifier.fetchFamousArtworks();
      });
    }

    final double cardWidth = MediaQuery.of(context).size.width * 0.4;

    final currentCards = vm.currentExhibitions.map(
      (obj) => ArtworkCard(
        image: obj.primaryImageSmall ?? '',
        title: obj.title,
        subTitle: obj.artistDisplayName?.isNotEmpty == true
            ? obj.artistDisplayName
            : (obj.culture ?? 'Unknown'),
        width: cardWidth,
        onPressed: () {
          context.router.push(ArtworkDetailRoute(objectId: obj.objectID));
        },
      ),
    );

    final famousCards = vm.famousArtworks.map(
      (obj) => ArtworkCard(
        image: obj.primaryImageSmall ?? '',
        title: obj.title,
        subTitle: obj.artistDisplayName?.isNotEmpty == true
            ? obj.artistDisplayName
            : (obj.culture ?? 'Unknown'),
        width: cardWidth,
        onPressed: () {
          context.router.push(ArtworkDetailRoute(objectId: obj.objectID));
        },
      ),
    );

    if (vm.isLoading &&
        vm.currentExhibitions.isEmpty &&
        vm.famousArtworks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 64),
          Center(
            child: Image.asset(
              'assets/images/the_met_logo.png',
              width: 100,
              height: 100,
            ),
          ),
          const SizedBox(height: 24),
          const WelcomeBanner(),
          const SizedBox(height: 32),
          _Section(
            title: "Current Exhibitions",
            cards: currentCards.toList(),
            onSeeAllPressed: () {
              context.router.push(
                ArtworkListRoute(
                  title: "Current Exhibitions",
                  objects: vm.currentExhibitions,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          _Section(
            title: "Famous Artworks",
            cards: famousCards.toList(),
            onSeeAllPressed: () {
              context.router.push(
                ArtworkListRoute(
                  title: "Famous Artworks",
                  objects: vm.famousArtworks,
                ),
              );
            },
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.cards,
    required this.onSeeAllPressed,
  });

  final String title;
  final List<ArtworkCard> cards;
  final VoidCallback onSeeAllPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SectionTitle(
            title: title,
            onPressed: onSeeAllPressed,
          ),
          const SizedBox(height: 10),
          ArtworkHorizontalList(cards: cards),
        ],
      ),
    );
  }
}
