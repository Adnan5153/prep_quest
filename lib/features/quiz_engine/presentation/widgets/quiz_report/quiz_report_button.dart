import 'package:flutter/material.dart';

import '../../constants/quiz_strings.dart';
import '../../../domain/entities/quiz_report_entity.dart';
import 'quiz_report_dialog.dart';

class QuizReportButton extends StatelessWidget {
  const QuizReportButton({
    super.key,
    required this.questionId,
    required this.quizId,
    required this.onSubmitted,
  });

  final String questionId;
  final String quizId;
  final void Function(QuizReportEntity report) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => QuizReportDialog.show(
        context,
        questionId: questionId,
        quizId: quizId,
        onSubmitted: onSubmitted,
      ),
      icon: const Icon(Icons.report_outlined),
      label: const Text(QuizStrings.reportQuestion),
    );
  }
}