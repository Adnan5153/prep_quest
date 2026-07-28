import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../constants/review_strings.dart';

/// Toggleable bookmark control matching the Quiz Engine's
/// [QuizBookmarkButton] visual style.
///
/// Renders a filled or outlined bookmark icon depending on [isBookmarked].
class BookmarkButton extends StatelessWidget {
  const BookmarkButton({
    super.key,
    required this.isBookmarked,
    required this.onTap,
    this.size = 22,
    this.tooltip,
  });

  final bool isBookmarked;
  final VoidCallback onTap;
  final double size;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
      button: true,
      toggled: isBookmarked,
      label: tooltip ??
          (isBookmarked
              ? ReviewStrings.bookmarkRemove
              : ReviewStrings.bookmarkAdd),
      child: Material(
        color: theme.colorScheme.surface,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Tooltip(
              message: tooltip ??
                  (isBookmarked
                      ? ReviewStrings.bookmarkRemove
                      : ReviewStrings.bookmarkAdd),
              child: Icon(
                isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                size: size,
                color: isBookmarked
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small read-only bookmark badge used in lists.
class BookmarkBadge extends StatelessWidget {
  const BookmarkBadge({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: (color ?? theme.colorScheme.primary).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.bookmark_rounded,
            size: 12,
            color: color ?? theme.colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            'Saved',
            style: theme.textTheme.labelSmall?.copyWith(
              color: color ?? theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}