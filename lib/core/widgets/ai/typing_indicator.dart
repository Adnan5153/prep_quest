import 'package:flutter/material.dart';

import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';
import 'ai_constants.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({
    super.key,
    this.dotCount = 3,
    this.dotSize = 8.0,
    this.spacing = 6.0,
    this.duration = const Duration(milliseconds: 900),
    this.curve = Curves.easeInOut,
    this.color,
    this.activeColor,
    this.inactiveAlpha = 0.35,
    this.backgroundColor,
    this.borderRadius,
    this.borderColor,
    this.borderWidth = 1.0,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    this.avatar,
    this.label,
    this.labelStyle,
    this.labelGap = AppSpacing.sm,
    this.pulse = false,
    this.pulseDuration = const Duration(milliseconds: 1800),
    this.semanticLabel = 'AI is typing',
    this.maxWidth,
  });

  final int dotCount;
  final double dotSize;
  final double spacing;
  final Duration duration;
  final Curve curve;
  final Color? color;
  final Color? activeColor;
  final double inactiveAlpha;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry padding;
  final Widget? avatar;
  final String? label;
  final TextStyle? labelStyle;
  final double labelGap;
  final bool pulse;
  final Duration pulseDuration;
  final String semanticLabel;
  final double? maxWidth;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late final AnimationController _dots = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: widget.pulseDuration,
  );

  @override
  void initState() {
    super.initState();
    _dots.repeat();
    if (widget.pulse) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant TypingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _dots.duration = widget.duration;
    }
    if (oldWidget.pulseDuration != widget.pulseDuration) {
      _pulse.duration = widget.pulseDuration;
    }
    if (oldWidget.pulse != widget.pulse) {
      if (widget.pulse) {
        _pulse.repeat(reverse: true);
      } else {
        _pulse.stop();
        _pulse.value = 0.0;
      }
    }
  }

  @override
  void dispose() {
    _dots.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final _TypingPalette palette = _resolvePalette(theme, isDark);

    final int safeCount = widget.dotCount.clamp(1, 6);
    final double safeSpacing = widget.spacing.clamp(0.0, 24.0);
    final double safeDotSize = widget.dotSize.clamp(2.0, 32.0);
    final double stagger = safeCount == 1 ? 0.0 : 1.0 / safeCount;

    final BorderRadius radius =
        widget.borderRadius ?? BorderRadius.circular(AppRadius.pill);

    final Widget dots = RepaintBoundary(
      child: AnimatedBuilder(
        animation: _dots,
        builder: (BuildContext context, Widget? _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < safeCount; i++)
                Padding(
                  padding: EdgeInsets.only(
                    right: i == safeCount - 1 ? 0 : safeSpacing,
                  ),
                  child: _AnimatedDot(
                    controllerValue: _dots.value,
                    phase: i * stagger,
                    curve: widget.curve,
                    size: safeDotSize,
                    color: palette.dot,
                    inactiveAlpha: widget.inactiveAlpha,
                  ),
                ),
            ],
          );
        },
      ),
    );

    final Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (widget.avatar != null) ...<Widget>[
          widget.avatar!,
          SizedBox(width: widget.labelGap),
        ],
        if (widget.label != null && widget.label!.isNotEmpty) ...<Widget>[
          Flexible(
            child: Text(
              widget.label!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textScaler: MediaQuery.textScalerOf(
                context,
              ).clamp(minScaleFactor: 0.85, maxScaleFactor: 1.4),
              style:
                  widget.labelStyle ??
                  theme.textTheme.labelMedium?.copyWith(
                    color: palette.label,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
            ),
          ),
          SizedBox(width: widget.labelGap),
        ],
        dots,
      ],
    );

    Widget capsule = Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? palette.background,
        borderRadius: radius,
        border: widget.borderColor != null
            ? Border.all(color: widget.borderColor!, width: widget.borderWidth)
            : (widget.backgroundColor == null
                  ? Border.all(
                      color: palette.backgroundBorder,
                      width: widget.borderWidth,
                    )
                  : null),
      ),
      child: content,
    );

    if (widget.maxWidth != null) {
      capsule = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxWidth!),
        child: capsule,
      );
    }

    if (widget.pulse) {
      capsule = AnimatedBuilder(
        animation: _pulse,
        builder: (BuildContext context, Widget? child) {
          final double scale = 1.0 - (_pulse.value * 0.04);
          return Transform.scale(scale: scale, child: child);
        },
        child: capsule,
      );
    }

    return Semantics(
      label: widget.semanticLabel,
      liveRegion: true,
      container: true,
      child: Align(alignment: AlignmentDirectional.centerStart, child: capsule),
    );
  }

  _TypingPalette _resolvePalette(ThemeData theme, bool isDark) {
    final Color accent = AiConstants.aiViolet;
    final Color dot =
        widget.color ??
        widget.activeColor ??
        (isDark ? AiConstants.aiCyan : accent);
    final Color background =
        widget.backgroundColor ??
        (isDark ? const Color(0xFF15171F) : const Color(0xFFFFFFFF));
    final Color backgroundBorder = isDark
        ? AiConstants.aiViolet.withValues(alpha: 0.32)
        : AiConstants.aiViolet.withValues(alpha: 0.18);
    final Color label = (widget.color ?? theme.colorScheme.onSurfaceVariant)
        .withValues(alpha: isDark ? 0.85 : 0.78);

    return _TypingPalette(
      dot: dot,
      background: background,
      backgroundBorder: backgroundBorder,
      label: label,
    );
  }
}

class _AnimatedDot extends StatelessWidget {
  const _AnimatedDot({
    required this.controllerValue,
    required this.phase,
    required this.curve,
    required this.size,
    required this.color,
    required this.inactiveAlpha,
  });

  final double controllerValue;
  final double phase;
  final Curve curve;
  final double size;
  final Color color;
  final double inactiveAlpha;

  @override
  Widget build(BuildContext context) {
    final double raw = controllerValue + phase;
    final double wrapped = raw - raw.floor();
    final double t = curve.transform(wrapped);
    final double clamped = t < 0.5 ? t * 2 : (1 - t) * 2;
    final double opacity = inactiveAlpha + (1 - inactiveAlpha) * clamped;
    final double scale = 0.85 + 0.15 * clamped;

    return Transform.scale(
      scale: scale,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
        ),
      ),
    );
  }
}

class _TypingPalette {
  const _TypingPalette({
    required this.dot,
    required this.background,
    required this.backgroundBorder,
    required this.label,
  });

  final Color dot;
  final Color background;
  final Color backgroundBorder;
  final Color label;
}
