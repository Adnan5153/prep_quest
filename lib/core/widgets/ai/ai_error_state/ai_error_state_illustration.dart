import 'package:flutter/material.dart';

import '../../../constants/app_sizes.dart';

class AiErrorStateIllustration extends StatelessWidget {
  const AiErrorStateIllustration({
    super.key,
    required this.icon,
    required this.accent,
  });

  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: AppSizes.iconXl + 24,
      height: AppSizes.iconXl + 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            accent.withValues(alpha: 0.18),
            accent.withValues(alpha: isDark ? 0.32 : 0.14),
          ],
        ),
        border: Border.all(
          color: accent.withValues(alpha: 0.4),
          width: AppSizes.borderThin,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: accent.withValues(alpha: 0.3),
            blurRadius: 24,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Icon(icon, size: AppSizes.iconXl, color: accent),
    );
  }
}
