// lib/screens/info_screen.dart
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:neon_met_app/core/theme/theme_provider.dart';
import 'package:neon_met_app/viewmodel/info_viewmodel.dart';
import 'package:neon_met_app/widgets/molecules/highlight_message_card.dart';
import 'package:neon_met_app/widgets/molecules/location_card.dart';

@RoutePage()
class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InfoViewModel>();
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final isTablet = size.shortestSide >= 600;
    final isPortraitPhone = !isLandscape && !isTablet;

    // AppBar'ı hem portrait hem landscape için ortak tanımlıyoruz
    final appBar = AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      title: const Text('Info', style: TextStyle(fontWeight: FontWeight.w500)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: () {
            // Tema modunu toggle et
            context.read<ThemeProvider>().toggle();
          },
        ),
      ],
    );

    // Portrait phone düzeni
    if (isPortraitPhone) {
      return Scaffold(
        appBar: appBar,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HighlightMessageCard(
                  imageName: 'img_info_01.png',
                  text:
                      'The Met presents over 5,000 years of art from around the world for everyone to experience and enjoy.',
                ),
                const SizedBox(height: 24),
                const Text(
                  'Locations and Hours',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),
                ...vm.locations.map((loc) => LocationCard(location: loc)),
              ],
            ),
          ),
        ),
      );
    }

    // Landscape veya tablet düzeni
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sol panel: Highlight mesaj
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: const HighlightMessageCard(
                  imageName: 'img_info_01.png',
                  text:
                      'The Met presents over 5,000 years of art from around the world for everyone to experience and enjoy.',
                ),
              ),
            ),
            // Bölücü çizgi
            Container(width: 1, color: AppColors.textSecondary[300]),
            // Sağ panel: konum listesi
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Locations and Hours',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    ...vm.locations.map((loc) => LocationCard(location: loc)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
