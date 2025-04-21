import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';

class SearchField extends StatefulWidget {
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final TextEditingController? controller;

  const SearchField({
    super.key,
    this.onSubmitted,
    this.onChanged,
    this.hintText = 'Search...',
    this.controller,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late FocusNode _focusNode;
  final ValueNotifier<bool> _isFocused = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
        _isFocused.value = _focusNode.hasFocus;
      });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _isFocused.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isFocused,
      builder: (context, isFocused, _) {
        final borderColor =
            isFocused ? AppColors.scaffoldDark : AppColors.textSecondary[400]!;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.scaffoldLight,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Arama alanı
                Expanded(
                  child: TextFormField(
                    focusNode: _focusNode,
                    controller: widget.controller,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                          color: AppColors.textSecondary[600], fontSize: 18),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 16),
                    onChanged: widget.onChanged,
                    onFieldSubmitted: widget.onSubmitted,
                  ),
                ),
                // Dikey çizgi
                Container(
                  width: 2,
                  color: isFocused
                      ? AppColors.scaffoldDark
                      : AppColors.textSecondary[300],
                ),
                // Arama ikonu
                Image.asset(
                  isFocused
                      ? 'assets/icons/btn_search_selected@3x.png'
                      : 'assets/icons/btn_search_unselected@3x.png',
                  width: 60,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
