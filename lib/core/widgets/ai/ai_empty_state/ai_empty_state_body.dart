import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../ai_empty_state.dart';

class AiEmptyStateBody extends StatelessWidget {
  const AiEmptyStateBody({
    super.key,
    required this.alignment,
    required this.spacing,
    required this.animationEnabled,
    required this.animation,
    required this.animationDuration,
    required this.isDark,
    required this.illustration,
    required this.header,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.customChild,
    required this.actions,
    required this.footer,
  });

  final AiEmptyStateAlignment alignment;
  final double spacing;
  final bool animationEnabled;
  final AiEmptyStateAnimation animation;
  final Duration animationDuration;
  final bool isDark;
  final Widget illustration;
  final Widget? header;
  final String title;
  final String? subtitle;
  final String? description;
  final Widget? customChild;
  final Widget? actions;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color foreground = isDark
        ? Colors.white
        : theme.colorScheme.onSurface;
    final CrossAxisAlignment cross = switch (alignment) {
      AiEmptyStateAlignment.center => CrossAxisAlignment.center,
      AiEmptyStateAlignment.start => CrossAxisAlignment.start,
      AiEmptyStateAlignment.end => CrossAxisAlignment.end,
    };

    final TextAlign textAlign = switch (alignment) {
      AiEmptyStateAlignment.center => TextAlign.center,
      AiEmptyStateAlignment.start => TextAlign.start,
      AiEmptyStateAlignment.end => TextAlign.end,
    };

    final List<Widget> children = <Widget>[];

    if (illustration is! SizedBox) {
      children.add(illustration);
      children.add(SizedBox(height: spacing));
    }
    if (header != null) {
      children.add(header!);
      children.add(SizedBox(height: spacing));
    }
    if (title.isNotEmpty) {
      children.add(
        Text(
          title,
          textAlign: textAlign,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: foreground,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
      );
    }
    if (subtitle != null) {
      children.add(SizedBox(height: AppSpacing.sm));
      children.add(
        Text(
          subtitle!,
          textAlign: textAlign,
          style: theme.textTheme.titleMedium?.copyWith(
            color: foreground.withValues(alpha: 0.75),
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
      );
    }
    if (description != null) {
      children.add(SizedBox(height: AppSpacing.sm));
      children.add(
        Text(
          description!,
          textAlign: textAlign,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: foreground.withValues(alpha: 0.65),
            height: 1.5,
          ),
        ),
      );
    }
    if (customChild != null) {
      children.add(SizedBox(height: spacing));
      children.add(customChild!);
    }
    if (actions != null) {
      children.add(SizedBox(height: spacing));
      children.add(actions!);
    }
    if (footer != null) {
      children.add(SizedBox(height: spacing));
      children.add(footer!);
    }

    final Widget column = Column(
      crossAxisAlignment: cross,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );

    if (!animationEnabled || animation == AiEmptyStateAnimation.none) {
      return column;
    }

    return AiEmptyStateEntrance(
      animation: animation,
      duration: animationDuration,
      child: column,
    );
  }
}
