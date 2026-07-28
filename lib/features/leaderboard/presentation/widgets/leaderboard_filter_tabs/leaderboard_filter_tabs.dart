import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/category_chip.dart';
import '../../../domain/enums/leaderboard_enums.dart';

/// Horizontal pill row used to switch between leaderboard scopes.
class LeaderboardFilterTabs extends StatelessWidget {
  const LeaderboardFilterTabs({
    super.key,
    required this.scopes,
    required this.active,
    required this.onChanged,
  });

  final List<LeaderboardScope> scopes;
  final LeaderboardScope active;
  final ValueChanged<LeaderboardScope> onChanged;

  String _label(LeaderboardScope scope) {
    switch (scope) {
      case LeaderboardScope.friends:
        return 'Friends';
      case LeaderboardScope.university:
        return 'University';
      case LeaderboardScope.national:
        return 'National';
      case LeaderboardScope.weekly:
        return 'Weekly';
      case LeaderboardScope.seasonal:
        return 'Seasonal';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: scopes.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (BuildContext context, int index) {
          final LeaderboardScope scope = scopes[index];
          return CategoryChip(
            label: _label(scope),
            selected: scope == active,
            onTap: () => onChanged(scope),
          );
        },
      ),
    );
  }
}