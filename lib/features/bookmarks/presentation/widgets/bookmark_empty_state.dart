import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../router.dart';

/// Empty/empty-filter state for the Bookmarks hub.
class BookmarkEmptyState extends StatelessWidget {
  const BookmarkEmptyState({super.key, this.filtered = false, this.onClearFilter});

  final bool filtered;
  final VoidCallback? onClearFilter;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              filtered ? Icons.search_off_rounded : Icons.bookmark_border_rounded,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              filtered ? AppStrings.bookmarksEmptyFiltered : AppStrings.bookmarksEmpty,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              filtered
                  ? 'Try another search or choose a different category.'
                  : AppStrings.bookmarksEmptySubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (filtered && onClearFilter != null)
              OutlinedButton.icon(
                onPressed: onClearFilter,
                icon: const Icon(Icons.filter_alt_off_rounded),
                label: const Text(AppStrings.bookmarksClearFilterCta),
              )
            else
              FilledButton.icon(
                onPressed: () => context.goNamed(AppRoutes.lessons),
                icon: const Icon(AppIcons.book),
                label: const Text(AppStrings.bookmarksBrowseContent),
              ),
          ],
        ),
      ),
    );
  }
}