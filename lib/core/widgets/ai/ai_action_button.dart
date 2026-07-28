import 'package:flutter/material.dart';
import 'ai_button_variants.dart';
import 'ai_button_styles.dart';
import 'ai_button_animations.dart';
import '../../constants/app_spacing.dart';

/// A reusable, premium AI-powered action button.
class AiActionButton extends StatelessWidget {
  const AiActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AiButtonVariant.filled,
    this.size = AiButtonSize.medium,
    this.state = AiButtonState.enabled,
    this.animationType = AiButtonAnimationType.none,
    this.icon,
    this.trailing,
    this.width,
    this.fullWidth = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final AiButtonVariant variant;
  final AiButtonSize size;
  final AiButtonState state;
  final AiButtonAnimationType animationType;
  final IconData? icon;
  final Widget? trailing;
  final double? width;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final style = AiButtonStyles.resolve(
      context,
      variant: variant,
      size: size,
      state: state,
    );

    final bool isIconOnly = variant == AiButtonVariant.iconOnly;
    final bool isLoading =
        state == AiButtonState.loading || state == AiButtonState.processing;
    final bool isDisabled = state == AiButtonState.disabled;
    final bool isPremium = state == AiButtonState.premiumLocked;

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          _buildLoader(style.foregroundColor)
        else ...[
          if (isPremium)
            Icon(
              Icons.lock_rounded,
              size: style.iconSize,
              color: style.foregroundColor,
            )
          else if (icon != null)
            Icon(icon, size: style.iconSize, color: style.foregroundColor),

          if (!isIconOnly) ...[
            if (icon != null || isPremium) const SizedBox(width: AppSpacing.sm),
            Text(
              text,
              style: style.textStyle.copyWith(color: style.foregroundColor),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.sm),
              trailing!,
            ],
          ],
        ],
      ],
    );

    return AiButtonAnimationWrapper(
      animationType: animationType,
      isActive: !isDisabled && !isLoading,
      child: Container(
        width: fullWidth ? double.infinity : width,
        height: isIconOnly ? style.height : style.height,
        decoration: BoxDecoration(
          color: style.backgroundColor,
          gradient: style.gradient,
          borderRadius: BorderRadius.circular(style.borderRadius),
          border: style.borderColor != null
              ? Border.all(color: style.borderColor!)
              : null,
          boxShadow: style.shadows,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (isDisabled || isLoading) ? null : onPressed,
            borderRadius: BorderRadius.circular(style.borderRadius),
            child: Padding(padding: style.padding, child: content),
          ),
        ),
      ),
    );
  }

  Widget _buildLoader(Color color) {
    return SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
