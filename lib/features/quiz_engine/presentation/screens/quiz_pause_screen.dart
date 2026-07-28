import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../constants/quiz_strings.dart';
import '../providers/quiz_session_provider.dart';

class QuizPauseScreen extends ConsumerWidget {
  const QuizPauseScreen({super.key, required this.quizId});

  final String quizId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(QuizStrings.pauseTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 96,
                  height: 96,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.pause_circle_filled,
                    size: 56,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  QuizStrings.pauseTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Take a breath. Your progress is preserved.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: Text(QuizStrings.resumeQuiz),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  icon: const Icon(Icons.list_alt),
                  label: const Text('Review answers so far'),
                  onPressed: () => context.goNamed(
                    AppRoutes.quizReview,
                    queryParameters: <String, String>{'quizId': quizId},
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () async {
                    ref
                        .read(quizSessionControllerProvider(quizId).notifier)
                        .abandon();
                    if (context.mounted) {
                      Navigator.of(context).pop(false);
                      context.goNamed(AppRoutes.playground);
                    }
                  },
                  child: const Text(QuizStrings.exitQuiz),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}