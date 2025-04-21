// lib/screens/main_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:neon_met_app/routes/app_router.dart';
import 'package:neon_met_app/widgets/organism/custom_bottom_nav_bar.dart';
import 'package:neon_met_app/widgets/molecules/center_nav_button.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        CollectionRoute(),
        InfoRoute(),
      ],
      builder: (context, child) {
        // animation parametresi kaldırıldı
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          body: child, // FadeTransition kaldırıldı, direkt child kullanılıyor
          floatingActionButton: CenterNavButton(
            isSelected: tabsRouter.activeIndex == 1,
            onTap: () => tabsRouter.setActiveIndex(1),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: tabsRouter.activeIndex,
            onItemSelected: tabsRouter.setActiveIndex,
          ),
        );
      },
    );
  }
}
