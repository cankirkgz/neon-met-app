// lib/screens/info_screen.dart
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_string.dart';
import 'package:provider/provider.dart';

import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:neon_met_app/core/constants/app_sizes.dart';
import 'package:neon_met_app/core/theme/theme_provider.dart';
import 'package:neon_met_app/viewmodel/info_viewmodel.dart';
import 'package:neon_met_app/widgets/molecules/highlight_message_card.dart';
import 'package:neon_met_app/widgets/molecules/location_card.dart';

@RoutePage()
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InfoViewModel>();
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final isTablet = size.shortestSide >= 600;
    final isPortraitPhone = !isLandscape && !isTablet;

    final appBar = AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      title: const Text(
        AppStrings.infoTitle,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: () {
            context.read<ThemeProvider>().toggle();
          },
        ),
      ],
    );

    if (isPortraitPhone) {
      return Scaffold(
        appBar: appBar,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HighlightMessageCard(
                  imageName: 'img_info_01.png',
                  text: AppStrings.highlightInfoMessage,
                ),
                const SizedBox(height: AppSizes.spacingL),
                const Text(
                  AppStrings.locationsAndHours,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: AppSizes.fontXL),
                ),
                const SizedBox(height: AppSizes.spacingM),
                ...vm.locations.map((loc) => LocationCard(location: loc)),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              flex: 1,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSizes.spacingM),
                child: HighlightMessageCard(
                  imageName: 'img_info_01.png',
                  text: AppStrings.highlightInfoMessage,
                ),
              ),
            ),
            Container(width: 1, color: AppColors.textSecondary[300]),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.locationsAndHours,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppSizes.fontXL,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingM),
                    ...vm.locations.map(
                      (loc) => LocationCard(location: loc),
                    ),
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
