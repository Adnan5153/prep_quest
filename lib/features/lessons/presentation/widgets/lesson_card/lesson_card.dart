import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../domain/entities/lesson_entity.dart';
import 'lesson_card_body.dart';
import 'lesson_card_footer.dart';
import 'lesson_card_header.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({
    super.key,
    required this.lesson,
    required this.onTap,
    this.completionRatio,
    this.isBookmarked = false,
    this.onBookmarkTap,
  });

  final LessonEntity lesson;
  final VoidCallback onTap;
  final VoidCallback? onBookmarkTap;
  final double? completionRatio;
  final bool isBookmarked;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double progress = (completionRatio ?? 0.0).clamp(0.0, 1.0);

    return Material(
      color: theme.colorScheme.surface,
      elevation: 1,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LessonCardHeader(
                lesson: lesson,
                isBookmarked: isBookmarked,
                onBookmarkTap: onBookmarkTap,
              ),
              const SizedBox(height: AppSpacing.md),
              LessonCardBody(lesson: lesson, progress: progress),
              const SizedBox(height: AppSpacing.md),
              LessonCardFooter(lesson: lesson, progress: progress),
            ],
          ),
        ),
      ),
    );
  }
}