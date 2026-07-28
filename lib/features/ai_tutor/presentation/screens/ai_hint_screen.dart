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

/// Generates a single hint for a quiz question.
class AiHintScreen extends ConsumerStatefulWidget {
  const AiHintScreen({super.key, this.questionId});

  final String? questionId;

  @override
  ConsumerState<AiHintScreen> createState() => _AiHintScreenState();
}

class _AiHintScreenState extends ConsumerState<AiHintScreen> {
  final TextEditingController _questionId =
      TextEditingController(text: 'q-1');
  final TextEditingController _question = TextEditingController(
    text:
        'Choose the correct present perfect continuous form: "I ____ for two hours."',
  );
  final TextEditingController _userAnswer = TextEditingController();

  @override
  void dispose() {
    _questionId.dispose();
    _question.dispose();
    _userAnswer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String id = widget.questionId ?? _questionId.text.trim();
    final AiHintState state =
        ref.watch(aiHintControllerProvider(id.isEmpty ? 'q-1' : id));

    return Scaffold(
      appBar: CustomAppBar(
        title: AiTutorStrings.hintTitle,
        subtitle: AiTutorStrings.hintFieldQuestion,
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
                  if (widget.questionId == null)
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
                      labelText: AiTutorStrings.hintFieldQuestion,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _userAnswer,
                    decoration: const InputDecoration(
                      labelText: AiTutorStrings.hintFieldAnswer,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: _generate,
                    icon: const Icon(Icons.lightbulb_outline_rounded),
                    label: const Text(AiTutorStrings.hintGenerate),
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
                        title: AiTutorStrings.hintEmptyTitle,
                        subtitle: AiTutorStrings.hintEmptySubtitle,
                        icon: Icons.lightbulb_outline_rounded,
                      ),
                    ),
                  AiTutorLoadStatus.loading =>
                    const AiTutorResponseLoading(
                      message: AiTutorStrings.hintLoading,
                    ),
                  AiTutorLoadStatus.error => AiTutorResponseError(
                      message: state.errorMessage,
                      onRetry: _generate,
                    ),
                  AiTutorLoadStatus.ready => AiTutorResponseSection(
                      response: state.hint!,
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
    final String id = widget.questionId ?? _questionId.text.trim();
    if (id.isEmpty) return;
    final String question = _question.text.trim();
    if (question.isEmpty) return;
    await ref
        .read(aiHintControllerProvider(id).notifier)
        .generate(
          questionId: id,
          questionText: question,
          userAnswer: _userAnswer.text.trim().isEmpty
              ? null
              : _userAnswer.text.trim(),
        );
  }
}