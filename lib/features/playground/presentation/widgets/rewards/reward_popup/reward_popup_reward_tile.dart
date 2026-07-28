import 'package:flutter/material.dart';

import '../coin_reward.dart';
import '../xp_reward.dart';
import 'reward_entry.dart';
import 'reward_entry_kind.dart';
import 'reward_popup_badge_reward.dart';

class RewardPopupRewardTile extends StatelessWidget {
  const RewardPopupRewardTile({
    super.key,
    required this.entry,
    required this.isDark,
  });

  final RewardEntry entry;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    switch (entry.kind) {
      case RewardEntryKind.xp:
        return XpReward(
          amount: entry.amount,
          size: XpRewardSize.compact,
          layout: XpRewardLayout.detailed,
          rarity: entry.rarity,
          isDark: isDark,
        );
      case RewardEntryKind.coin:
        return CoinReward(
          amount: entry.amount,
          size: CoinRewardSize.compact,
          layout: CoinRewardLayout.detailed,
          rarity: entry.rarity,
          isDark: isDark,
        );
      case RewardEntryKind.badge:
      case RewardEntryKind.custom:
        return RewardPopupBadgeReward(entry: entry, isDark: isDark);
    }
  }
}
