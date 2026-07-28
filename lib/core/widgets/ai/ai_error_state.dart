import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';
import 'ai_constants.dart';
import 'ai_error_state/ai_error_state_actions.dart';
import 'ai_error_state/ai_error_state_body.dart';
import 'ai_error_state/ai_error_state_illustration.dart';
import 'ai_error_state/ai_error_state_surface.dart';

export 'ai_error_state/ai_error_state_actions.dart';
export 'ai_error_state/ai_error_state_animation.dart';
export 'ai_error_state/ai_error_state_body.dart';
export 'ai_error_state/ai_error_state_illustration.dart';
export 'ai_error_state/ai_error_state_metadata.dart';
export 'ai_error_state/ai_error_state_surface.dart';

enum AiErrorStateAlignment { center, start, end }

enum AiErrorStateAnimation { none, fade, fadeScale, fadeRise }

enum AiErrorStateActionLayout { row, column, wrap }

class AiErrorState extends StatelessWidget {
  const AiErrorState({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.icon,
    this.illustration,
    this.primaryAction,
    this.secondaryAction,
    this.customChild,
    this.header,
    this.footer,
    this.alignment = AiErrorStateAlignment.center,
    this.actionLayout = AiErrorStateActionLayout.row,
    this.padding,
    this.spacing,
    this.animationEnabled = true,
    this.animation = AiErrorStateAnimation.fadeRise,
    this.animationDuration,
    this.maxContentWidth,
    this.semanticLabel,
    this.accentColor,
    this.backgroundColor,
    this.borderRadius,
    this.errorCode,
    this.retryAttempts,
  });

  final String title;
  final String? subtitle;
  final String? description;
  final IconData? icon;
  final Widget? illustration;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final Widget? customChild;
  final Widget? header;
  final Widget? footer;
  final AiErrorStateAlignment alignment;
  final AiErrorStateActionLayout actionLayout;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final bool animationEnabled;
  final AiErrorStateAnimation animation;
  final Duration? animationDuration;
  final double? maxContentWidth;
  final String? semanticLabel;
  final Color? accentColor;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final String? errorCode;
  final int? retryAttempts;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color resolvedAccent =
        accentColor ?? (isDark ? AiConstants.aiRose : AppColors.error);

    final EdgeInsetsGeometry resolvedPadding =
        padding ?? _resolvePadding(isDark);

    final double resolvedSpacing = spacing ?? AppSpacing.lg;

    final Widget illustrationWidget = illustration != null
        ? illustration!
        : icon == null
        ? const SizedBox.shrink()
        : AiErrorStateIllustration(icon: icon!, accent: resolvedAccent);

    final Widget body = AiErrorStateBody(
      alignment: alignment,
      spacing: resolvedSpacing,
      animationEnabled: animationEnabled,
      animation: animation,
      animationDuration: animationDuration ?? const Duration(milliseconds: 320),
      isDark: isDark,
      illustration: illustrationWidget,
      header: header,
      title: title,
      subtitle: subtitle,
      description: description,
      metadata: null,
      accent: resolvedAccent,
      customChild: customChild,
      actions: (primaryAction != null || secondaryAction != null)
          ? AiErrorStateActions(
              layout: actionLayout,
              primary: primaryAction,
              secondary: secondaryAction,
              spacing: resolvedSpacing,
            )
          : null,
      footer: footer,
      errorCode: errorCode,
      retryAttempts: retryAttempts,
    );

    final Widget constrained = maxContentWidth != null
        ? Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth!),
              child: body,
            ),
          )
        : body;

    final Widget content = backgroundColor != null
        ? AiErrorStateSurface(
            color: backgroundColor!,
            borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.lg),
            isDark: isDark,
            child: Padding(padding: resolvedPadding, child: constrained),
          )
        : Padding(padding: resolvedPadding, child: constrained);

    return Semantics(
      label: semanticLabel ?? title,
      container: true,
      child: content,
    );
  }

  EdgeInsetsGeometry _resolvePadding(bool isDark) {
    if (isDark) {
      return const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.xxxl,
      );
    }
    return const EdgeInsets.all(AppSpacing.xl);
  }
}
