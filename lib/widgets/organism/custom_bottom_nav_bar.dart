import 'package:flutter/material.dart';
import 'package:neon_met_app/widgets/molecules/bottom_nav_item.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // SADECE alttan boşluk – solda‑sağda yok!
      padding: const EdgeInsets.only(bottom: 25),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.2),
                blurRadius: 15,
                offset: const Offset(0, 2),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(.15),
                blurRadius: 6,
              ),
            ],
          ),
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            elevation: 0,
            color: Colors.white,
            child: SizedBox(
              height: 60,
              child: Row(
                children: [
                  const SizedBox(width: 50), // sol iç boşluk
                  // ---- Sol item ----
                  GestureDetector(
                    onTap: () => onItemSelected(0),
                    child: BottomNavItem(
                      icon: 'btn_tabbar_home_unselected.png',
                      selectedIcon: 'btn_tabbar_home_selected.png',
                      title: 'Home',
                      isSelected: selectedIndex == 0,
                    ),
                  ),
                  const Spacer(), // ekranın sol yarısı
                  const SizedBox(width: 72), // FAB + notch için boşluk
                  const Spacer(), // ekranın sağ yarısı
                  // ---- Sağ item ----
                  GestureDetector(
                    onTap: () => onItemSelected(2),
                    child: BottomNavItem(
                      icon: 'btn_tabbar_info_unselected.png',
                      selectedIcon: 'btn_tabbar_info_selected.png',
                      title: 'Info',
                      isSelected: selectedIndex == 2,
                    ),
                  ),
                  const SizedBox(width: 50), // sağ iç boşluk
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
