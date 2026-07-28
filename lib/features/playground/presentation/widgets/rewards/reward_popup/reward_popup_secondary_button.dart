import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../constants/playground_sizes.dart';

class RewardPopupSecondaryButton extends StatelessWidget {
  const RewardPopupSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isDark,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    return SizedBox(
      height: PlaygroundSizes.rewardPopupCtaHeight,
      child: Semantics(
        button: true,
        enabled: onPressed != null,
        label: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(
              PlaygroundSizes.rewardPopupCtaRadius,
            ),
            child: Center(
              child: Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  fontSize: PlaygroundSizes.rewardPopupCtaFontSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
