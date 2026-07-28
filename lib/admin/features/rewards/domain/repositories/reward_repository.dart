import '../entities/reward_entity.dart';

abstract class RewardRepository {
  Future<List<RewardTable>> listTables();
  Future<RewardTable> upsertTable(RewardTable table);
  Future<void> deleteTable(String id);
}
