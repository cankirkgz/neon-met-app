import 'package:flutter/material.dart';

class CenterNavButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const CenterNavButton({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            isSelected
                ? 'assets/icons/btn_tabbar_collection_selected.png'
                : 'assets/icons/btn_tabbar_collection_unselected.png',
          ),
        ),
      ),
    );
  }
}
