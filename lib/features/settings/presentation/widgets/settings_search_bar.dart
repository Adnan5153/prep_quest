import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/custom_search_field.dart';

/// Search field shown at the top of the Settings hub. Wraps
/// [CustomSearchField] with the standard padding & radius.
class SettingsSearchBar extends StatelessWidget {
  const SettingsSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search settings',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: CustomSearchField(
        controller: controller,
        hintText: hintText,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        borderRadius: AppRadius.lg,
        prefixIcon: const Icon(Icons.search_rounded),
      ),
    );
  }
}