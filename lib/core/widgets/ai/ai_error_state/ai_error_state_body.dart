import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../ai_error_state.dart';

class AiErrorStateBody extends StatelessWidget {
  const AiErrorStateBody({
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
    required this.metadata,
    required this.accent,
    required this.customChild,
    required this.actions,
    required this.footer,
    required this.errorCode,
    required this.retryAttempts,
  });

  final AiErrorStateAlignment alignment;
  final double spacing;
  final bool animationEnabled;
  final AiErrorStateAnimation animation;
  final Duration animationDuration;
  final bool isDark;
  final Widget illustration;
  final Widget? header;
  final String title;
  final String? subtitle;
  final String? description;
  final Widget? metadata;
  final Color accent;
  final Widget? customChild;
  final Widget? actions;
  final Widget? footer;
  final String? errorCode;
  final int? retryAttempts;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color foreground = isDark
        ? Colors.white
        : theme.colorScheme.onSurface;
    final CrossAxisAlignment cross = switch (alignment) {
      AiErrorStateAlignment.center => CrossAxisAlignment.center,
      AiErrorStateAlignment.start => CrossAxisAlignment.start,
      AiErrorStateAlignment.end => CrossAxisAlignment.end,
    };

    final TextAlign textAlign = switch (alignment) {
      AiErrorStateAlignment.center => TextAlign.center,
      AiErrorStateAlignment.start => TextAlign.start,
      AiErrorStateAlignment.end => TextAlign.end,
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

    final Widget metadataWidget = AiErrorStateMetadata(
      code: errorCode,
      attempts: retryAttempts,
      accent: accent,
      isDark: isDark,
    );

    if (metadataWidget is! SizedBox) {
      children.add(SizedBox(height: AppSpacing.md));
      children.add(metadataWidget);
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

    if (!animationEnabled || animation == AiErrorStateAnimation.none) {
      return column;
    }

    return AiErrorStateEntrance(
      animation: animation,
      duration: animationDuration,
      child: column,
    );
  }
}
