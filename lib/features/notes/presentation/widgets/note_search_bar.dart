import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_search_field.dart';

/// Search field used by the Notes hub.
class NoteSearchBar extends StatelessWidget {
  const NoteSearchBar({
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
      hintText: AppStrings.notesSearchHint,
      prefixIcon: const Icon(AppIcons.noteSearch),
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
