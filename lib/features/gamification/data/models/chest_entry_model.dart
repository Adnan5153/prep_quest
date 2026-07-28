import '../../domain/entities/chest_entry.dart';
import '../../domain/entities/reward.dart';
import '../../domain/enums/reward_enums.dart';

class ChestEntryModel {
  const ChestEntryModel({
    required this.id,
    required this.title,
    required this.rarityId,
    required this.statusId,
    required this.previewRewardIds,
    required this.acquiredAtIso,
  });

  final String id;
  final String title;
  final String rarityId;
  final String statusId;
  final List<String> previewRewardIds;
  final String acquiredAtIso;

  ChestEntry toEntity({List<Reward> previewContents = const <Reward>[]}) {
    return ChestEntry(
      id: id,
      title: title,
      rarity: _rarityFromId(rarityId),
      status: _statusFromId(statusId),
      previewContents: previewContents,
      acquiredAtIso: acquiredAtIso,
    );
  }

  static RewardRarity _rarityFromId(String id) {
    for (final RewardRarity r in RewardRarity.values) {
      if (r.name == id) return r;
    }
    return RewardRarity.common;
  }

  static ChestStatus _statusFromId(String id) {
    for (final ChestStatus s in ChestStatus.values) {
      if (s.name == id) return s;
    }
    return ChestStatus.locked;
  }
}