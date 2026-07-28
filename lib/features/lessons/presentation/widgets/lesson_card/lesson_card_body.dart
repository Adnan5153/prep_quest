import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../domain/entities/lesson_entity.dart';

class LessonCardBody extends StatelessWidget {
  const LessonCardBody({
    super.key,
    required this.lesson,
    required this.progress,
  });

  final LessonEntity lesson;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          lesson.summary,
          style: theme.textTheme.bodyMedium,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.md),
        LinearProgressIndicator(
          value: progress,
          minHeight: 6,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(
            theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${(progress * 100).round()}% read',
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }
}