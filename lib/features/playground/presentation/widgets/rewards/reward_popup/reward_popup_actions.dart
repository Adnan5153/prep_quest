import 'package:flutter/material.dart';

import '../../../constants/playground_sizes.dart';
import 'reward_popup_primary_button.dart';
import 'reward_popup_secondary_button.dart';

class RewardPopupActions extends StatelessWidget {
  const RewardPopupActions({
    super.key,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimary,
    required this.onSecondary,
    required this.isDark,
  });

  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        RewardPopupPrimaryButton(label: primaryLabel, onPressed: onPrimary),
        if (onSecondary != null) ...<Widget>[
          const SizedBox(height: PlaygroundSizes.rewardPopupActionGap),
          RewardPopupSecondaryButton(
            label: secondaryLabel,
            onPressed: onSecondary,
            isDark: isDark,
          ),
        ],
      ],
    );
  }
}
