import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../constants/review_strings.dart';

/// Empty state used by the Review screen when there is nothing to show.
///
/// Distinct copy for "no attempts yet" vs "filter produced no results".
class ReviewEmptyState extends StatelessWidget {
  const ReviewEmptyState({
    super.key,
    this.filtered = false,
    this.onPrimaryAction,
    this.primaryActionLabel,
  });

  final bool filtered;
  final VoidCallback? onPrimaryAction;
  final String? primaryActionLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String title = filtered
        ? ReviewStrings.emptyFilteredTitle
        : ReviewStrings.emptyTitle;
    final String subtitle = filtered
        ? ReviewStrings.emptyFilteredSubtitle
        : ReviewStrings.emptySubtitle;

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
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                filtered
                    ? Icons.filter_alt_off_outlined
                    : Icons.history_edu_outlined,
                size: 44,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onPrimaryAction != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: onPrimaryAction,
                child: Text(primaryActionLabel ?? ReviewStrings.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}