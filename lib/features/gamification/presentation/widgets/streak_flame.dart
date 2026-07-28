import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';

/// Animated flame icon — used by the streak counter and the daily
/// login banner. The flame pulses softly while the streak is alive.
class StreakFlame extends StatelessWidget {
  const StreakFlame({
    super.key,
    this.size = AppSizes.iconXl,
    this.color = AppColors.error,
    this.isAlive = true,
  });

  final double size;
  final Color color;
  final bool isAlive;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.95, end: isAlive ? 1.05 : 0.95),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      builder: (BuildContext context, double scale, Widget? child) {
        return Transform.scale(
          scale: scale,
          child: Icon(
            isAlive ? AppIcons.fireFilled : AppIcons.streak,
            size: size,
            color: isAlive ? color : AppColors.lightMuted,
          ),
        );
      },
    );
  }
}