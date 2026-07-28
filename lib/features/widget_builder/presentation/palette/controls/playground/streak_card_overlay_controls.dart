import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class StreakCardOverlayControls extends StatelessWidget {
  const StreakCardOverlayControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.xl),
        Text('Streak Card Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text('Days ${provider.playgroundStreakCardDays}'),
        Slider(
          min: 0,
          max: 365,
          divisions: 365,
          value: provider.playgroundStreakCardDays.toDouble().clamp(0, 365),
          onChanged: (value) =>
              provider.playgroundStreakCardDays = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('At Risk'),
          value: provider.playgroundStreakCardIsAtRisk,
          onChanged: (value) => provider.playgroundStreakCardIsAtRisk = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Milestone Reached'),
          value: provider.playgroundStreakCardMilestoneReached,
          onChanged: (value) =>
              provider.playgroundStreakCardMilestoneReached = value,
        ),
      ],
    );
  }
}
