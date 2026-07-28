import 'package:flutter/material.dart';

import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';
import 'ai_constants.dart';
import 'ai_empty_state/ai_empty_state_actions.dart';
import 'ai_empty_state/ai_empty_state_body.dart';
import 'ai_empty_state/ai_empty_state_illustration.dart';
import 'ai_empty_state/ai_empty_state_surface.dart';

export 'ai_empty_state/ai_empty_state_actions.dart';
export 'ai_empty_state/ai_empty_state_animation.dart';
export 'ai_empty_state/ai_empty_state_body.dart';
export 'ai_empty_state/ai_empty_state_illustration.dart';
export 'ai_empty_state/ai_empty_state_surface.dart';

/// Alignment of content inside an [AiEmptyState].
enum AiEmptyStateAlignment { center, start, end }

/// Visual style for the entrance animation.
enum AiEmptyStateAnimation { none, fade, fadeScale, fadeRise }

/// Optional footer behaviour when both [primaryAction] and
/// [secondaryAction] are supplied.
enum AiEmptyStateActionLayout { row, column, wrap }

/// A reusable, production-ready empty state widget for the AI module
/// family.
///
/// `AiEmptyState` renders the friendly "nothing here yet" surface used
/// across Prep Quest — AI History, AI Chat, AI Tutor, AI Prompt Studio,
/// AI Exam Simulator, AI Summary, AI Insights, AI Recommendations, and
/// any future AI module.
///
/// The widget is presentation-only: every visible string, icon, colour,
/// and action is a parameter. Callers compose the actions with any
/// widget they like (typically an [AiActionButton] or a stock
/// [ElevatedButton]) so this widget never has to know about feature
/// copy or feature routing.
class AiEmptyState extends StatelessWidget {
  const AiEmptyState({
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
    this.alignment = AiEmptyStateAlignment.center,
    this.actionLayout = AiEmptyStateActionLayout.row,
    this.padding,
    this.spacing,
    this.animationEnabled = true,
    this.animation = AiEmptyStateAnimation.fadeRise,
    this.animationDuration,
    this.maxContentWidth,
    this.semanticLabel,
    this.accentColor,
    this.backgroundColor,
    this.borderRadius,
  });

  /// Required headline (e.g. "No history yet").
  final String title;

  /// Optional supporting line directly under the title.
  final String? subtitle;

  /// Optional paragraph providing context or next-step guidance.
  final String? description;

  /// Optional inline icon — rendered inside the illustration bubble.
  final IconData? icon;

  /// Optional illustration widget. Takes precedence over [icon] when
  /// both are supplied. Typically an [Image], Lottie player, or a
  /// custom painted widget.
  final Widget? illustration;

  /// Optional primary call-to-action. The widget is rendered as-is
  /// (no surrounding button chrome).
  final Widget? primaryAction;

  /// Optional secondary call-to-action. Rendered alongside or below
  /// the primary action depending on [actionLayout] and width.
  final Widget? secondaryAction;

  /// Optional free-form content rendered between the description and
  /// the actions. Use this to embed quick-prompt rows, search fields,
  /// suggestion chips, or any other interactive element.
  final Widget? customChild;

  /// Optional slot rendered above the title (e.g. a status pill, a
  /// breadcrumb, or a feature badge).
  final Widget? header;

  /// Optional slot rendered below the actions (e.g. a "Learn more"
  /// link or a fine-print line).
  final Widget? footer;

  /// Horizontal alignment of the content column.
  final AiEmptyStateAlignment alignment;

  /// Layout for the actions row when both actions are supplied.
  final AiEmptyStateActionLayout actionLayout;

  /// Optional outer padding override. Defaults to a responsive
  /// padding derived from [AppSpacing].
  final EdgeInsetsGeometry? padding;

  /// Optional gap between content rows. Defaults to a responsive
  /// value based on width.
  final double? spacing;

  /// When `false`, suppresses the entrance animation entirely.
  final bool animationEnabled;

  /// Which entrance animation to use when [animationEnabled] is `true`.
  final AiEmptyStateAnimation animation;

  /// Optional duration override for the entrance animation.
  final Duration? animationDuration;

  /// Optional cap on the content width. When supplied, content is
  /// wrapped in a [ConstrainedBox]; useful when the empty state is
  /// rendered inside a wide canvas.
  final double? maxContentWidth;

  /// Optional override for the accessibility label.
  final String? semanticLabel;

  /// Optional accent colour override. When supplied, the illustration
  /// bubble tints to this colour instead of the default AI violet.
  final Color? accentColor;

  /// Optional surface colour override. When supplied, the empty state
  /// renders on a tinted surface card.
  final Color? backgroundColor;

  /// Optional border-radius override for the surface card. Has no
  /// effect when [backgroundColor] is `null`.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color resolvedAccent =
        accentColor ?? (isDark ? AiConstants.aiViolet : AiConstants.aiIndigo);

    final EdgeInsetsGeometry resolvedPadding =
        padding ?? _resolvePadding(isDark);

    final double resolvedSpacing = spacing ?? AppSpacing.lg;

    final Widget illustrationWidget = illustration != null
        ? illustration!
        : icon == null
        ? const SizedBox.shrink()
        : AiEmptyStateIllustration(icon: icon!, accent: resolvedAccent);

    final Widget body = AiEmptyStateBody(
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
      customChild: customChild,
      actions: (primaryAction != null || secondaryAction != null)
          ? AiEmptyStateActions(
              layout: actionLayout,
              primary: primaryAction,
              secondary: secondaryAction,
              spacing: resolvedSpacing,
            )
          : null,
      footer: footer,
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
        ? AiEmptyStateSurface(
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
