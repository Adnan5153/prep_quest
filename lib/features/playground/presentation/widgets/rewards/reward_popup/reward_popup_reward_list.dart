import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../constants/playground_sizes.dart';
import 'reward_entry.dart';
import 'reward_popup_reward_tile.dart';

class RewardPopupRewardList extends StatelessWidget {
  const RewardPopupRewardList({
    super.key,
    required this.entries,
    required this.isDark,
  });

  final List<RewardEntry> entries;
  final bool isDark;

  static const EdgeInsets _firstGap = EdgeInsets.zero;
  static const EdgeInsets _subsequentGap = EdgeInsets.only(top: AppSpacing.sm);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: PlaygroundSizes.rewardPopupListMaxHeight,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return Padding(
              padding: index == 0 ? _firstGap : _subsequentGap,
              child: RewardPopupRewardTile(entry: entry, isDark: isDark),
            );
          },
        ),
      ),
    );
  }
}
