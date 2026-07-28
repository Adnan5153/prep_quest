import 'package:flutter/material.dart';

class CoinRewardGlow extends StatelessWidget {
  const CoinRewardGlow({
    super.key,
    required this.diameter,
    required this.color,
  });

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            color.withValues(alpha: 0.45),
            color.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: SizedBox(width: diameter * 1.6, height: diameter * 1.6),
    );
  }
}
