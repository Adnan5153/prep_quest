import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../premium_unlock_animation/premium_unlock_animation.dart';

/// Result-driven success dialog. Pops a transparent overlay with a
/// gold halo, headline, body and a primary CTA. Returns nothing — the
/// caller wires any side effects via [onClose].
class PurchaseSuccessDialog extends StatelessWidget {
  const PurchaseSuccessDialog({
    super.key,
    this.title = 'Welcome to Premium',
    this.body =
        'You now have unlimited access to Prep Quest Premium features.',
    this.primaryCtaLabel = 'Get started',
    this.secondaryCtaLabel = 'View plans',
    this.onPrimary,
    this.onSecondary,
    this.showAnimation = true,
  });

  final String title;
  final String body;
  final String primaryCtaLabel;
  final String? secondaryCtaLabel;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;
  final bool showAnimation;

  static Future<void> show(
    BuildContext context, {
    String title = 'Welcome to Premium',
    String body =
        'You now have unlimited access to Prep Quest Premium features.',
    VoidCallback? onPrimary,
    VoidCallback? onSecondary,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PurchaseSuccessDialog(
          title: title,
          body: body,
          onPrimary: () {
            Navigator.of(dialogContext).pop();
            onPrimary?.call();
          },
          onSecondary: () {
            Navigator.of(dialogContext).pop();
            onSecondary?.call();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (showAnimation)
              const PremiumUnlockAnimation(size: AppSizes.iconXl * 2)
            else
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.check_rounded,
                    color: Colors.white, size: AppSizes.iconXl),
              ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                onPressed: onPrimary,
                child: Text(
                  primaryCtaLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            if (secondaryCtaLabel != null) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: onSecondary,
                child: Text(secondaryCtaLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
