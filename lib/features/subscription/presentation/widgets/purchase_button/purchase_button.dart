import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';

/// Primary CTA used by the Purchase Flow screen. Distinct from the
/// generic `PrimaryButton` because it owns purchase-specific micro-
/// state: a busy spinner, a "secure" trust row, and a default-price
/// caption.
class PurchaseButton extends StatelessWidget {
  const PurchaseButton({
    super.key,
    required this.label,
    required this.amountLabel,
    required this.onPressed,
    this.isProcessing = false,
    this.icon = Icons.lock_rounded,
  });

  final String label;
  final String amountLabel;
  final bool isProcessing;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool enabled = !isProcessing && onPressed != null;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          disabledBackgroundColor:
              theme.colorScheme.primary.withValues(alpha: 0.5),
          disabledForegroundColor:
              theme.colorScheme.onPrimary.withValues(alpha: 0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isProcessing)
              SizedBox(
                width: AppSizes.iconSm,
                height: AppSizes.iconSm,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else
              Icon(icon, size: AppSizes.iconMd),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                amountLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
