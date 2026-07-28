import 'package:flutter/foundation.dart';

import 'reward.dart';

/// A historical grant row (XP, coin, badge, …).
@immutable
class RewardHistoryEntry {
  const RewardHistoryEntry({
    required this.id,
    required this.grantedAtIso,
    required this.grants,
    required this.sourceLabel,
    this.contextKey,
  });

  final String id;
  final String grantedAtIso;
  final String sourceLabel;
  final String? contextKey;
  final List<Reward> grants;

  int get xpTotal => grants.whereType<XpReward>().fold<int>(
        0,
        (int sum, XpReward r) => sum + r.amount,
      );

  int get coinsTotal => grants.whereType<CoinReward>().fold<int>(
        0,
        (int sum, CoinReward r) => sum + r.amount,
      );
}