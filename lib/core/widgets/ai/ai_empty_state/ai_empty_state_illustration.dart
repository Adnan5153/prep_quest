import 'package:flutter/material.dart';

import '../../../constants/app_sizes.dart';
import '../../../constants/app_spacing.dart';

class AiEmptyStateIllustration extends StatelessWidget {
  const AiEmptyStateIllustration({
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
      width: AppSizes.iconXl + AppSpacing.xxl,
      height: AppSizes.iconXl + AppSpacing.xxl,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            accent.withValues(alpha: 0.18),
            accent.withValues(alpha: isDark ? 0.32 : 0.12),
          ],
        ),
        border: Border.all(
          color: accent.withValues(alpha: 0.4),
          width: AppSizes.borderThin,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: accent.withValues(alpha: 0.28),
            blurRadius: 24,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Icon(icon, size: AppSizes.iconXl, color: accent),
    );
  }
}
