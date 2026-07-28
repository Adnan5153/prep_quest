import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';

/// Lazy-loads the question image with a graceful fallback when the
/// network image is unavailable.
class QuizQuestionImage extends StatelessWidget {
  const QuizQuestionImage({
    super.key,
    required this.imageUrl,
    this.caption,
    this.height = 180,
  });

  final String imageUrl;
  final String? caption;
  final double height;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            height: height,
            width: double.infinity,
            color: theme.colorScheme.surfaceContainerHighest,
            alignment: Alignment.center,
            child: const Icon(Icons.image_outlined, size: 32),
          ),
        ),
        if (caption != null && caption!.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.xs),
          Text(
            caption!,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}