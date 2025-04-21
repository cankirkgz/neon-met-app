import 'package:flutter/material.dart';

class BottomNavItem extends StatelessWidget {
  final String icon;
  final String selectedIcon;
  final String title;
  final bool isSelected;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.selectedIcon,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
            isSelected ? 'assets/icons/$selectedIcon' : 'assets/icons/$icon'),
        Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.red : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
