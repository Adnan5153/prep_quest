import 'package:flutter/material.dart';

import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../../domain/entities/user_profile.dart';
import '../../constants/profile_strings.dart';

/// Grid of study-stat tiles (questions, quizzes, accuracy, study time).
class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<_StatEntry> entries = <_StatEntry>[
      _StatEntry(
        icon: Icons.quiz_rounded,
        label: ProfileStrings.quizzesLabel,
        value: '${profile.studyStats.totalQuizzesTaken}',
        accent: theme.colorScheme.primary,
      ),
      _StatEntry(
        icon: Icons.help_outline_rounded,
        label: ProfileStrings.questionsLabel,
        value: '${profile.studyStats.totalQuestionsAnswered}',
        accent: theme.colorScheme.secondary,
      ),
      _StatEntry(
        icon: Icons.check_circle_rounded,
        label: ProfileStrings.correctLabel,
        value: '${profile.studyStats.totalCorrectAnswers}',
        accent: theme.colorScheme.tertiary,
      ),
      _StatEntry(
        icon: Icons.percent_rounded,
        label: ProfileStrings.accuracyLabel,
        value: '${(profile.studyStats.averageAccuracy * 100).round()}%',
        accent: theme.colorScheme.primary,
      ),
      _StatEntry(
        icon: AppIcons.clock,
        label: ProfileStrings.studyTimeLabel,
        value: _formatStudyMinutes(profile.studyStats.totalStudyMinutes),
        accent: theme.colorScheme.secondary,
      ),
      _StatEntry(
        icon: AppIcons.fireFilled,
        label: ProfileStrings.longestStreakLabel,
        value: '${profile.studyStats.longestStreakDays}d',
        accent: theme.colorScheme.tertiary,
      ),
    ];

    final int crossAxisCount = ResponsiveBuilder.value<int>(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 3,
    );

    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            ProfileStrings.statsSectionTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.6,
            ),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) =>
                _StatTile(entry: entries[index]),
          ),
        ],
      ),
    );
  }

  static String _formatStudyMinutes(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final int hours = minutes ~/ 60;
    final int mins = minutes % 60;
    if (mins == 0) return '${hours}h';
    return '${hours}h ${mins}m';
  }
}

class _StatEntry {
  const _StatEntry({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.entry});

  final _StatEntry entry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: entry.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: entry.accent.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(entry.icon, color: entry.accent, size: AppSizes.iconMd),
          const SizedBox(height: AppSpacing.xs),
          Text(
            entry.value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            entry.label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}