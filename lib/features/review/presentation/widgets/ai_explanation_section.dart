import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/ai/ai_explanation_card.dart';
import '../../../../core/widgets/ai/ai_explanation_constants.dart';
import '../../../../core/widgets/ai/loading/ai_loading_section.dart';
import '../../../quiz_engine/presentation/constants/quiz_strings.dart';
import '../constants/review_strings.dart';
import '../providers/review_provider.dart';

/// Inline AI explanation block for the Review detail screen.
///
/// Renders a CTA when no explanation is loaded yet, an [AiLoadingSection]
/// while the use case is fetching, an [AiExplanationCard] when ready, or
/// a friendly retry hint on error.
class ReviewAiExplanationSection extends ConsumerWidget {
  const ReviewAiExplanationSection({
    super.key,
    required this.questionId,
    required this.questionText,
    required this.userAnswer,
    required this.correctAnswer,
    this.cachedExplanation,
  });

  final String questionId;
  final String questionText;
  final String userAnswer;
  final String correctAnswer;
  final String? cachedExplanation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AiExplanationState state = ref.watch(
      aiExplanationControllerProvider(questionId),
    );
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
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
              Icon(
                Icons.auto_awesome_rounded,
                size: 22,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                ReviewStrings.aiExplanationTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          switch (state.status) {
            ReviewAiLoadStatus.idle => _IdleCta(
                questionId: questionId,
                cachedExplanation: cachedExplanation,
              ),
            ReviewAiLoadStatus.loading => const AiLoadingSection(
                itemCount: 3,
                showAvatar: false,
                showSubtitle: false,
              ),
            ReviewAiLoadStatus.ready => _ReadyContent(
                explanation: state.explanation ?? cachedExplanation ?? '',
              ),
            ReviewAiLoadStatus.error => _ErrorCta(
                questionId: questionId,
                message: state.errorMessage,
              ),
          },
        ],
      ),
    );
  }
}

class _IdleCta extends ConsumerWidget {
  const _IdleCta({required this.questionId, required this.cachedExplanation});

  final String questionId;
  final String? cachedExplanation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Tap below to ask the AI tutor to walk through this question, '
          'compare your answer to the correct one, and surface a memory '
          'trick you can use during the BCS exam.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          children: <Widget>[
            FilledButton.icon(
              onPressed: () => ref
                  .read(aiExplanationControllerProvider(questionId).notifier)
                  .load(questionId),
              icon: const Icon(Icons.auto_awesome_outlined, size: 18),
              label: const Text(ReviewStrings.aiExplanationCta),
            ),
            if (cachedExplanation != null && cachedExplanation!.isNotEmpty)
              OutlinedButton.icon(
                onPressed: () => ref
                    .read(aiExplanationControllerProvider(questionId).notifier)
                    .load(questionId),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Refresh'),
              ),
          ],
        ),
      ],
    );
  }
}

class _ReadyContent extends StatelessWidget {
  const _ReadyContent({required this.explanation});

  final String explanation;

  @override
  Widget build(BuildContext context) {
    if (explanation.isEmpty) {
      return Text(
        QuizStrings.noExplanation,
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }
    return AiExplanationCard(
      title: 'Personalised walk-through',
      badgeLabel: 'AI INSIGHT',
      tone: AiExplanationTone.insight,
      sections: <AiExplanationSection>[
        AiExplanationTextSection(explanation),
        const AiExplanationTipSection(
          body: 'Repeat the question out loud and recall the rule in your '
              'own words — spaced repetition will lock the concept in '
              'within 48 hours.',
        ),
      ],
      canExpand: true,
      collapsedMaxLines: 6,
    );
  }
}

class _ErrorCta extends ConsumerWidget {
  const _ErrorCta({required this.questionId, required this.message});

  final String questionId;
  final String? message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          message ?? ReviewStrings.aiExplanationError,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        FilledButton.icon(
          onPressed: () => ref
              .read(aiExplanationControllerProvider(questionId).notifier)
              .load(questionId),
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text(ReviewStrings.retry),
        ),
      ],
    );
  }
}