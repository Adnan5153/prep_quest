import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_spacing.dart';
import 'ai_loading_avatar.dart';
import 'ai_loading_constants.dart';
import 'ai_loading_shimmer.dart';
import 'ai_loading_text.dart';

/// Generic skeleton card used while AI content is being generated or
/// fetched.
///
/// Reusable across the entire AI module family — AI Tutor, AI Chat, AI
/// Prompt Studio, AI Exam Simulator, AI Summary, AI Insights and any
/// future surface. The widget is intentionally presentation-only: it
/// never fetches data, manages state or talks to providers.
///
/// Composition is delegated to focused primitives in this subsystem:
/// [AiLoadingShimmer] owns the shimmer animation and exposes its
/// controller through [AiLoadingShimmerScope];
/// [AiLoadingAvatar] renders the leading block;
/// [AiLoadingText] renders each skeleton bar and self-subscribes to
/// the ambient shimmer. Loading-specific tokens live in
/// [AiLoadingTokens] / [LoadingPalette].
class AiLoadingCard extends StatelessWidget {
  const AiLoadingCard({
    super.key,
    this.isDark,
    this.showAvatar = true,
    this.showTitle = true,
    this.showSubtitle = true,
    this.showBody = true,
    this.showFooter = false,
    this.bodyLineCount = 3,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation = 0,
    this.animationEnabled = true,
    this.semanticLabel,
  });

  /// Force a specific brightness. When `null` brightness is resolved from
  /// [Theme.of(context).brightness].
  final bool? isDark;

  /// Show the leading square avatar placeholder.
  final bool showAvatar;

  /// Show the title placeholder bar.
  final bool showTitle;

  /// Show the subtitle placeholder bar.
  final bool showSubtitle;

  /// Show the body placeholder block with [bodyLineCount] lines.
  final bool showBody;

  /// Show the footer placeholder bar.
  final bool showFooter;

  /// Number of body lines when [showBody] is `true`. Clamped to 1..6.
  final int bodyLineCount;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final double elevation;
  final bool animationEnabled;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final bool resolvedDark =
        isDark ?? Theme.of(context).brightness == Brightness.dark;
    final LoadingPalette palette = LoadingPalette.from(resolvedDark);

    return AiLoadingShimmer(
      enabled: animationEnabled,
      child: Builder(
        builder: (BuildContext context) {
          final double radius = borderRadius ?? AppRadius.lg;
          final EdgeInsetsGeometry inner =
              padding ?? const EdgeInsets.all(AppSpacing.md);

          final List<Widget> rows = <Widget>[];

          if (showAvatar || showTitle || showSubtitle) {
            rows.add(
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (showAvatar) ...<Widget>[
                    AiLoadingAvatar(palette: palette),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (showTitle)
                          AiLoadingText(
                            palette: palette,
                            width: double.infinity,
                            height: 14,
                            radius: AppRadius.xs,
                          ),
                        if (showTitle && showSubtitle)
                          const SizedBox(height: AppSpacing.sm),
                        if (showSubtitle)
                          AiLoadingText(
                            palette: palette,
                            width: 180,
                            height: 10,
                            radius: AppRadius.xs,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          if (showBody) {
            if (rows.isNotEmpty) {
              rows.add(const SizedBox(height: AppSpacing.md));
            }
            rows.add(_BodyBlock(count: bodyLineCount, palette: palette));
          }

          if (showFooter) {
            if (rows.isNotEmpty) {
              rows.add(const SizedBox(height: AppSpacing.md));
            }
            rows.add(
              AiLoadingText(
                palette: palette,
                width: 96,
                height: 8,
                radius: AppRadius.xs,
              ),
            );
          }

          final Widget content = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rows,
          );

          final Widget framed = Container(
            margin: margin,
            decoration: BoxDecoration(
              color: resolvedDark
                  ? AppColors.darkSurface
                  : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: resolvedDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : AppColors.lightMuted.withValues(alpha: 0.18),
                width: AppSizes.borderThin,
              ),
              boxShadow: elevation > 0
                  ? <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: resolvedDark ? 0.30 : 0.04,
                        ),
                        blurRadius: 10,
                        spreadRadius: -2,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Padding(padding: inner, child: content),
          );

          return Semantics(
            container: true,
            label: semanticLabel ?? 'Loading content',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: framed,
            ),
          );
        },
      ),
    );
  }
}

class _BodyBlock extends StatelessWidget {
  const _BodyBlock({required this.count, required this.palette});

  final int count;
  final LoadingPalette palette;

  @override
  Widget build(BuildContext context) {
    final int n = AiLoadingTokens.clampBodyLineCount(count);
    final List<double> widths = AiLoadingTokens.bodyLineWidths(n);
    final List<Widget> bars = <Widget>[];
    for (int i = 0; i < n; i++) {
      bars.add(
        AiLoadingText(
          palette: palette,
          width: widths[i],
          height: 10,
          radius: AppRadius.xs,
        ),
      );
      if (i < n - 1) {
        bars.add(const SizedBox(height: AppSpacing.xs));
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: bars,
    );
  }
}
