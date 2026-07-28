import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/widgets/secondary_button.dart';

/// CTA used by the Restore Purchase screen. Wraps the core
/// `SecondaryButton` with a fixed layout and a fixed icon so the
/// presentation layer can stay clean.
class RestoreButton extends StatelessWidget {
  const RestoreButton({
    super.key,
    required this.onPressed,
    this.label = 'Restore purchase',
    this.isLoading = false,
    this.fullWidth = true,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return SecondaryButton(
      text: label,
      icon: Icons.refresh_rounded,
      isLoading: isLoading,
      fullWidth: fullWidth,
      onPressed: onPressed,
      shape: SecondaryButtonShape.rounded,
      borderRadius: AppRadius.md,
      iconSize: AppSizes.iconMd,
    );
  }
}
