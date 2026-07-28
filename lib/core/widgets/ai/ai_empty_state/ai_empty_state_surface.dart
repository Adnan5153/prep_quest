import 'package:flutter/material.dart';

import '../../../constants/app_sizes.dart';

class AiEmptyStateSurface extends StatelessWidget {
  const AiEmptyStateSurface({
    super.key,
    required this.color,
    required this.borderRadius,
    required this.isDark,
    required this.child,
  });

  final Color color;
  final BorderRadius borderRadius;
  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor, width: AppSizes.borderThin),
      ),
      child: child,
    );
  }
}
