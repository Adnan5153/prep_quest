/// Public re-exports for the AI response card subsystem.
///
/// Consumers can import this single file to access the public API:
///
/// ```dart
/// import 'package:prep_quest/core/widgets/ai/ai_response_card.dart';
/// ```
///
/// The card itself is exported as [AiResponseCard]; the supporting
/// models and types live alongside it so callers don't have to memorise
/// the internal file layout under `response/`.
library;

export 'response/ai_response_actions.dart';
export 'response/ai_response_badge.dart';
export 'response/ai_response_body.dart';
export 'response/ai_response_constants.dart';
export 'response/ai_response_footer.dart';
export 'response/ai_response_header.dart';
export 'response/ai_response_markdown.dart';
export 'response/ai_response_metadata.dart';
export 'response/ai_response_models.dart';

import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import 'response/ai_response_body.dart';
import 'response/ai_response_constants.dart';
import 'response/ai_response_footer.dart';
import 'response/ai_response_header.dart';
import 'response/ai_response_metadata.dart';
import 'response/ai_response_models.dart';

/// A generic, production-ready AI response card reusable across every AI
/// surface in Prep Quest — AI Tutor, AI Chat, AI Exam Simulator, AI
/// Prompt Studio, AI Summary, AI Hint, AI Explanation, AI Analysis,
/// AI Recommendation, and any future AI module.
///
/// `AiResponseCard` is the *envelope*: it owns the surface chrome, the
/// header (avatar + title + subtitle + badge), the response body
/// (plain text or lightweight markdown), an optional metadata strip
/// (model, time, category, confidence, status), and an optional action
/// footer (copy / share / regenerate / favorite / like / dislike /
/// expand). It deliberately knows nothing about quizzes, exams,
/// prompts, or chat sessions — every concern is parameterised.
class AiResponseCard extends StatefulWidget {
  const AiResponseCard({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.responseType = AiResponseType.generic,
    this.icon = Icons.auto_awesome_rounded,
    this.badgeLabel,
    this.accentColor,
    this.leading,
    this.trailing,
    this.metadata,
    this.actions,
    this.markdown = false,
    this.selectable = false,
    this.maxLines,
    this.collapsedMaxLines = 4,
    this.canExpand = false,
    this.expanded = false,
    this.showBadge = true,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation = 0,
    this.backgroundColor,
    this.borderColor,
    this.gradient,
    this.semanticLabel,
  });

  // ---------------------------------------------------------------------------
  // Content
  // ---------------------------------------------------------------------------

  /// Required header title (e.g. "AI Tutor", "Hint", "Analysis").
  final String title;

  /// Response body text. Rendered as markdown when [markdown] is `true`.
  final String body;

  /// Optional supporting line beneath the header title.
  final String? subtitle;

  /// Response type — drives the default badge label and accent palette.
  final AiResponseType responseType;

  /// Default icon for the avatar tile. Ignored when [leading] is set.
  final IconData icon;

  /// Optional override for the badge label.
  final String? badgeLabel;

  /// Optional accent override applied to both the badge and avatar tile.
  final Color? accentColor;

  /// Optional leading widget — when supplied, replaces the default
  /// gradient avatar tile.
  final Widget? leading;

  /// Optional trailing widget placed at the far right of the header.
  final Widget? trailing;

  // ---------------------------------------------------------------------------
  // Metadata & actions
  // ---------------------------------------------------------------------------

  /// Inline metadata displayed beneath the body (model, timestamp,
  /// category, confidence, status). When `null`, the strip is hidden.
  final AiResponseMetadata? metadata;

  /// Footer actions (copy / share / regenerate / favorite / like /
  /// dislike / expand). When `null` or empty, the footer is hidden.
  final AiResponseActions? actions;

  // ---------------------------------------------------------------------------
  // Layout
  // ---------------------------------------------------------------------------

  /// When `true`, [body] is rendered through a lightweight markdown
  /// renderer. Defaults to plain text.
  final bool markdown;

  /// When `true`, the body is rendered through [SelectableText] so the
  /// user can copy a substring via long-press.
  final bool selectable;

  /// Optional max-line cap for the body. When `null`, the body grows
  /// to fit its content.
  final int? maxLines;

  /// Max-line cap applied to the body when the card is collapsed.
  /// Has no effect unless [canExpand] is `true` and [expanded] is
  /// `false`. Defaults to 4.
  final int collapsedMaxLines;

  /// When `true`, the card shows an expand/collapse action in the
  /// footer (provided [actions.onExpandToggle] is supplied).
  final bool canExpand;

  /// When `true`, the body is rendered at full height. The card
  /// animates between [collapsedMaxLines] and [maxLines] (or full
  /// height when [maxLines] is `null`) when this flips.
  final bool expanded;

  /// When `false`, hides the badge entirely.
  final bool showBadge;

  /// Optional tap handler — makes the entire card tappable (e.g. to
  /// open a detail screen).
  final VoidCallback? onTap;

  // ---------------------------------------------------------------------------
  // Visual overrides
  // ---------------------------------------------------------------------------

  /// Optional inner padding override. Defaults to a comfortable padding
  /// on tablet+ and a compact padding on phones.
  final EdgeInsetsGeometry? padding;

  /// Optional outer margin override.
  final EdgeInsetsGeometry? margin;

  /// Optional outer radius override.
  final BorderRadius? borderRadius;

  /// Card elevation. Defaults to 0 (flat).
  final double elevation;

  /// Optional background colour override. Ignored when [gradient] is
  /// supplied.
  final Color? backgroundColor;

  /// Optional border colour override.
  final Color? borderColor;

  /// Optional gradient override for the card background.
  final Gradient? gradient;

  /// Optional semantics label override.
  final String? semanticLabel;

  @override
  State<AiResponseCard> createState() => _AiResponseCardState();
}

class _AiResponseCardState extends State<AiResponseCard>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded = widget.expanded;
  bool _isHovered = false;
  bool _isPressed = false;

  late final AnimationController _expandController;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: AiResponseConstants.expandDuration,
      value: widget.expanded ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant AiResponseCard oldWidget) {
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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color resolvedBackground =
        widget.backgroundColor ??
        (isDark
            ? AiResponseConstants.darkSurface
            : AiResponseConstants.lightSurface);
    final Color resolvedBorder =
        widget.borderColor ??
        (isDark
            ? AiResponseConstants.darkBorder
            : AiResponseConstants.lightBorder);
    final Gradient resolvedGradient =
        widget.gradient ??
        (isDark
            ? AiResponseConstants.darkGradient
            : AiResponseConstants.lightGradient);

    final BorderRadius radius =
        widget.borderRadius ??
        BorderRadius.circular(AiResponseConstants.cardRadius);

    final int? effectiveMaxLines = widget.canExpand && !_isExpanded
        ? (widget.maxLines != null
              ? (widget.collapsedMaxLines < widget.maxLines!
                    ? widget.collapsedMaxLines
                    : widget.maxLines)
              : widget.collapsedMaxLines)
        : widget.maxLines;

    final EdgeInsetsGeometry padding =
        widget.padding ?? _resolvePadding(isDark);

    final List<BoxShadow> shadows = _isHovered
        ? AiResponseConstants.hoverShadow(resolvedBorder)
        : AiResponseConstants.floatingShadow(resolvedBorder);

    final Widget card = AnimatedContainer(
      duration: AiResponseConstants.hoverDuration,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        gradient: resolvedGradient,
        color: widget.gradient != null ? null : resolvedBackground,
        borderRadius: radius,
        border: Border.all(color: resolvedBorder, width: AppSizes.borderThin),
        boxShadow: widget.elevation == 0 ? shadows : null,
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AiResponseHeader(
              title: widget.title,
              subtitle: widget.subtitle,
              leading: widget.leading,
              trailing: widget.trailing,
              icon: widget.icon,
              badgeLabel: widget.badgeLabel,
              responseType: widget.responseType,
              accentColor: widget.accentColor,
              showBadge: widget.showBadge,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildBody(effectiveMaxLines),
            if (widget.metadata != null) ...<Widget>[
              const SizedBox(height: AiResponseConstants.gapMd),
              AiResponseMetadataStrip(metadata: widget.metadata),
            ],
            if (widget.actions != null) ...<Widget>[
              const SizedBox(height: AiResponseConstants.gapSm),
              AiResponseFooter(actions: widget.actions!),
            ],
          ],
        ),
      ),
    );

    final Widget tappableCard = widget.onTap != null || widget.canExpand
        ? _TappableCard(
            onTap: widget.onTap,
            onExpandToggle: widget.canExpand ? _toggleExpanded : null,
            isPressed: _isPressed,
            onHoverChanged: (bool hovered) {
              if (hovered == _isHovered) return;
              setState(() => _isHovered = hovered);
            },
            onPressChanged: (bool pressed) {
              if (pressed == _isPressed) return;
              setState(() => _isPressed = pressed);
            },
            child: card,
          )
        : card;

    final Widget content = Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AiResponseConstants.maxCardWidth,
        ),
        child: tappableCard,
      ),
    );

    return Semantics(
      label: widget.semanticLabel ?? 'AI ${widget.title}',
      container: true,
      child: content,
    );
  }

  Widget _buildBody(int? maxLines) {
    return AiResponseBody(
      text: widget.body,
      markdown: widget.markdown,
      selectable: widget.selectable,
      maxLines: maxLines,
    );
  }

  EdgeInsetsGeometry _resolvePadding(bool isDark) {
    return isDark
        ? AiResponseConstants.comfortablePadding
        : AiResponseConstants.compactPadding;
  }
}

/// Wraps the card in a hover/press aware [Material] + [InkWell] so the
/// whole surface responds to pointer events. AnimatedScale adds a tiny
/// press feedback without disrupting layout.
class _TappableCard extends StatefulWidget {
  const _TappableCard({
    required this.child,
    required this.onHoverChanged,
    required this.onPressChanged,
    this.onTap,
    this.onExpandToggle,
    this.isPressed = false,
  });

  final Widget child;
  final ValueChanged<bool> onHoverChanged;
  final ValueChanged<bool> onPressChanged;
  final VoidCallback? onTap;
  final VoidCallback? onExpandToggle;
  final bool isPressed;

  @override
  State<_TappableCard> createState() => _TappableCardState();
}

class _TappableCardState extends State<_TappableCard> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => widget.onHoverChanged(true),
      onExit: (_) => widget.onHoverChanged(false),
      child: Listener(
        onPointerDown: (_) => widget.onPressChanged(true),
        onPointerUp: (_) => widget.onPressChanged(false),
        onPointerCancel: (_) => widget.onPressChanged(false),
        child: AnimatedScale(
          scale: widget.isPressed ? 0.985 : 1.0,
          duration: AiResponseConstants.pressDuration,
          curve: Curves.easeOut,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap ?? widget.onExpandToggle,
              borderRadius: BorderRadius.circular(
                AiResponseConstants.cardRadius,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
