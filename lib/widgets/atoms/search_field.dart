import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';
import 'package:neon_met_app/core/constants/app_sizes.dart';
import 'package:neon_met_app/core/constants/app_string.dart';

class SearchField extends StatefulWidget {
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final TextEditingController? controller;

  const SearchField({
    super.key,
    this.onSubmitted,
    this.onChanged,
    this.hintText = AppStrings.searchHint,
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
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: TextFormField(
                    focusNode: _focusNode,
                    controller: widget.controller,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary[600],
                        fontSize: AppSizes.fontL,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingL,
                        vertical: AppSizes.spacingM,
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: AppSizes.fontL),
                    onChanged: widget.onChanged,
                    onFieldSubmitted: widget.onSubmitted,
                  ),
                ),
                Container(
                  width: AppSizes.spacingXS,
                  color: isFocused
                      ? AppColors.scaffoldDark
                      : AppColors.textSecondary[300],
                ),
                Image.asset(
                  isFocused
                      ? 'assets/icons/btn_search_selected@3x.png'
                      : 'assets/icons/btn_search_unselected@3x.png',
                  width: AppSizes.iconSplashSize * 0.75,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
