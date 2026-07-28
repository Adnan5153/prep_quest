import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../router.dart';
import '../constants/ai_tutor_strings.dart';
import '../providers/ai_tutor_provider.dart';
import '../widgets/ai_hub_action_card.dart';
import '../widgets/ai_response_section.dart';

/// Generates an explanation for a quiz question + the correct answer.
class AiExplainScreen extends ConsumerStatefulWidget {
  const AiExplainScreen({super.key});

  @override
  ConsumerState<AiExplainScreen> createState() => _AiExplainScreenState();
}

class _AiExplainScreenState extends ConsumerState<AiExplainScreen> {
  final TextEditingController _questionId = TextEditingController(text: 'q-1');
  final TextEditingController _question = TextEditingController(
    text:
        'Which tense is correct: "I have been studying since morning"?',
  );
  final TextEditingController _correct = TextEditingController(
    text: 'Present perfect continuous',
  );
  final TextEditingController _yours = TextEditingController();

  @override
  void dispose() {
    _questionId.dispose();
    _question.dispose();
    _correct.dispose();
    _yours.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AiResponseState state =
        ref.watch(aiResponseControllerProvider(AiResponseKind2.explanation));
    return Scaffold(
      appBar: CustomAppBar(
        title: AiTutorStrings.explanationTitle,
        subtitle: AiTutorStrings.explanationFieldCorrectAnswer,
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
                    controller: _questionId,
                    decoration: const InputDecoration(
                      labelText: 'Question ID',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _question,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: AiTutorStrings.explanationFieldQuestion,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _correct,
                    decoration: const InputDecoration(
                      labelText: AiTutorStrings.explanationFieldCorrectAnswer,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _yours,
                    decoration: const InputDecoration(
                      labelText: AiTutorStrings.explanationFieldYourAnswer,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: _generate,
                    icon: const Icon(Icons.menu_book_rounded),
                    label: const Text(AiTutorStrings.explanationGenerate),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: switch (state.status) {
                  AiTutorLoadStatus.idle ||
                  AiTutorLoadStatus.initial =>
                    Center(
                      child: AiTutorEmptyState(
                        title: 'No explanation yet',
                        subtitle:
                            'Type the question + correct answer to get a step-by-step walkthrough.',
                        icon: Icons.menu_book_rounded,
                      ),
                    ),
                  AiTutorLoadStatus.loading =>
                    const AiTutorResponseLoading(
                      message: AiTutorStrings.explanationLoading,
                    ),
                  AiTutorLoadStatus.error => AiTutorResponseError(
                      message: state.errorMessage,
                      onRetry: _generate,
                    ),
                  AiTutorLoadStatus.ready => AiTutorResponseSection(
                      response: state.response!,
                      onRegenerate: _generate,
                    ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generate() async {
    final String id = _questionId.text.trim();
    final String question = _question.text.trim();
    final String correct = _correct.text.trim();
    if (id.isEmpty || question.isEmpty || correct.isEmpty) return;
    await ref
        .read(aiResponseControllerProvider(AiResponseKind2.explanation)
            .notifier)
        .generateExplanation(
          questionId: id,
          questionText: question,
          correctAnswer: correct,
          userAnswer: _yours.text.trim().isEmpty ? null : _yours.text.trim(),
        );
  }
}