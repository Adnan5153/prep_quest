import 'package:flutter/material.dart';

import 'chat_input_bar_constants.dart';

/// Internal surface chrome used by [ChatInputBar].
///
/// Owns the outer capsule — background colour / gradient, border,
/// border-radius and floating shadow — but stays presentation-only and
/// stateless. Visual resolution mirrors the rest of the AI widget
/// family: callers can override every token and theme dark-mode is
/// handled automatically.
class ChatInputBarSurface extends StatelessWidget {
  const ChatInputBarSurface({
    super.key,
    required this.style,
    required this.isDark,
    required this.padding,
    required this.child,
    this.backgroundColor,
    this.gradient,
    this.borderColor,
    this.borderRadius,
    this.elevation = 0,
  });

  final ChatInputBarStyle style;
  final bool isDark;
  final EdgeInsetsGeometry padding;
  final Widget child;

  final Color? backgroundColor;
  final Gradient? gradient;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final Color resolvedBg =
        backgroundColor ??
        (isDark
            ? ChatInputBarConstants.darkSurface
            : ChatInputBarConstants.lightSurface);

    final Gradient resolvedGradient =
        gradient ??
        (isDark
            ? ChatInputBarConstants.darkGradient
            : ChatInputBarConstants.lightGradient);

    final Color resolvedBorder =
        borderColor ??
        (isDark
            ? ChatInputBarConstants.darkBorder
            : ChatInputBarConstants.lightBorder);

    final BorderRadius resolvedRadius =
        borderRadius ??
        BorderRadius.circular(ChatInputBarConstants.surfaceRadius);

    final List<BoxShadow> shadows = elevation > 0
        ? ChatInputBarConstants.floatingShadow(resolvedBorder, isDark)
        : <BoxShadow>[];

    return AnimatedContainer(
      duration: ChatInputBarConstants.focusDuration,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: style == ChatInputBarStyle.glass
            ? resolvedBg.withValues(alpha: isDark ? 0.92 : 0.96)
            : resolvedBg,
        gradient: style == ChatInputBarStyle.glass ? resolvedGradient : null,
        borderRadius: resolvedRadius,
        border: style == ChatInputBarStyle.outlined
            ? Border.all(color: resolvedBorder, width: 1.0)
            : style == ChatInputBarStyle.glass
            ? Border.all(
                color: resolvedBorder.withValues(alpha: 0.55),
                width: 1.0,
              )
            : null,
        boxShadow: shadows.isEmpty ? null : shadows,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
