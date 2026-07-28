import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/secondary_button.dart';
import '../../../../../router.dart';
import '../../constants/quiz_results_strings.dart';
import '../../providers/quiz_results_provider.dart';

/// Footer action group: Retry, Review, Continue Learning, Share.
class ResultFooter extends ConsumerWidget {
  const ResultFooter({super.key, required this.quizId});

  final String quizId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        PrimaryButton(
          text: QuizResultsStrings.retryAction,
          icon: Icons.replay,
          onPressed: () async {
            await ref
                .read(quizResultsControllerProvider(quizId).notifier)
                .retry(quizId);
            if (context.mounted) {
              context.goNamed(
                AppRoutes.quizPlay,
                queryParameters: <String, String>{'quizId': quizId},
              );
            }
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SecondaryButton(
          text: QuizResultsStrings.reviewAction,
          icon: Icons.list_alt,
          onPressed: () => context.goNamed(
            AppRoutes.quizReview,
            queryParameters: <String, String>{'quizId': quizId},
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SecondaryButton(
          text: QuizResultsStrings.continueLearningAction,
          icon: Icons.school,
          onPressed: () => context.goNamed(AppRoutes.playground),
        ),
        const SizedBox(height: AppSpacing.md),
        SecondaryButton(
          text: QuizResultsStrings.shareAction,
          icon: Icons.share,
          onPressed: () => _showShareDialog(context, ref),
        ),
      ],
    );
  }

  void _showShareDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(QuizResultsStrings.shareAction),
        content: Text(
          'Share your result for $quizId',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
