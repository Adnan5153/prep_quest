import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../domain/entities/lesson_entity.dart';
import 'lesson_card_utils.dart';

class LessonCardHeader extends StatelessWidget {
  const LessonCardHeader({
    super.key,
    required this.lesson,
    required this.isBookmarked,
    this.onBookmarkTap,
  });

  final LessonEntity lesson;
  final bool isBookmarked;
  final VoidCallback? onBookmarkTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LessonCardUtils.subjectAvatar(theme: theme, subject: lesson.subject),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                lesson.subject,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                lesson.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (lesson.subtitle.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xxs),
                  child: Text(
                    lesson.subtitle,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
        IconButton(
          tooltip: isBookmarked ? 'Remove bookmark' : 'Add bookmark',
          onPressed: onBookmarkTap,
          icon: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}