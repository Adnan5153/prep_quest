import '../../domain/entities/reward.dart';
import '../models/badge_entry_model.dart';
import '../models/chest_entry_model.dart';
import '../models/level_progress_model.dart';
import '../models/reward_history_entry_model.dart';
import '../models/streak_state_model.dart';
import '../models/user_rewards_state_model.dart';

/// In-memory source of truth for the user's rewards snapshot.
///
/// The current production app has no backend for gamification, so
/// every repository call resolves through a deterministic seeded
/// snapshot. A future network-backed datasource will implement the
/// same surface; no consumer code needs to change.
class RewardsLocalDataSource {
  RewardsLocalDataSource({DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;

  UserRewardsStateModel? _state;

  UserRewardsStateModel _seed() {
    final DateTime now = _clock();
    return UserRewardsStateModel(
      totalXP: 320,
      totalCoins: 180,
      level: const LevelProgressModel(
        currentLevel: 4,
        currentXP: 20,
        nextLevelXP: 100,
      ),
      streak: StreakStateModel(
        currentDays: 3,
        bestDays: 7,
        lastClaimedAtIso: now.subtract(const Duration(days: 1)).toIso8601String(),
        shieldCharges: 1,
        statusId: 'claimable',
      ),
      badges: const <BadgeEntryModel>[
        BadgeEntryModel(
          id: 'lesson_finisher',
          title: 'Lesson Finisher',
          description: 'Read a lesson end to end.',
          iconKey: 'book',
          rarityId: 'common',
          earnedAtIso: '2025-09-12T08:32:00Z',
          category: 'lesson',
          isFavorite: true,
        ),
        BadgeEntryModel(
          id: 'quiz_first_blood',
          title: 'First Blood',
          description: 'Win your first quiz.',
          iconKey: 'sword',
          rarityId: 'common',
          earnedAtIso: '2025-09-14T18:10:00Z',
          category: 'quiz',
        ),
        BadgeEntryModel(
          id: 'mission_master',
          title: 'Mission Master',
          description: 'Complete a daily mission.',
          iconKey: 'flag',
          rarityId: 'rare',
          earnedAtIso: '2025-09-19T10:02:00Z',
          category: 'mission',
        ),
      ],
      chests: const <ChestEntryModel>[
        ChestEntryModel(
          id: 'chest-welcome-1',
          title: 'Starter chest',
          rarityId: 'common',
          statusId: 'locked',
          previewRewardIds: <String>['xp', 'coins'],
          acquiredAtIso: '2025-09-10T08:00:00Z',
        ),
        ChestEntryModel(
          id: 'chest-first-clear-1',
          title: 'Level-clear chest',
          rarityId: 'rare',
          statusId: 'locked',
          previewRewardIds: <String>['xp', 'badge:level_clearer'],
          acquiredAtIso: '2025-09-18T12:00:00Z',
        ),
      ],
      history: const <RewardHistoryEntryModel>[
        RewardHistoryEntryModel(
          id: 'history-seed-1',
          grantedAtIso: '2025-09-19T10:02:00Z',
          sourceLabel: 'Mission completed',
          grantDump: <Reward>[],
          contextKey: 'mission:3-day-streak',
        ),
        RewardHistoryEntryModel(
          id: 'history-seed-2',
          grantedAtIso: '2025-09-14T18:10:00Z',
          sourceLabel: 'Daily reward (Day 5)',
          grantDump: <Reward>[],
          contextKey: 'daily:5',
        ),
        RewardHistoryEntryModel(
          id: 'history-seed-3',
          grantedAtIso: '2025-09-12T08:32:00Z',
          sourceLabel: 'Lesson completed',
          grantDump: <Reward>[],
          contextKey: 'lesson:tense-1',
        ),
      ],
      favoriteBadgeIds: const <String>{'lesson_finisher'},
    );
  }

  UserRewardsStateModel read() => _state ??= _seed();

  void write(UserRewardsStateModel next) {
    _state = next;
  }

  DateTime now() => _clock();
}