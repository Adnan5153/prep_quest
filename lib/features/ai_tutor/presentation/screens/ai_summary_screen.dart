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

/// Generates a five-bullet recap for a chosen lesson.
class AiSummaryScreen extends ConsumerStatefulWidget {
  const AiSummaryScreen({super.key});

  @override
  ConsumerState<AiSummaryScreen> createState() => _AiSummaryScreenState();
}

class _AiSummaryScreenState extends ConsumerState<AiSummaryScreen> {
  final TextEditingController _lessonId = TextEditingController(text: 'lesson-tense-1');
  final TextEditingController _lessonTitle =
      TextEditingController(text: 'Tenses — full guide');

  @override
  void dispose() {
    _lessonId.dispose();
    _lessonTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AiResponseState state =
        ref.watch(aiResponseControllerProvider(AiResponseKind2.summary));

    return Scaffold(
      appBar: CustomAppBar(
        title: AiTutorStrings.summaryTitle,
        subtitle: AiTutorStrings.summaryFieldLessonTitle,
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
                    controller: _lessonId,
                    decoration: const InputDecoration(
                      labelText: AiTutorStrings.summaryFieldLessonId,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _lessonTitle,
                    decoration: const InputDecoration(
                      labelText: AiTutorStrings.summaryFieldLessonTitle,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: _generate,
                    icon: const Icon(Icons.summarize_rounded),
                    label: const Text(AiTutorStrings.summaryGenerate),
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
                        title: 'No summary yet',
                        subtitle:
                            'Enter a lesson ID and we will draft a 5-bullet recap.',
                        icon: Icons.summarize_rounded,
                      ),
                    ),
                  AiTutorLoadStatus.loading =>
                    const AiTutorResponseLoading(
                      message: AiTutorStrings.summaryLoading,
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
    final String id = _lessonId.text.trim();
    if (id.isEmpty) return;
    await ref
        .read(aiResponseControllerProvider(AiResponseKind2.summary).notifier)
        .summarise(
          lessonId: id,
          lessonTitle: _lessonTitle.text.trim().isEmpty
              ? null
              : _lessonTitle.text.trim(),
        );
  }
}