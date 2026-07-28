import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/date_extension.dart';
import '../../domain/entities/review_question_entity.dart';
import '../constants/review_strings.dart';
import 'bookmark_button.dart';
import 'review_answer_section.dart';

/// Single review entry. Renders the question prompt, a status pill,
/// every answer option colour-coded against the user's selection, and
/// the full explanation if one is available.
class ReviewQuestionCard extends StatelessWidget {
  const ReviewQuestionCard({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onToggleBookmark,
  });

  final ReviewQuestionEntity entry;
  final VoidCallback onTap;
  final VoidCallback onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Ink(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _Header(entry: entry, onToggleBookmark: onToggleBookmark),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  entry.question.prompt,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ReviewAnswerSection(
                  answers: entry.question.answers,
                  selectedAnswerIds: entry.selectedSet,
                ),
                if (entry.question.explanation != null &&
                    entry.question.explanation!.isNotEmpty) ...<Widget>[
                  const SizedBox(height: AppSpacing.md),
                  _ExplanationBlock(body: entry.question.explanation!),
                ],
                const SizedBox(height: AppSpacing.sm),
                Divider(color: theme.colorScheme.outlineVariant),
                const SizedBox(height: AppSpacing.sm),
                _Footer(entry: entry),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.entry, required this.onToggleBookmark});

  final ReviewQuestionEntity entry;
  final VoidCallback onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              ReviewStatusPill(
                wasCorrect: entry.wasCorrect,
                wasSkipped: entry.isSkipped,
              ),
              if (entry.isBookmarked) const BookmarkBadge(),
            ],
          ),
        ),
        BookmarkButton(
          isBookmarked: entry.isBookmarked,
          onTap: onToggleBookmark,
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.entry});

  final ReviewQuestionEntity entry;

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MMM d, y · h:mm a');
    final String attemptedAt = formatter.format(entry.attemptedAt);
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        _MetaChip(
          icon: Icons.menu_book_outlined,
          label: entry.quizTitle,
        ),
        _MetaChip(
          icon: Icons.history_outlined,
          label: entry.timeSpentSeconds.asDuration(),
        ),
        _MetaChip(
          icon: Icons.event_outlined,
          label: attemptedAt,
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.xxs),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ExplanationBlock extends StatelessWidget {
  const _ExplanationBlock({required this.body});

  final String body;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.lightbulb_outline,
                size: 18,
                color: theme.colorScheme.onTertiaryContainer,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                ReviewStrings.explanation,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onTertiaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}