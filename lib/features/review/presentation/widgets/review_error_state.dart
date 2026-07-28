import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../constants/review_strings.dart';

/// Error state used by the Review screen when the fetch fails.
class ReviewErrorState extends StatelessWidget {
  const ReviewErrorState({
    super.key,
    required this.onRetry,
    this.message,
  });

  final VoidCallback onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.cloud_off_outlined,
                size: 44,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              ReviewStrings.errorTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message ?? ReviewStrings.errorSubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(ReviewStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}