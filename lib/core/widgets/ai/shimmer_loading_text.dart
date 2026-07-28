import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import 'ai_constants.dart';

/// Animated shimmer placeholder for in-flight text content.
///
/// Produces 1–N stacked skeleton lines that pulse with a sliding
/// highlight gradient. The default look mirrors the AI loader family
/// (violet/indigo), but every parameter — line count, line height,
/// spacing, radius, shimmer colors, animation duration, per-line
/// widths — is overridable so the same widget can be reused for
/// loading paragraphs, list rows, and inline placeholders across the
/// application.
class ShimmerLoadingText extends StatefulWidget {
  const ShimmerLoadingText({
    super.key,
    this.lineCount = 3,
    this.lineHeight = 12.0,
    this.lineSpacing = AppSpacing.sm,
    this.borderRadius,
    this.lineWidths,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.accent,
    this.duration = AiConstants.streamingDuration,
    this.padding = EdgeInsets.zero,
    this.maxWidth,
    this.semanticLabel = 'Loading content',
    this.enabled = true,
  });

  /// Number of skeleton lines to render (1–8). Default 3.
  final int lineCount;

  /// Height of every skeleton line in logical pixels. Default 12.
  final double lineHeight;

  /// Vertical gap inserted between successive skeleton lines.
  final double lineSpacing;

  /// Corner radius applied to each skeleton line. When `null` the
  /// radius is derived from [lineHeight] (half-height pill).
  final BorderRadius? borderRadius;

  /// Optional per-line width factors (0.0–1.0). When provided, the
  /// length at index `i` falls back to a sensible default when the list
  /// is shorter than [lineCount].
  final List<double>? lineWidths;

  /// Base color of the shimmer gradient. Resolves to a neutral
  /// light/dark surface when `null`.
  final Color? shimmerBaseColor;

  /// Highlight color of the shimmer gradient (the moving "shine").
  /// Resolves to a tinted highlight when `null`.
  final Color? shimmerHighlightColor;

  /// Optional accent used to tint the default shimmer palette. Useful
  /// for brand-coloured loaders (e.g. brand orange).
  final Color? accent;

  /// Duration of a single shimmer pass. Default is the AI streaming
  /// duration so placeholders feel "live".
  final Duration duration;

  /// Optional outer padding applied around the whole stack.
  final EdgeInsetsGeometry padding;

  /// Optional hard cap on the rendered width. Useful inside wide
  /// parents (cards, sheets, side panels).
  final double? maxWidth;

  /// Label announced by screen readers while the placeholder is
  /// visible. Defaults to a generic "Loading content" message.
  final String semanticLabel;

  /// When `false`, the shimmer animation is paused and the lines are
  /// rendered as static placeholders. Useful for reduced-motion and
  /// storybook snapshots.
  final bool enabled;

  @override
  State<ShimmerLoadingText> createState() => _ShimmerLoadingTextState();
}

class _ShimmerLoadingTextState extends State<ShimmerLoadingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void initState() {
    super.initState();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant ShimmerLoadingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      _syncAnimation();
    } else if (oldWidget.enabled != widget.enabled) {
      _syncAnimation();
    }
  }

  void _syncAnimation() {
    if (widget.enabled) {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    } else {
      _controller.stop();
      _controller.value = 0.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int safeCount = widget.lineCount.clamp(1, 8);
    final BorderRadius effectiveRadius =
        widget.borderRadius ?? BorderRadius.circular(widget.lineHeight / 2);
    final _ShimmerPalette palette = _resolvePalette(context);

    final List<Widget> lines = <Widget>[
      for (int i = 0; i < safeCount; i++)
        Padding(
          padding: EdgeInsets.only(
            bottom: i == safeCount - 1 ? 0 : widget.lineSpacing,
          ),
          child: _ShimmerLine(
            controller: _controller,
            enabled: widget.enabled,
            height: widget.lineHeight,
            widthFactor: _widthFactorFor(i, safeCount),
            radius: effectiveRadius,
            base: palette.base,
            highlight: palette.highlight,
          ),
        ),
    ];

    final Widget stack = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: lines,
    );

    Widget content = Padding(padding: widget.padding, child: stack);

    if (widget.maxWidth != null) {
      content = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxWidth!),
        child: content,
      );
    }

    return Semantics(
      label: widget.semanticLabel,
      liveRegion: true,
      container: true,
      child: ExcludeSemantics(child: content),
    );
  }

  _ShimmerPalette _resolvePalette(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final Color tint = widget.accent ?? AiConstants.aiViolet;

    final Color base =
        widget.shimmerBaseColor ??
        (brightness == Brightness.dark
            ? const Color(0xFF1F2233)
            : const Color(0xFFE6E8F2));
    final Color highlight =
        widget.shimmerHighlightColor ??
        Color.lerp(base, tint, brightness == Brightness.dark ? 0.55 : 0.45)!;

    return _ShimmerPalette(base: base, highlight: highlight);
  }

  double _widthFactorFor(int index, int total) {
    if (widget.lineWidths != null && index < widget.lineWidths!.length) {
      return widget.lineWidths![index].clamp(0.0, 1.0);
    }
    if (total == 1) return 0.6;
    if (index == total - 1) return 0.5;
    if (index == 0) return 0.92;
    return 0.78;
  }
}

class _ShimmerLine extends StatelessWidget {
  const _ShimmerLine({
    required this.controller,
    required this.enabled,
    required this.height,
    required this.widthFactor,
    required this.radius,
    required this.base,
    required this.highlight,
  });

  final AnimationController controller;
  final bool enabled;
  final double height;
  final double widthFactor;
  final BorderRadius radius;
  final Color base;
  final Color highlight;

  @override
  Widget build(BuildContext context) {
    final Widget bar = Container(
      height: height,
      decoration: BoxDecoration(borderRadius: radius, color: base),
    );

    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          if (!enabled) {
            return child!;
          }
          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (Rect bounds) {
              final double dx = bounds.width;
              final double t = controller.value;
              return LinearGradient(
                begin: Alignment(-1.0 + 2 * t, 0),
                end: Alignment(0.0 + 2 * t, 0),
                colors: <Color>[base, highlight, base],
                stops: const <double>[0.25, 0.5, 0.75],
              ).createShader(
                Rect.fromLTWH(-dx, 0, bounds.width + 2 * dx, bounds.height),
              );
            },
            child: child,
          );
        },
        child: bar,
      ),
    );
  }
}

class _ShimmerPalette {
  const _ShimmerPalette({required this.base, required this.highlight});

  final Color base;
  final Color highlight;
}
