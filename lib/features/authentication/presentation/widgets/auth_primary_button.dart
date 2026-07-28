import 'package:flutter/material.dart';

import '../../../../core/widgets/primary_button.dart';

/// Auth-themed primary call-to-action.
///
/// Wraps the reusable [PrimaryButton] so the auth screens have a
/// consistent CTA (green gradient, large size, full-width).
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: label,
      onPressed: onPressed,
      isLoading: isLoading,
      fullWidth: fullWidth,
      variant: PrimaryButtonVariant.gradient,
      size: PrimaryButtonSize.large,
      shape: PrimaryButtonShape.pill,
      icon: icon,
    );
  }
}