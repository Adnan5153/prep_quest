import 'package:flutter/material.dart';

import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';
import 'ai_constants.dart';
import 'ai_explanation_constants.dart';
import 'ai_explanation_footer.dart';
import 'ai_explanation_header.dart';

/// A premium, responsive AI Explanation Card used across Prep Quest to
/// surface AI-generated explanations, hints, and insights.
///
/// Renders a glass-inspired surface with a gradient accent strip, an
/// AI-branded header, sectioned body content (text, markdown, lists,
/// code, tips, notes, highlights), and an optional footer action row.
class AiExplanationCard extends StatefulWidget {
  const AiExplanationCard({
    super.key,
    required this.title,
    required this.sections,
    this.subtitle,
    this.icon = Icons.auto_awesome_rounded,
    this.badgeLabel = 'AI INSIGHT',
    this.tone = AiExplanationTone.insight,
    this.timestamp,
    this.showBadge = true,
    this.showActions = true,
    this.footerActions,
    this.expanded = false,
    this.canExpand = false,
    this.collapsedMaxLines = 4,
    this.backgroundColor,
    this.borderColor,
    this.gradient,
    this.semanticLabel,
    this.onTap,
  });

  final String title;
  final List<AiExplanationSection> sections;
  final String? subtitle;
  final IconData icon;
  final String badgeLabel;
  final AiExplanationTone tone;
  final String? timestamp;
  final bool showBadge;
  final bool showActions;
  final AiExplanationFooterActions? footerActions;
  final bool expanded;
  final bool canExpand;
  final int collapsedMaxLines;
  final Color? backgroundColor;
  final Color? borderColor;
  final Gradient? gradient;
  final String? semanticLabel;
  final VoidCallback? onTap;

  @override
  State<AiExplanationCard> createState() => _AiExplanationCardState();
}

class _AiExplanationCardState extends State<AiExplanationCard>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded = widget.expanded;
  bool _isHovered = false;
  bool _isPressed = false;

  late final AnimationController _expandController = AnimationController(
    vsync: this,
    duration: AiExplanationConstants.expandDuration,
    value: widget.expanded ? 1.0 : 0.0,
  );

  @override
  void didUpdateWidget(covariant AiExplanationCard oldWidget) {
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
      } else {
        _expandController.reverse();
      }
      widget.footerActions?.onExpandToggle?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final actions = widget.footerActions;
    final shouldShowFooter =
        widget.showActions && actions != null && actions.hasAny;

    final canTap = widget.onTap != null;
    final canToggleExpand = widget.canExpand && shouldShowFooter;

    return Semantics(
      container: true,
      label: widget.semanticLabel ?? widget.title,
      child: MouseRegion(
        onEnter: (_) {
          if (canTap || canToggleExpand) {
            setState(() => _isHovered = true);
          }
        },
        onExit: (_) {
          if (canTap || canToggleExpand) {
            setState(() => _isHovered = false);
          }
        },
        cursor: canTap || canToggleExpand
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          onTapDown: canTap ? (_) => setState(() => _isPressed = true) : null,
          onTapUp: canTap ? (_) => setState(() => _isPressed = false) : null,
          onTapCancel: canTap ? () => setState(() => _isPressed = false) : null,
          onTap: canTap ? widget.onTap : null,
          child: AnimatedScale(
            scale: _isPressed
                ? 0.985
                : (_isHovered && (canTap || canToggleExpand) ? 1.005 : 1.0),
            duration: AiExplanationConstants.pressDuration,
            curve: Curves.easeOut,
            child: _buildSurface(theme, isDark, actions, shouldShowFooter),
          ),
        ),
      ),
    );
  }

  Widget _buildSurface(
    ThemeData theme,
    bool isDark,
    AiExplanationFooterActions? actions,
    bool shouldShowFooter,
  ) {
    final highlightTone = _toneAccent(widget.tone);

    final defaultGradient = isDark
        ? AiExplanationConstants.darkGradient
        : AiExplanationConstants.lightGradient;

    final surfaceGradient = widget.gradient ?? defaultGradient;

    final borderColor =
        widget.borderColor ??
        (isDark
            ? AiExplanationConstants.darkBorder
            : AiExplanationConstants.lightBorder);

    final restingShadow = AiExplanationConstants.floatingShadow(highlightTone);
    final hoverShadow = AiExplanationConstants.hoverShadow(highlightTone);

    final effectiveShadow =
        (_isHovered && (widget.onTap != null || widget.canExpand))
        ? hoverShadow
        : restingShadow;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact =
            constraints.maxWidth < AiExplanationConstants.compactBreakpoint;

        return Container(
          constraints: const BoxConstraints(
            maxWidth: AiExplanationConstants.maxCardWidth,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AiExplanationConstants.cardRadius,
            ),
            gradient: surfaceGradient,
            border: Border.all(color: borderColor, width: 1.0),
            boxShadow: effectiveShadow,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _GlassSheenPainter(
                    accent: highlightTone,
                    radius: AiExplanationConstants.cardRadius,
                    isDark: isDark,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: AiExplanationConstants.accentStripWidth,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: AiExplanationConstants.accentStripGradient,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: AiExplanationConstants.accentStripWidth,
                ),
                child: Padding(
                  padding: isCompact
                      ? AiExplanationConstants.compactPadding
                      : AiExplanationConstants.comfortablePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AiExplanationHeader(
                        title: widget.title,
                        subtitle: widget.subtitle,
                        icon: widget.icon,
                        badgeLabel: widget.badgeLabel,
                        tone: widget.tone,
                        showBadge: widget.showBadge,
                        timestamp: widget.timestamp,
                      ),
                      const SizedBox(height: AiExplanationConstants.gapLg),
                      SizeTransition(
                        axis: Axis.vertical,
                        sizeFactor: _expandController,
                        child: _BodyRenderer(
                          sections: widget.sections,
                          tone: widget.tone,
                          isDark: isDark,
                        ),
                      ),
                      if (widget.canExpand) ...[
                        const SizedBox(height: AiExplanationConstants.gapSm),
                        _ExpansionToggle(
                          expanded: _isExpanded,
                          tone: widget.tone,
                          onTap: _toggleExpanded,
                        ),
                      ],
                      if (shouldShowFooter) ...[
                        const SizedBox(height: AiExplanationConstants.gapMd),
                        AiExplanationFooter(actions: actions!),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _toneAccent(AiExplanationTone tone) {
    switch (tone) {
      case AiExplanationTone.insight:
        return AiConstants.aiViolet;
      case AiExplanationTone.hint:
        return AiConstants.aiCyan;
      case AiExplanationTone.tip:
        return AiConstants.aiPurple;
      case AiExplanationTone.warning:
        return const Color(0xFFF59E0B);
      case AiExplanationTone.error:
        return const Color(0xFFEF4444);
      case AiExplanationTone.success:
        return const Color(0xFF22C55E);
      case AiExplanationTone.info:
        return const Color(0xFF3B82F6);
    }
  }
}

// ---------------------------------------------------------------------------
// Body rendering
// ---------------------------------------------------------------------------

class _BodyRenderer extends StatelessWidget {
  const _BodyRenderer({
    required this.sections,
    required this.tone,
    required this.isDark,
  });

  final List<AiExplanationSection> sections;
  final AiExplanationTone tone;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < sections.length; i++) ...[
          if (i > 0) const SizedBox(height: AiExplanationConstants.sectionGap),
          _SectionView(section: sections[i], tone: tone, isDark: isDark),
        ],
      ],
    );
  }
}

class _SectionView extends StatelessWidget {
  const _SectionView({
    required this.section,
    required this.tone,
    required this.isDark,
  });

  final AiExplanationSection section;
  final AiExplanationTone tone;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = isDark ? Colors.white : const Color(0xFF1F2937);

    final textBase = theme.textTheme.bodyMedium?.copyWith(
      color: foreground.withValues(alpha: 0.88),
      height: 1.55,
    );

    switch (section) {
      case AiExplanationTextSection s:
        return _MarkdownBlock(
          text: s.text,
          base: textBase,
          foreground: foreground,
        );

      case AiExplanationMarkdownSection s:
        return _MarkdownBlock(
          text: s.source,
          base: textBase,
          foreground: foreground,
        );

      case AiExplanationBulletListSection s:
        return _BulletList(
          items: s.items,
          base: textBase,
          foreground: foreground,
          iconColor: _toneAccent(tone),
        );

      case AiExplanationNumberedListSection s:
        return _NumberedList(
          items: s.items,
          base: textBase,
          foreground: foreground,
        );

      case AiExplanationCodeSection s:
        return _CodeBlock(code: s.code, language: s.language, isDark: isDark);

      case AiExplanationTipSection s:
        return _CalloutBlock(
          icon: Icons.lightbulb_rounded,
          title: s.title ?? 'Tip',
          body: s.body,
          foreground: foreground,
        );

      case AiExplanationNoteSection s:
        return _CalloutBlock(
          icon: Icons.sticky_note_2_rounded,
          title: s.title ?? 'Note',
          body: s.body,
          foreground: foreground,
        );

      case AiExplanationHighlightSection s:
        return _HighlightBlock(
          text: s.text,
          terms: s.terms,
          base: textBase,
          foreground: foreground,
        );
    }
  }

  Color _toneAccent(AiExplanationTone tone) {
    switch (tone) {
      case AiExplanationTone.insight:
        return AiConstants.aiViolet;
      case AiExplanationTone.hint:
        return AiConstants.aiCyan;
      case AiExplanationTone.tip:
        return AiConstants.aiPurple;
      case AiExplanationTone.warning:
        return const Color(0xFFF59E0B);
      case AiExplanationTone.error:
        return const Color(0xFFEF4444);
      case AiExplanationTone.success:
        return const Color(0xFF22C55E);
      case AiExplanationTone.info:
        return const Color(0xFF3B82F6);
    }
  }
}

// ---------------------------------------------------------------------------
// Section content blocks
// ---------------------------------------------------------------------------

class _MarkdownBlock extends StatelessWidget {
  const _MarkdownBlock({
    required this.text,
    required this.base,
    required this.foreground,
  });

  final String text;
  final TextStyle? base;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final paragraphs = _splitParagraphs(text);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final paragraph in paragraphs) ...[
          Text(paragraph, style: base),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }

  List<String> _splitParagraphs(String source) {
    return source
        .split(RegExp(r'\n\s*\n'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({
    required this.items,
    required this.base,
    required this.foreground,
    required this.iconColor,
  });

  final List<String> items;
  final TextStyle? base;
  final Color foreground;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final item in items) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(item, style: base)),
            ],
          ),
          const SizedBox(height: AiExplanationConstants.listItemGap),
        ],
      ],
    );
  }
}

class _NumberedList extends StatelessWidget {
  const _NumberedList({
    required this.items,
    required this.base,
    required this.foreground,
  });

  final List<String> items;
  final TextStyle? base;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 22,
                height: 22,
                margin: const EdgeInsets.only(top: 2),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: foreground.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${i + 1}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: foreground,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(items[i], style: base)),
            ],
          ),
          const SizedBox(height: AiExplanationConstants.listItemGap),
        ],
      ],
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({
    required this.code,
    required this.language,
    required this.isDark,
  });

  final String code;
  final String? language;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = isDark
        ? const Color(0xFF0B0F14)
        : const Color(0xFFF1F2F6);
    final foreground = isDark
        ? const Color(0xFFE4E7EB)
        : const Color(0xFF1F2937);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: foreground.withValues(alpha: 0.08),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (language != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                language!.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: foreground.withValues(alpha: 0.55),
                  letterSpacing: 0.8,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          SelectableText(
            code,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: foreground,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalloutBlock extends StatelessWidget {
  const _CalloutBlock({
    required this.icon,
    required this.title,
    required this.body,
    required this.foreground,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: foreground.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(
          AiExplanationConstants.sectionRadius,
        ),
        border: Border.all(
          color: foreground.withValues(alpha: 0.12),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: foreground),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: foreground,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  body,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: foreground.withValues(alpha: 0.85),
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightBlock extends StatelessWidget {
  const _HighlightBlock({
    required this.text,
    required this.terms,
    required this.base,
    required this.foreground,
  });

  final String text;
  final List<String> terms;
  final TextStyle? base;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final spans = _highlightSpans();
    return RichText(
      text: TextSpan(style: base, children: spans),
    );
  }

  List<TextSpan> _highlightSpans() {
    if (terms.isEmpty) {
      return <TextSpan>[TextSpan(text: text)];
    }

    final result = <TextSpan>[];
    final pattern = RegExp(
      terms.map(RegExp.escape).join('|'),
      caseSensitive: false,
    );

    int last = 0;
    for (final match in pattern.allMatches(text)) {
      if (match.start > last) {
        result.add(TextSpan(text: text.substring(last, match.start)));
      }
      result.add(
        TextSpan(
          text: match.group(0),
          style: TextStyle(
            color: foreground,
            fontWeight: FontWeight.w700,
            backgroundColor: foreground.withValues(alpha: 0.08),
          ),
        ),
      );
      last = match.end;
    }
    if (last < text.length) {
      result.add(TextSpan(text: text.substring(last)));
    }
    return result;
  }
}

// ---------------------------------------------------------------------------
// Expansion toggle
// ---------------------------------------------------------------------------

class _ExpansionToggle extends StatelessWidget {
  const _ExpansionToggle({
    required this.expanded,
    required this.tone,
    required this.onTap,
  });

  final bool expanded;
  final AiExplanationTone tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final foreground = isDark ? Colors.white : const Color(0xFF1F2937);

    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedRotation(
                turns: expanded ? 0.5 : 0.0,
                duration: AiExplanationConstants.expandDuration,
                child: Icon(
                  Icons.expand_more_rounded,
                  size: 18,
                  color: foreground.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                expanded ? 'Show less' : 'Show more',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: foreground.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Decorative painter
// ---------------------------------------------------------------------------

class _GlassSheenPainter extends CustomPainter {
  _GlassSheenPainter({
    required this.accent,
    required this.radius,
    required this.isDark,
  });

  final Color accent;
  final double radius;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final sheen = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-1, -1),
        radius: 1.2,
        colors: <Color>[
          accent.withValues(alpha: isDark ? 0.18 : 0.10),
          accent.withValues(alpha: 0.0),
        ],
        stops: const <double>[0.0, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ),
    );
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), sheen);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GlassSheenPainter old) =>
      old.accent != accent || old.isDark != isDark;
}

// ---------------------------------------------------------------------------
// Section model — sealed class for type-safe polymorphic rendering
// ---------------------------------------------------------------------------

sealed class AiExplanationSection {
  const AiExplanationSection();
}

class AiExplanationTextSection extends AiExplanationSection {
  const AiExplanationTextSection(this.text);
  final String text;
}

class AiExplanationMarkdownSection extends AiExplanationSection {
  const AiExplanationMarkdownSection(this.source);
  final String source;
}

class AiExplanationBulletListSection extends AiExplanationSection {
  const AiExplanationBulletListSection(this.items);
  final List<String> items;
}

class AiExplanationNumberedListSection extends AiExplanationSection {
  const AiExplanationNumberedListSection(this.items);
  final List<String> items;
}

class AiExplanationCodeSection extends AiExplanationSection {
  const AiExplanationCodeSection({required this.code, this.language});
  final String code;
  final String? language;
}

class AiExplanationTipSection extends AiExplanationSection {
  const AiExplanationTipSection({required this.body, this.title});
  final String body;
  final String? title;
}

class AiExplanationNoteSection extends AiExplanationSection {
  const AiExplanationNoteSection({required this.body, this.title});
  final String body;
  final String? title;
}

class AiExplanationHighlightSection extends AiExplanationSection {
  const AiExplanationHighlightSection({
    required this.text,
    required this.terms,
  });
  final String text;
  final List<String> terms;
}
