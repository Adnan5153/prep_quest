import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../constants/quiz_strings.dart';
import '../../../domain/entities/quiz_report_entity.dart';
import '../../providers/quiz_progress_provider.dart';

class QuizReportDialog extends ConsumerStatefulWidget {
  const QuizReportDialog({
    super.key,
    required this.questionId,
    required this.quizId,
    required this.onSubmitted,
  });

  final String questionId;
  final String quizId;
  final void Function(QuizReportEntity report) onSubmitted;

  static Future<void> show(
    BuildContext context, {
    required String questionId,
    required String quizId,
    required void Function(QuizReportEntity report) onSubmitted,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => QuizReportDialog(
        questionId: questionId,
        quizId: quizId,
        onSubmitted: onSubmitted,
      ),
    );
  }

  @override
  ConsumerState<QuizReportDialog> createState() => _QuizReportDialogState();
}

class _QuizReportDialogState extends ConsumerState<QuizReportDialog> {
  QuizReportReason _reason = QuizReportReason.incorrectAnswer;
  final TextEditingController _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              QuizStrings.reportQuestion,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<QuizReportReason>(
              initialValue: _reason,
              decoration: const InputDecoration(
                labelText: 'Reason',
                border: OutlineInputBorder(),
              ),
              items: QuizReportReason.values
                  .map(
                    (reason) => DropdownMenuItem<QuizReportReason>(
                      value: reason,
                      child: Text(_label(reason)),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _reason = value);
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _note,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Additional notes',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilledButton(
                  onPressed: _submit,
                  child: const Text('Submit report'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    await ref.read(quizProgressControllerProvider.notifier).reportQuestion(
      questionId: widget.questionId,
      quizId: widget.quizId,
      reason: _reason,
      note: _note.text,
    );
    widget.onSubmitted(
      QuizReportEntity(
        id: 'local-${DateTime.now().microsecondsSinceEpoch}',
        questionId: widget.questionId,
        quizId: widget.quizId,
        reason: _reason,
        note: _note.text,
        createdAt: DateTime.now(),
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(QuizStrings.reportSentBody),
      ),
    );
  }

  String _label(QuizReportReason reason) {
    switch (reason) {
      case QuizReportReason.incorrectAnswer:
        return 'Incorrect answer key';
      case QuizReportReason.unclearQuestion:
        return 'Unclear question';
      case QuizReportReason.typo:
        return 'Typo or grammar issue';
      case QuizReportReason.duplicateQuestion:
        return 'Duplicate question';
      case QuizReportReason.inappropriateContent:
        return 'Inappropriate content';
      case QuizReportReason.other:
        return 'Other';
    }
  }
}