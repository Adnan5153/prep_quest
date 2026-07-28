import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../router.dart';
import '../../domain/entities/generated_question.dart';
import '../constants/ai_tutor_strings.dart';
import '../extensions/ai_tutor_extensions.dart';
import '../providers/ai_tutor_provider.dart';
import '../widgets/ai_hub_action_card.dart';
import '../widgets/ai_response_section.dart';
import '../widgets/generated_question_card.dart';

/// Generates and displays a fresh set of practice questions on a
/// chosen topic.
class AiQuestionsScreen extends ConsumerStatefulWidget {
  const AiQuestionsScreen({super.key});

  @override
  ConsumerState<AiQuestionsScreen> createState() =>
      _AiQuestionsScreenState();
}

class _AiQuestionsScreenState extends ConsumerState<AiQuestionsScreen> {
  final TextEditingController _topic = TextEditingController(text: 'Percentages');
  int _count = 6;
  GeneratedQuestionDifficulty _difficulty = GeneratedQuestionDifficulty.medium;

  @override
  void dispose() {
    _topic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AiContentState state =
        ref.watch(aiContentControllerProvider(AiContentKind.questions));

    return Scaffold(
      appBar: CustomAppBar(
        title: AiTutorStrings.questionsTitle,
        subtitle: AiTutorStrings.questionsFieldTopic,
        onLeadingPressed: () => context.canPop()
            ? context.pop()
            : context.goNamed(AppRoutes.aiTutor),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    controller: _topic,
                    decoration: const InputDecoration(
                      labelText: AiTutorStrings.questionsFieldTopic,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _CountStepper(
                          value: _count,
                          min: 4,
                          max: 12,
                          step: 1,
                          onChanged: (int v) => setState(() => _count = v),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: DropdownButtonFormField<
                            GeneratedQuestionDifficulty>(
                          initialValue: _difficulty,
                          decoration: const InputDecoration(
                            labelText:
                                AiTutorStrings.questionsFieldDifficulty,
                          ),
                          items: GeneratedQuestionDifficulty.values
                              .map(
                                (GeneratedQuestionDifficulty d) =>
                                    DropdownMenuItem<
                                        GeneratedQuestionDifficulty>(
                                  value: d,
                                  child: Text(d.label),
                                ),
                              )
                              .toList(),
                          onChanged: (GeneratedQuestionDifficulty? v) {
                            if (v != null) {
                              setState(() => _difficulty = v);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: _generate,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text(AiTutorStrings.questionsGenerate),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: switch (state.status) {
                AiTutorLoadStatus.idle ||
                AiTutorLoadStatus.initial =>
                  Center(
                    child: AiTutorEmptyState(
                      title: AiTutorStrings.questionsEmptyTitle,
                      subtitle: AiTutorStrings.questionsEmptySubtitle,
                      icon: Icons.quiz_outlined,
                    ),
                  ),
                AiTutorLoadStatus.loading =>
                  const AiTutorResponseLoading(
                    message: AiTutorStrings.questionsLoading,
                  ),
                AiTutorLoadStatus.error => AiTutorResponseError(
                    message: state.errorMessage,
                    onRetry: _generate,
                  ),
                AiTutorLoadStatus.ready => _QuestionList(
                    set: state.questions!,
                    theme: theme,
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generate() async {
    final String topic = _topic.text.trim();
    if (topic.isEmpty) return;
    await ref
        .read(aiContentControllerProvider(AiContentKind.questions).notifier)
        .generateQuestions(
          topic: topic,
          count: _count,
          difficulty: _difficulty,
        );
  }
}

class _QuestionList extends StatelessWidget {
  const _QuestionList({required this.set, required this.theme});

  final GeneratedQuestionSet set;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: <Widget>[
        Text(
          set.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          '${set.questionCount} questions • ${set.subject}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final GeneratedQuestion q in set.questions)
          GeneratedQuestionCard(question: q),
      ],
    );
  }
}

class _CountStepper extends StatelessWidget {
  const _CountStepper({
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.onChanged,
  });

  final int value;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: value <= min ? null : () => onChanged(value - step),
            icon: const Icon(Icons.remove_rounded),
            iconSize: 18,
          ),
          Expanded(
            child: Center(
              child: Text(
                '$value q',
                style: theme.textTheme.titleSmall,
              ),
            ),
          ),
          IconButton(
            onPressed: value >= max ? null : () => onChanged(value + step),
            icon: const Icon(Icons.add_rounded),
            iconSize: 18,
          ),
        ],
      ),
    );
  }
}