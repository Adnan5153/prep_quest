import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_search_field.dart';

/// Thin composition over [CustomSearchField] so the search feature has
/// a single, named entry point with sensible defaults.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    this.focusNode,
    this.autofocus = true,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return CustomSearchField(
      controller: controller,
      focusNode: focusNode,
      hintText: AppStrings.searchHint,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
      showClearButton: true,
    );
  }
}