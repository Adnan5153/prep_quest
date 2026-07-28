import 'package:flutter/material.dart';

import '../../constants/quiz_strings.dart';

class QuizExplanationHeader extends StatelessWidget {
  const QuizExplanationHeader({
    super.key,
    required this.title,
    required this.isAi,
  });

  final String title;
  final bool isAi;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Icon(
          isAi ? Icons.auto_awesome : Icons.lightbulb_outline,
          color: theme.colorScheme.onTertiaryContainer,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title.isEmpty ? QuizStrings.explanation : title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onTertiaryContainer,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (isAi)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'AI',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onTertiary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }
}