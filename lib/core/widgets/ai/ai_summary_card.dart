/// Public re-exports for the AI summary card subsystem.
///
/// Consumers can import this single file to access the public API:
///
/// ```dart
/// import 'package:prep_quest/core/widgets/ai/ai_summary_card.dart';
/// ```
///
/// The card itself is exported as [AiSummaryCard]; the supporting models
/// and types live alongside it so callers don't have to memorise the
/// internal file layout under `summary/`.
library;

export 'summary/ai_summary_actions.dart';
export 'summary/ai_summary_body.dart';
export 'summary/ai_summary_constants.dart';
export 'summary/ai_summary_footer.dart';
export 'summary/ai_summary_header.dart';
export 'summary/ai_summary_metadata.dart';
export 'summary/ai_summary_models.dart';
export 'summary/ai_summary_tags.dart';

import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import 'summary/ai_summary_actions.dart';
import 'summary/ai_summary_body.dart';
import 'summary/ai_summary_constants.dart';
import 'summary/ai_summary_footer.dart';
import 'summary/ai_summary_header.dart';
import 'summary/ai_summary_metadata.dart';
import 'summary/ai_summary_models.dart';
import 'summary/ai_summary_tags.dart';

class AiSummaryCard extends StatefulWidget {
  const AiSummaryCard({
    super.key,
    required this.title,
    this.subtitle,
    this.sections = const <AiSummarySection>[],
    this.badgeLabel = 'AI SUMMARY',
    this.tone = AiSummaryTone.summary,
    this.icon = Icons.summarize_rounded,
    this.category,
    this.model,
    this.timestamp,
    this.readingTime,
    this.wordCount,
    this.tags = const <String>[],
    this.actions,
    this.expanded = false,
    this.canExpand = false,
    this.collapsedMaxLines = 5,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation = 0,
    this.backgroundColor,
    this.borderColor,
    this.gradient,
    this.showBadge = true,
    this.showReadingTime = true,
    this.onTap,
    this.semanticLabel,
  });

  final String title;
  final String? subtitle;
  final List<AiSummarySection> sections;
  final String badgeLabel;
  final AiSummaryTone tone;
  final IconData icon;
  final String? category;
  final String? model;
  final String? timestamp;
  final String? readingTime;
  final String? wordCount;
  final List<String> tags;
  final AiSummaryActions? actions;
  final bool expanded;
  final bool canExpand;
  final int collapsedMaxLines;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double elevation;
  final Color? backgroundColor;
  final Color? borderColor;
  final Gradient? gradient;
  final bool showBadge;
  final bool showReadingTime;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  State<AiSummaryCard> createState() => _AiSummaryCardState();
}

class _AiSummaryCardState extends State<AiSummaryCard>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded = widget.expanded;
  bool _isHovered = false;
  bool _isPressed = false;

  late final AnimationController _expandController = AnimationController(
    vsync: this,
    duration: AiSummaryConstants.expandDuration,
    value: widget.expanded ? 1.0 : 0.0,
  );

  @override
  void didUpdateWidget(covariant AiSummaryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expanded != oldWidget.expanded) {
      _isExpanded = widget.expanded;
      if (_isExpanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    if (!widget.canExpand) return;
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _expandController.forward();
        widget.actions?.onExpandToggle?.call();
      } else {
        _expandController.reverse();
        widget.actions?.onExpandToggle?.call();
      }
    });
  }

  AiSummaryMetadata? _buildMetadata() {
    final hasAny =
        widget.category != null ||
        widget.model != null ||
        widget.timestamp != null ||
        (widget.readingTime != null && widget.showReadingTime) ||
        widget.wordCount != null;
    if (!hasAny) return null;
    return AiSummaryMetadata(
      category: widget.category,
      model: widget.model,
      timestamp: widget.timestamp,
      readingTime: widget.showReadingTime ? widget.readingTime : null,
      wordCount: widget.wordCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color accent = _accentFor(widget.tone);
    final Color resolvedBackground =
        widget.backgroundColor ??
        (isDark
            ? AiSummaryConstants.darkSurface
            : AiSummaryConstants.lightSurface);
    final Color resolvedBorder =
        widget.borderColor ??
        (isDark
            ? AiSummaryConstants.darkBorder
            : AiSummaryConstants.lightBorder);
    final Gradient resolvedGradient =
        widget.gradient ??
        (isDark
            ? AiSummaryConstants.darkGradient
            : AiSummaryConstants.lightGradient);

    final BorderRadius radius =
        widget.borderRadius ??
        BorderRadius.circular(AiSummaryConstants.cardRadius);

    final EdgeInsetsGeometry padding =
        widget.padding ?? _resolvePadding(isDark);

    final List<BoxShadow> shadows =
        _isHovered && (widget.onTap != null || widget.canExpand)
        ? AiSummaryConstants.hoverShadow(accent)
        : AiSummaryConstants.floatingShadow(accent);

    final AiSummaryMetadata? metadata = _buildMetadata();

    final Widget card = AnimatedContainer(
      duration: AiSummaryConstants.hoverDuration,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        gradient: resolvedGradient,
        color: widget.gradient != null ? null : resolvedBackground,
        borderRadius: radius,
        border: Border.all(color: resolvedBorder, width: AppSizes.borderThin),
        boxShadow: widget.elevation == 0 ? shadows : null,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(
                painter: _GlassSheenPainter(accent: accent, isDark: isDark),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: AiSummaryConstants.accentStripWidth,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AiSummaryConstants.accentStripGradient,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: AiSummaryConstants.accentStripWidth,
              ),
              child: Padding(
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AiSummaryHeader(
                      title: widget.title,
                      subtitle: widget.subtitle,
                      icon: widget.icon,
                      badgeLabel: widget.badgeLabel,
                      tone: widget.tone,
                      accent: accent,
                      showBadge: widget.showBadge,
                    ),
                    if (metadata != null) ...<Widget>[
                      const SizedBox(height: AiSummaryConstants.gapMd),
                      AiSummaryMetadataStrip(
                        metadata: metadata,
                        accent: accent,
                      ),
                    ],
                    if (widget.sections.isNotEmpty) ...<Widget>[
                      const SizedBox(height: AiSummaryConstants.gapLg),
                      ClipRect(
                        child: SizeTransition(
                          axis: Axis.vertical,
                          sizeFactor: _expandController,
                          child: AiSummaryBody(
                            sections: widget.sections,
                            accent: accent,
                            tone: widget.tone,
                            isDark: isDark,
                            collapsed: !_isExpanded && widget.canExpand,
                            collapsedMaxLines: widget.collapsedMaxLines,
                          ),
                        ),
                      ),
                    ],
                    if (widget.tags.isNotEmpty) ...<Widget>[
                      const SizedBox(height: AiSummaryConstants.gapMd),
                      AiSummaryTags(tags: widget.tags, accent: accent),
                    ],
                    if (widget.actions != null &&
                        widget.actions!.hasAny) ...<Widget>[
                      const SizedBox(height: AiSummaryConstants.gapMd),
                      AiSummaryFooter(
                        actions: widget.actions!,
                        accent: accent,
                        canExpand: widget.canExpand,
                        isExpanded: _isExpanded,
                        onToggleExpand: _toggleExpanded,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final Widget tappable = (widget.onTap != null || widget.canExpand)
        ? MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTapDown: widget.onTap != null
                  ? (_) => setState(() => _isPressed = true)
                  : null,
              onTapUp: widget.onTap != null
                  ? (_) => setState(() => _isPressed = false)
                  : null,
              onTapCancel: widget.onTap != null
                  ? () => setState(() => _isPressed = false)
                  : null,
              onTap: widget.onTap,
              child: AnimatedScale(
                scale: _isPressed ? 0.985 : (_isHovered ? 1.005 : 1.0),
                duration: AiSummaryConstants.pressDuration,
                curve: Curves.easeOut,
                child: card,
              ),
            ),
          )
        : card;

    final Widget content = Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AiSummaryConstants.maxCardWidth,
        ),
        child: tappable,
      ),
    );

    return Semantics(
      container: true,
      label: widget.semanticLabel ?? 'AI summary: ${widget.title}',
      child: content,
    );
  }

  Color _accentFor(AiSummaryTone tone) {
    switch (tone) {
      case AiSummaryTone.summary:
        return AiSummaryConstants.defaultAccent;
      case AiSummaryTone.brief:
        return AiSummaryConstants.briefAccent;
      case AiSummaryTone.deepDive:
        return AiSummaryConstants.deepDiveAccent;
      case AiSummaryTone.tip:
        return AiSummaryConstants.tipAccent;
      case AiSummaryTone.warning:
        return AiSummaryConstants.warningAccent;
    }
  }

  EdgeInsetsGeometry _resolvePadding(bool isDark) {
    return isDark
        ? AiSummaryConstants.comfortablePadding
        : AiSummaryConstants.compactPadding;
  }
}

class _GlassSheenPainter extends CustomPainter {
  _GlassSheenPainter({required this.accent, required this.isDark});

  final Color accent;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint sheen = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-1, -1),
        radius: 1.2,
        colors: <Color>[
          accent.withValues(alpha: isDark ? 0.18 : 0.1),
          accent.withValues(alpha: 0.0),
        ],
        stops: const <double>[0.0, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), sheen);
  }

  @override
  bool shouldRepaint(covariant _GlassSheenPainter old) =>
      old.accent != accent || old.isDark != isDark;
}
