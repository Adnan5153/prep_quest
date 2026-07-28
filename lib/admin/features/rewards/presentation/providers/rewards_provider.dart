import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/reward_repository_impl.dart';
import '../../domain/entities/reward_entity.dart';

class RewardSummary {
  const RewardSummary({required this.id, required this.name});

  final String id;
  final String name;
}

final rewardsListProvider = FutureProvider<List<RewardSummary>>((Ref ref) async {
  final List<RewardTable> tables =
      await ref.watch(rewardRepositoryProvider).listTables();
  return tables
      .map((RewardTable t) => RewardSummary(id: t.id, name: t.name))
      .toList();
});

final rewardsDetailProvider =
    FutureProvider.family<RewardTable, String>((Ref ref, String id) async {
  final List<RewardTable> tables =
      await ref.watch(rewardRepositoryProvider).listTables();
  return tables.firstWhere((RewardTable t) => t.id == id);
});

class RewardsController {
  const RewardsController(this.ref);

  final Ref ref;

  Future<void> upsertRule({
    required String tableId,
    required RewardRule rule,
  }) async {
    final List<RewardTable> tables =
        await ref.read(rewardRepositoryProvider).listTables();
    final RewardTable table = tables.firstWhere(
      (RewardTable t) => t.id == tableId,
      orElse: () => throw StateError('Table $tableId not found'),
    );
    final List<RewardRule> next = <RewardRule>[...table.rules, rule];
    await ref.read(rewardRepositoryProvider).upsertTable(
          table.copyWith(rules: next, updatedAt: DateTime.now()),
        );
    ref.invalidate(rewardsListProvider);
    ref.invalidate(rewardsDetailProvider(tableId));
  }
}

final rewardsControllerProvider =
    Provider<RewardsController>((Ref ref) => RewardsController(ref));
