import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../features/leaderboard/domain/entities/leaderboard_category_entity.dart';
import '../../../../../../features/leaderboard/domain/entities/leaderboard_entry_entity.dart';
import '../../../../../../features/leaderboard/domain/enums/leaderboard_enums.dart';
import '../../../../../../features/leaderboard/presentation/constants/leaderboard_strings.dart' as strings;
import '../../../../../../features/leaderboard/presentation/widgets/leaderboard_avatar/leaderboard_avatar.dart';
import '../../../../../../features/leaderboard/presentation/widgets/leaderboard_card/leaderboard_card.dart';
import '../../../../../../features/leaderboard/presentation/widgets/leaderboard_current_user_card/leaderboard_current_user_card.dart';
import '../../../../../../features/leaderboard/presentation/widgets/leaderboard_empty_state/leaderboard_empty_state.dart';
import '../../../../../../features/leaderboard/presentation/widgets/leaderboard_error_state/leaderboard_error_state.dart';
import '../../../../../../features/leaderboard/presentation/widgets/leaderboard_loading_state/leaderboard_loading_state.dart';
import '../../../../../../features/leaderboard/presentation/widgets/leaderboard_podium/leaderboard_podium.dart';
import '../../../../../../features/leaderboard/presentation/widgets/leaderboard_progress_indicator/leaderboard_progress_indicator.dart';
import '../../../../../../features/leaderboard/presentation/widgets/leaderboard_rank_badge/leaderboard_rank_badge.dart';
import '../../../../../../features/leaderboard/presentation/widgets/leaderboard_rank_tile/leaderboard_rank_tile.dart';
import '../../../providers/widget_builder_provider.dart';

/// Composite preview that adapts to whichever leaderboard widget is
/// selected by the widget-builder palette.
class LeaderboardPreview extends StatelessWidget {
  const LeaderboardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LeaderboardRankBadge(
              entry: _sampleEntry(rank: 1),
            ),
            const SizedBox(height: AppSpacing.md),
            LeaderboardAvatar(entry: _sampleEntry(rank: 1)),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: 360,
              child: LeaderboardRankTile(entry: _sampleEntry(rank: 7)),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: 360,
              height: 220,
              child: LeaderboardPodium(entries: _podiumEntries()),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: 360,
              child: LeaderboardCard(category: _sampleCategory()),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: 360,
              child: LeaderboardCurrentUserCard(
                entry: _sampleEntry(rank: 7),
                aboveXp: 120,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: 360,
              child: LeaderboardProgressIndicator(
                fraction: 0.6,
                xpToNextRank: 320,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const LeaderboardEmptyState(),
            const SizedBox(height: AppSpacing.md),
            const LeaderboardErrorState(message: 'Network unreachable'),
            const SizedBox(height: AppSpacing.md),
            const SizedBox(
              width: 360,
              child: LeaderboardLoadingState(),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              strings.LeaderboardStrings.hubTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// Renders a small variant preview focused on a single widget.
class LeaderboardFocusedPreview extends StatelessWidget {
  const LeaderboardFocusedPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(child: _buildFor(provider.selection)),
    );
  }

  Widget _buildFor(WidgetBuilderSelection selection) {
    switch (selection) {
      case WidgetBuilderSelection.leaderboardPodium:
        return SizedBox(
          width: 360,
          height: 220,
          child: LeaderboardPodium(entries: _podiumEntries()),
        );
      case WidgetBuilderSelection.leaderboardRankTile:
        return SizedBox(
          width: 360,
          child: LeaderboardRankTile(entry: _sampleEntry(rank: 7)),
        );
      case WidgetBuilderSelection.leaderboardCard:
        return SizedBox(
          width: 360,
          child: LeaderboardCard(category: _sampleCategory()),
        );
      case WidgetBuilderSelection.leaderboardAvatar:
        return LeaderboardAvatar(entry: _sampleEntry(rank: 1));
      case WidgetBuilderSelection.leaderboardHeader:
        return const SizedBox.shrink();
      case WidgetBuilderSelection.leaderboardFilterTabs:
        return const SizedBox.shrink();
      case WidgetBuilderSelection.leaderboardCurrentUserCard:
        return SizedBox(
          width: 360,
          child: LeaderboardCurrentUserCard(
            entry: _sampleEntry(rank: 7),
            aboveXp: 120,
          ),
        );
      case WidgetBuilderSelection.leaderboardEmptyState:
        return const LeaderboardEmptyState();
      case WidgetBuilderSelection.leaderboardLoadingState:
        return const SizedBox(
          width: 360,
          child: LeaderboardLoadingState(),
        );
      case WidgetBuilderSelection.leaderboardErrorState:
        return const LeaderboardErrorState(message: 'Network unreachable');
      case WidgetBuilderSelection.leaderboardStatisticsCard:
        return const SizedBox.shrink();
      case WidgetBuilderSelection.leaderboardRankBadge:
        return LeaderboardRankBadge(entry: _sampleEntry(rank: 2));
      case WidgetBuilderSelection.leaderboardProgressIndicator:
        return SizedBox(
          width: 360,
          child: LeaderboardProgressIndicator(
            fraction: 0.45,
            xpToNextRank: 280,
          ),
        );
      case WidgetBuilderSelection.leaderboardSearchBar:
        return const SizedBox.shrink();
      case WidgetBuilderSelection.leaderboardSortSheet:
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }
}

// ---------------------------------------------------------------------------
// Sample fixtures
// ---------------------------------------------------------------------------

LeaderboardEntryEntity _sampleEntry({required int rank}) {
  return LeaderboardEntryEntity(
    userId: 'u_demo_$rank',
    rank: rank,
    previousRank: rank + 1,
    username: 'Demo User',
    university: 'Dhaka University',
    avatarUrl: '',
    level: 12,
    xp: 8640,
    coins: 3810,
    streakDays: 4,
    badges: const <String>['streak_legend'],
    isCurrentUser: rank == 7,
    isPremium: rank == 1,
  );
}

List<LeaderboardEntryEntity> _podiumEntries() {
  return <LeaderboardEntryEntity>[
    LeaderboardEntryEntity(
      userId: 'u_1',
      rank: 1,
      previousRank: 1,
      username: 'Tahmid Ahmed',
      university: 'Dhaka University',
      avatarUrl: '',
      level: 24,
      xp: 18450,
      coins: 9820,
      streakDays: 32,
      badges: const <String>['quiz_master'],
      isCurrentUser: false,
      isPremium: true,
    ),
    LeaderboardEntryEntity(
      userId: 'u_2',
      rank: 2,
      previousRank: 3,
      username: 'Nazia Haque',
      university: 'BUET',
      avatarUrl: '',
      level: 21,
      xp: 16220,
      coins: 8400,
      streakDays: 18,
      badges: const <String>['quiz_master'],
      isCurrentUser: false,
      isPremium: false,
    ),
    LeaderboardEntryEntity(
      userId: 'u_3',
      rank: 3,
      previousRank: 2,
      username: 'Sabbir Rahman',
      university: 'Chittagong University',
      avatarUrl: '',
      level: 19,
      xp: 14310,
      coins: 7710,
      streakDays: 12,
      badges: const <String>['streak_legend'],
      isCurrentUser: false,
      isPremium: true,
    ),
  ];
}

LeaderboardCategoryEntity _sampleCategory() {
  return LeaderboardCategoryEntity(
    scope: LeaderboardScope.friends,
    title: 'Friends',
    subtitle: 'Compare with the people you study with.',
    entries: <LeaderboardEntryEntity>[
      _sampleEntry(rank: 1),
      _sampleEntry(rank: 2),
      _sampleEntry(rank: 3),
    ],
    totalParticipants: 124,
    lastUpdatedIso: DateTime.now().toIso8601String(),
  );
}
