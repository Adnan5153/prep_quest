import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_icons.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';

class RewardPopupPrimaryButton extends StatelessWidget {
  const RewardPopupPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    PlaygroundColors.popupAccent,
                    PlaygroundColors.popupAccent.withValues(
                      alpha: PlaygroundOpacity.rewardPopupCtaGradientEnd,
                    ),
                  ],
                ),
                borderRadius: BorderRadius.circular(
                  PlaygroundSizes.rewardPopupCtaRadius,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: PlaygroundColors.popupAccent.withValues(
                      alpha: PlaygroundOpacity.rewardPopupCtaShadow,
                    ),
                    blurRadius: PlaygroundSizes.rewardPopupCtaShadowBlur,
                    spreadRadius: PlaygroundSizes.rewardPopupCtaShadowSpread,
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      AppIcons.sparkle,
                      size: AppSizes.iconSm,
                      color: AppColors.darkOnSurface,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.darkOnSurface,
                        fontWeight: FontWeight.w800,
                        fontSize: PlaygroundSizes.rewardPopupCtaFontSize,
                        letterSpacing:
                            PlaygroundSizes.rewardPopupCtaLetterSpacing,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
