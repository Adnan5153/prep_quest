import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/streak_card.dart';
import '../../../providers/widget_builder_provider.dart';

class StreakCardPreview extends StatelessWidget {
  const StreakCardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: SizedBox(
          width: 400,
          child: StreakCard(
            currentStreak: provider.currentStreakValue,
            longestStreak: provider.longestStreakValue,
            progress: provider.streakProgressValue,
            showWeeklyProgress: provider.showWeeklyStreak,
            showReward: provider.showStreakReward,
            showMilestone: provider.showStreakMilestone,
            showFireAnimation: provider.enableStreakAnimation,
            rewardText: 'You earned 50 extra points today!',
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
