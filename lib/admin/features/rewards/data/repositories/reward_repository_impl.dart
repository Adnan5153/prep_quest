import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/ulid.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../../domain/entities/reward_entity.dart';
import '../../domain/repositories/reward_repository.dart';

class RewardRepositoryImpl implements RewardRepository {
  RewardRepositoryImpl() {
    _seed();
  }

  final Map<String, RewardTable> _tables = <String, RewardTable>{};

  void _seed() {
    final DateTime now = DateTime.now();
    final RewardTable defaultLevels = RewardTable(
      id: 'rwd_default_levels',
      slug: 'default-levels',
      name: 'Default Level Rewards',
      rules: <RewardRule>[
        RewardRule(
          condition: RewardCondition.levelCompleted,
          outcome: const RewardOutcome(xp: 50, coins: 25, hearts: 1),
        ),
        RewardRule(
          condition: RewardCondition.firstAttempt,
          outcome: const RewardOutcome(xp: 25),
        ),
        RewardRule(
          condition: RewardCondition.perfectScore,
          outcome: const RewardOutcome(xp: 75, gems: 2),
        ),
      ],
      updatedAt: now.subtract(const Duration(days: 30)),
    );
    final RewardTable boss = RewardTable(
      id: 'rwd_boss',
      slug: 'boss-rewards',
      name: 'Boss Rewards',
      rules: <RewardRule>[
        RewardRule(
          condition: RewardCondition.bossDefeated,
          outcome: const RewardOutcome(xp: 250, coins: 120, gems: 10),
        ),
      ],
      updatedAt: now.subtract(const Duration(days: 30)),
    );
    final RewardTable streak = RewardTable(
      id: 'rwd_streak',
      slug: 'streak-rewards',
      name: 'Streak Rewards',
      rules: <RewardRule>[
        RewardRule(
          condition: RewardCondition.streakReached,
          outcome: const RewardOutcome(hearts: 2, gems: 1),
        ),
      ],
      updatedAt: now.subtract(const Duration(days: 12)),
    );
    _tables[defaultLevels.id] = defaultLevels;
    _tables[boss.id] = boss;
    _tables[streak.id] = streak;
  }

  @override
  Future<List<RewardTable>> listTables() async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    return _tables.values.toList();
  }

  @override
  Future<RewardTable> upsertTable(RewardTable table) async {
    final String id = table.id.isEmpty ? 'rwd_${Ulid.generate()}' : table.id;
    final RewardTable stored = table.copyWith(id: id, updatedAt: DateTime.now());
    _tables[id] = stored;
    return stored;
  }

  @override
  Future<void> deleteTable(String id) async {
    _tables.remove(id);
  }
}

final rewardRepositoryProvider = Provider<RewardRepository>((Ref ref) {
  return RewardRepositoryImpl();
});
