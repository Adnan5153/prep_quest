import 'package:flutter/material.dart';

import '../../../../../../core/widgets/responsive_builder.dart';
import '../../../constants/playground_sizes.dart';
import '../../../constants/playground_strings.dart';
import 'coin_reward_models.dart';

class CoinRewardSizing {
  const CoinRewardSizing._();

  static double resolveDiameter(BuildContext context, CoinRewardSize size) {
    final scale = ResponsiveBuilder.value<double>(
      context,
      mobile: 1.0,
      tablet: PlaygroundSizes.cardTabletScale,
      desktop: PlaygroundSizes.cardDesktopScale,
    );
    final base = switch (size) {
      CoinRewardSize.compact => PlaygroundSizes.rewardCoinSizeCompact,
      CoinRewardSize.standard => PlaygroundSizes.rewardCoinSizeStandard,
      CoinRewardSize.large => PlaygroundSizes.rewardCoinSizeLarge,
    };
    return base * scale;
  }
}

class CoinRewardSemantics {
  const CoinRewardSemantics._();

  static String iconLabel(String? override, int amount) {
    if (override != null) return override;
    return '${PlaygroundStrings.rewardCoinSemanticTemplate}, '
        '${PlaygroundStrings.rewardCoinLabelTemplate}$amount';
  }

  static String detailedLabel(String? override, int amount) {
    if (override != null) return override;
    return '${PlaygroundStrings.coinLabel} '
        '${PlaygroundStrings.rewardCoinLabelTemplate}$amount';
  }
}

class CoinSparkleLayout {
  const CoinSparkleLayout._();

  static const List<CoinSparkleSpec> spots = <CoinSparkleSpec>[
    CoinSparkleSpec(dx: -0.35, dy: -0.30, delay: 0.0),
    CoinSparkleSpec(dx: 0.36, dy: -0.18, delay: 0.33),
    CoinSparkleSpec(dx: 0.30, dy: 0.28, delay: 0.66),
  ];

  static double scaleFor(double progress, double delay) {
    final local = (progress - delay).clamp(0.0, 1.0);
    final falloff = 1 - (local - 0.5).abs() * 2;
    return 0.6 + 0.4 * falloff.clamp(0.0, 1.0);
  }

  static double opacityFor(double progress, double delay) {
    final local = (progress - delay).clamp(0.0, 1.0);
    return (1 - (local - 0.5).abs() * 2).clamp(0.0, 1.0);
  }
}
