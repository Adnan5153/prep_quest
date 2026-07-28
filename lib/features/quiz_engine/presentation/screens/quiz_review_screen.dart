import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/entities/quiz_session_entity.dart';
import '../constants/quiz_strings.dart';
import '../extensions/quiz_session_extensions.dart';
import '../providers/quiz_providers.dart';
import '../providers/quiz_session_provider.dart';
import '../widgets/quiz_explanation/quiz_explanation_card.dart';
import '../widgets/quiz_review/quiz_review_answer_tile.dart';

class QuizReviewScreen extends ConsumerWidget {
  const QuizReviewScreen({super.key, required this.quizId});

  final String quizId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final QuizDetailState detail =
        ref.watch(quizDetailControllerProvider(quizId));
    final QuizSessionEntity session =
        ref.watch(quizSessionControllerProvider(quizId));

    return Scaffold(
      appBar: AppBar(
        title: Text(QuizStrings.reviewTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(
            AppRoutes.quizPlay,
            queryParameters: <String, String>{'quizId': quizId},
          ),
        ),
      ),
      body: SafeArea(
        child: switch (detail.status) {
          QuizLoadStatus.initial ||
          QuizLoadStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          QuizLoadStatus.error => Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: Text(detail.errorMessage ?? 'Could not load review'),
              ),
            ),
          QuizLoadStatus.ready => ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: detail.quiz!.questions.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (BuildContext context, int index) {
                final QuestionEntity question =
                    detail.quiz!.questions[index];
                final Set<String> selected = session
                    .progressFor(question.id)
                    ?.selectedAnswerIds
                    .toSet() ?? <String>{};
                return _ReviewQuestionCard(
                  question: question,
                  index: index,
                  selected: selected,
                );
              },
            ),
        },
      ),
    );
  }
}

class _ReviewQuestionCard extends StatelessWidget {
  const _ReviewQuestionCard({
    required this.question,
    required this.index,
    required this.selected,
  });

  final QuestionEntity question;
  final int index;
  final Set<String> selected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool hasAnswered = selected.isNotEmpty;
    final bool isCorrect = hasAnswered && question.isCorrect(selected);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? const Color(0xFFE6F6EA)
                      : (hasAnswered
                          ? const Color(0xFFFDECEA)
                          : theme.colorScheme.surfaceContainerHighest),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  isCorrect
                      ? 'Correct'
                      : (hasAnswered ? 'Incorrect' : 'Skipped'),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isCorrect
                        ? const Color(0xFF1E5631)
                        : (hasAnswered
                            ? const Color(0xFF8B1A1A)
                            : theme.colorScheme.onSurface),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Question ${index + 1}',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            question.prompt,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...question.answers.map(
            (answer) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: QuizReviewAnswerTile(
                answer: answer,
                isSelected: selected.contains(answer.id),
                isCorrect: answer.isCorrect,
              ),
            ),
          ),
          if (question.explanation != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            QuizExplanationCard(
              title: QuizStrings.explanation,
              body: question.explanation!,
            ),
          ],
        ],
      ),
    );
  }
}