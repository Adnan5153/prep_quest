import 'package:flutter/foundation.dart';

import '../enums/reward_enums.dart';
import 'reward.dart';

/// A chest the user owns.
@immutable
class ChestEntry {
  const ChestEntry({
    required this.id,
    required this.title,
    required this.rarity,
    required this.status,
    required this.previewContents,
    required this.acquiredAtIso,
  });

  final String id;
  final String title;
  final RewardRarity rarity;
  final ChestStatus status;
  final List<Reward> previewContents;
  final String acquiredAtIso;

  ChestEntry copyWith({ChestStatus? status}) {
    return ChestEntry(
      id: id,
      title: title,
      rarity: rarity,
      status: status ?? this.status,
      previewContents: previewContents,
      acquiredAtIso: acquiredAtIso,
    );
  }
}