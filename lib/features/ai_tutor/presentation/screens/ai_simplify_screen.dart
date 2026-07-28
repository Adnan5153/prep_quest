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

/// Asks the tutor to simplify a topic into plain English.
class AiSimplifyScreen extends ConsumerStatefulWidget {
  const AiSimplifyScreen({super.key});

  @override
  ConsumerState<AiSimplifyScreen> createState() => _AiSimplifyScreenState();
}

class _AiSimplifyScreenState extends ConsumerState<AiSimplifyScreen> {
  final TextEditingController _topic =
      TextEditingController(text: 'Supply and demand');
  final TextEditingController _grade = TextEditingController();

  @override
  void dispose() {
    _topic.dispose();
    _grade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AiResponseState state =
        ref.watch(aiResponseControllerProvider(AiResponseKind2.simplify));
    return Scaffold(
      appBar: CustomAppBar(
        title: AiTutorStrings.simplifyTitle,
        subtitle: AiTutorStrings.simplifyFieldTopic,
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
                      labelText: AiTutorStrings.simplifyFieldTopic,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _grade,
                    decoration: const InputDecoration(
                      labelText: AiTutorStrings.simplifyFieldGrade,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: _generate,
                    icon: const Icon(Icons.compress_rounded),
                    label: const Text(AiTutorStrings.simplifyGenerate),
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
                        title: 'No simplification yet',
                        subtitle:
                            'Type a topic and we will translate it into plain English.',
                        icon: Icons.compress_rounded,
                      ),
                    ),
                  AiTutorLoadStatus.loading =>
                    const AiTutorResponseLoading(
                      message: AiTutorStrings.simplifyLoading,
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
    final String topic = _topic.text.trim();
    if (topic.isEmpty) return;
    await ref
        .read(aiResponseControllerProvider(AiResponseKind2.simplify).notifier)
        .simplify(
          topic: topic,
          gradeLevel:
              _grade.text.trim().isEmpty ? null : _grade.text.trim(),
        );
  }
}