import 'package:flutter/material.dart';

import '../../../../constants/app_spacing.dart';
import 'ai_history_loading_card.dart';

/// Vertical stack of skeleton cards used while data is loading.
class AiHistoryLoading extends StatelessWidget {
  const AiHistoryLoading({
    super.key,
    required this.isDark,
    this.itemCount = 4,
    this.separatorHeight = AppSpacing.sm,
  });

  final bool isDark;
  final int itemCount;
  final double separatorHeight;

  @override
  Widget build(BuildContext context) {
    final int count = itemCount.clamp(1, 8);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < count; i++) ...<Widget>[
          if (i > 0) SizedBox(height: separatorHeight),
          AiHistoryLoadingCard(isDark: isDark),
        ],
      ],
    );
  }
}
