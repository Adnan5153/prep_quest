import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';

class QuizExplanationBody extends StatelessWidget {
  const QuizExplanationBody({
    super.key,
    required this.body,
    this.imageUrl,
  });

  final String body;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          body,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onTertiaryContainer,
          ),
        ),
        if (imageUrl != null && imageUrl!.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              height: 140,
              width: double.infinity,
              color: theme.colorScheme.surfaceContainerHighest,
              alignment: Alignment.center,
              child: const Icon(Icons.image_outlined),
            ),
          ),
        ],
      ],
    );
  }
}