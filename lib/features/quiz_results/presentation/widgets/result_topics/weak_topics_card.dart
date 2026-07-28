import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../../../router.dart';
import '../../utils/quiz_results_visual_mapper.dart';
import 'topic_breakdown_tile.dart';

/// Card listing the topics the player should review.
class WeakTopicsCard extends StatelessWidget {
  const WeakTopicsCard({super.key, required this.visual});

  final TopicBreakdownVisual visual;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (visual.items.isEmpty) {
      return const SizedBox.shrink();
    }
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                visual.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextButton(
                onPressed: () => context.goNamed(
                  AppRoutes.quizWeakTopics,
                  queryParameters: <String, String>{
                    'quizId': GoRouterState.of(context).uri.queryParameters['quizId'] ?? '',
                  },
                ),
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...visual.items.take(3).map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: TopicBreakdownTile(topic: t),
                ),
              ),
        ],
      ),
    );
  }
}
