import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../constants/quiz_strings.dart';
import 'quiz_explanation_body.dart';
import 'quiz_explanation_header.dart';

class QuizExplanationCard extends StatelessWidget {
  const QuizExplanationCard({
    super.key,
    required this.title,
    required this.body,
    this.imageUrl,
    this.isAi = false,
  });

  final String title;
  final String body;
  final String? imageUrl;
  final bool isAi;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          QuizExplanationHeader(title: title, isAi: isAi),
          const SizedBox(height: AppSpacing.md),
          QuizExplanationBody(body: body, imageUrl: imageUrl),
          if (body.isEmpty)
            Text(
              QuizStrings.noExplanation,
              style: theme.textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }
}