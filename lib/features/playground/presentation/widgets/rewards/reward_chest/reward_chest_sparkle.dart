import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_icons.dart';

class RewardChestSparkle extends StatelessWidget {
  const RewardChestSparkle({
    super.key,
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(AppIcons.sparkle, size: size, color: color);
  }
}
