import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/custom_search_field.dart';
import '../../../../core/constants/app_strings.dart';

/// Search field used by the Bookmarks hub.
class BookmarkSearchBar extends StatelessWidget {
  const BookmarkSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return CustomSearchField(
      controller: controller,
      hintText: AppStrings.bookmarksSearchHint,
      prefixIcon: const Icon(AppIcons.bookmark),
      onChanged: onChanged,
      autofocus: autofocus,
      showClearButton: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    );
  }
}
