import 'package:flutter/material.dart';

import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';

// Reusable dropdown widget used across the application.
class CustomDropdown<T> extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.items,
    required this.itemLabelBuilder,
    this.value,
    this.onChanged,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.validator,
    this.enabled = true,
    this.isExpanded = true,
    this.filled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
  });

  final List<T> items;

  final T? value;

  final ValueChanged<T?>? onChanged;

  final String Function(T) itemLabelBuilder;

  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;

  final bool enabled;
  final bool isExpanded;
  final bool filled;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final EdgeInsetsGeometry contentPadding;

  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: isExpanded,
      validator: validator,
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        errorText: errorText,
        filled: filled,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemLabelBuilder(item)),
        );
      }).toList(),
    );
  }
}
