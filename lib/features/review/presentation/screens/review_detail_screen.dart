import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../../../quiz_engine/domain/entities/answer_entity.dart';
import '../../domain/entities/review_question_entity.dart';
import '../../domain/entities/review_session_entity.dart';
import '../constants/review_strings.dart';
import '../providers/review_provider.dart';
import '../widgets/ai_explanation_section.dart';
import '../widgets/bookmark_button.dart';
import '../widgets/review_answer_section.dart';

class ReviewDetailScreen extends ConsumerWidget {
  const ReviewDetailScreen({
    super.key,
    required this.questionId,
    this.quizId,
  });

  final String questionId;
  final String? quizId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ReviewListState state = ref.watch(reviewListControllerProvider);
    ReviewQuestionEntity? entry = _findEntry(state, questionId);

    if (entry == null && state.status == ReviewLoadStatus.initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(reviewListControllerProvider.notifier).load();
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed(AppRoutes.review);
            }
          },
        ),
        title: const Text(ReviewStrings.detailTitle),
      ),
      body: SafeArea(
        child: entry == null
            ? _NotFound(
                onRetry: () => ref
                    .read(reviewListControllerProvider.notifier)
                    .load(),
              )
            : _DetailBody(entry: entry),
      ),
    );
  }

  ReviewQuestionEntity? _findEntry(ReviewListState state, String id) {
    for (final ReviewSessionEntity session in state.sessions) {
      if (quizId != null && quizId != session.quiz.id) continue;
      for (final ReviewQuestionEntity q in session.questions) {
        if (q.question.id == id) return q;
      }
    }
    if (quizId != null) {
      for (final ReviewSessionEntity session in state.sessions) {
        for (final ReviewQuestionEntity q in session.questions) {
          if (q.question.id == id) return q;
        }
      }
    }
    return null;
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({this.onRetry});

  final VoidCallback? onRetry;

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
              Icons.search_off_outlined,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'We could not find this attempt.',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'It may belong to a quiz you have not opened in Review yet.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(ReviewStrings.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.entry});

  final ReviewQuestionEntity entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final String correctAnswerText = entry.question.correctAnswerIds
        .map((String id) => _findAnswerText(entry, id))
        .join(', ');
    final String userAnswerText = entry.selectedAnswerIds.isEmpty
        ? ReviewStrings.skipped
        : entry.selectedAnswerIds
            .map((String id) => _findAnswerText(entry, id))
            .join(', ');

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
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
                    onTap: () => ref
                        .read(reviewBookmarkControllerProvider.notifier)
                        .toggle(entry.question.id),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                entry.question.prompt,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ReviewAnswerSection(
                answers: entry.question.answers,
                selectedAnswerIds: entry.selectedSet,
              ),
              const SizedBox(height: AppSpacing.md),
              _InfoRow(
                label: ReviewStrings.yourAnswer,
                value: userAnswerText,
                emphasize: entry.wasCorrect,
              ),
              const SizedBox(height: AppSpacing.xs),
              _InfoRow(
                label: ReviewStrings.correctAnswer,
                value: correctAnswerText,
                emphasize: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ReviewAiExplanationSection(
          questionId: entry.question.id,
          questionText: entry.question.prompt,
          userAnswer: userAnswerText,
          correctAnswer: correctAnswerText,
          cachedExplanation: entry.question.explanation,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.emphasize,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: emphasize
                ? const Color(0xFF1E5631)
                : theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

String _findAnswerText(ReviewQuestionEntity entry, String id) {
  for (final AnswerEntity a in entry.question.answers) {
    if (a.id == id) return a.text;
  }
  return '—';
}