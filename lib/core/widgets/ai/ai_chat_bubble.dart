import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import 'ai_constants.dart';

/// The conversation roles supported by [AiChatBubble].
enum AiBubbleRole {
  /// AI-generated content (left aligned).
  ai,

  /// User-authored content (right aligned).
  user,

  /// System notification (centred, low-emphasis).
  system,
}

/// The visual style applied to a single [AiChatBubble].
enum AiBubbleStyle {
  /// Soft frosted-glass capsule (default for AI & system bubbles).
  glass,

  /// Solid vibrant gradient (default for user bubbles).
  gradient,

  /// Flat solid surface — minimal / focused mode.
  flat,

  /// Outlined capsule with transparent fill.
  outlined,
}

/// The semantic state of the message rendered inside the bubble.
enum AiBubbleState {
  /// A finalized response.
  staticResponse,

  /// The model is currently producing tokens.
  streaming,

  /// The model acknowledged the prompt and is "thinking".
  thinking,

  /// The model is producing a typing indicator (no text yet).
  typing,

  /// Something went wrong delivering the response.
  error,
}

/// The set of optional metadata slots exposed by [AiChatBubble.header].
class AiBubbleHeaderData {
  const AiBubbleHeaderData({
    this.title = 'Prep Quest AI',
    this.modelLabel,
    this.timestamp,
    this.verified = true,
  });

  /// AI display name (e.g. "Prep Quest AI").
  final String title;

  /// Optional model badge ("GPT-4o", "Gemini", etc.).
  final String? modelLabel;

  /// Optional human-readable timestamp ("just now", "09:14", ...).
  final String? timestamp;

  /// When `true` the avatar is decorated with a verified tick.
  final bool verified;
}

/// Footer callbacks. Every callback is optional — passing `null`
/// removes the corresponding action from the rendered row.
class AiBubbleFooterData {
  const AiBubbleFooterData({
    this.onCopy,
    this.onShare,
    this.onSpeak,
    this.onRegenerate,
    this.onHelpful,
    this.onNotHelpful,
    this.helpfulSelected,
    this.notHelpfulSelected,
  });

  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final VoidCallback? onSpeak;
  final VoidCallback? onRegenerate;
  final VoidCallback? onHelpful;
  final VoidCallback? onNotHelpful;

  /// When non-null the "helpful" pill renders in a selected state.
  final bool? helpfulSelected;

  /// When non-null the "not helpful" pill renders in a selected state.
  final bool? notHelpfulSelected;
}

/// A premium, glass-capsule chat bubble built specifically for Prep Quest's
/// AI surfaces.
///
/// The widget is theme-aware, accessible, responsive and ready for use
/// in any AI-powered feature (tutor, prompt assistant, history list,
/// streaming response, etc.). It supports:
///
/// - Three roles (AI / user / system)
/// - Four visual styles (glass / gradient / flat / outlined)
/// - Five semantic states (static / streaming / thinking / typing / error)
/// - Optional header (avatar + name + verified badge + timestamp + model)
/// - Optional footer (copy / share / speak / regenerate / helpful / not)
/// - Markdown-friendly content via [markdownContent]
/// - Markdown-light content via [child]
/// - Streaming text via [streamingBuilder]
/// - Smooth enter animation (fade + slide)
/// - Hover & press feedback (mouse + touch)
class AiChatBubble extends StatefulWidget {
  const AiChatBubble({
    super.key,
    this.role = AiBubbleRole.ai,
    this.style,
    this.state = AiBubbleState.staticResponse,
    this.message,
    this.richMessage,
    this.markdownContent,
    this.child,
    this.streamingBuilder,
    this.header,
    this.footer,
    this.footerVisible = true,
    this.headerVisible = true,
    this.maxWidth,
    this.onTap,
    this.onLongPress,
    this.densePadding = false,
    this.enableGlow = true,
    this.enableStreamingAnimation = true,
    this.enterAnimationDuration,
  }) : assert(
         message != null ||
             richMessage != null ||
             markdownContent != null ||
             child != null ||
             streamingBuilder != null,
         'AiChatBubble requires at least one of: message, richMessage, '
         'markdownContent, child or streamingBuilder.',
       );

  /// Conversation role of this bubble.
  final AiBubbleRole role;

  /// Visual style override. Defaults to a role-aware sensible value.
  final AiBubbleStyle? style;

  /// Semantic state of the message.
  final AiBubbleState state;

  /// Plain string message. Rendered as body text.
  final String? message;

  /// Optional rich-text list used in place of [message].
  final List<InlineSpan>? richMessage;

  /// Optional markdown string. When provided, [markdownContent] is rendered
  /// with light-weight parsing (headings, lists, code, links, inline icons).
  final String? markdownContent;

  /// Custom content widget — used for fully bespoke content such as rich
  /// tables, code playgrounds or image grids. Wins over [message],
  /// [richMessage] and [markdownContent] when provided.
  final Widget? child;

  /// Builder used while [state] is [AiBubbleState.streaming]. Receives the
  /// currently displayed text chunk so callers can build their own
  /// shimmer/typewriter overlay.
  final Widget Function(BuildContext context, String chunk)? streamingBuilder;

  /// Optional header configuration. Ignored when [headerVisible] is `false`
  /// or [role] is [AiBubbleRole.system].
  final AiBubbleHeaderData? header;

  /// Optional footer with actions.
  final AiBubbleFooterData? footer;

  /// When `false` the footer row is hidden entirely.
  final bool footerVisible;

  /// When `false` the header row is hidden (system messages use this too).
  final bool headerVisible;

  /// Optional maximum bubble width override.
  final double? maxWidth;

  /// Tap callback — typically used for selection in long lists.
  final VoidCallback? onTap;

  /// Long-press callback.
  final VoidCallback? onLongPress;

  /// When `true` the internal padding is reduced — useful inside dense
  /// history lists.
  final bool densePadding;

  /// When `true` an accent glow is rendered under the bubble.
  final bool enableGlow;

  /// When `true` a subtle progress shimmer animates inside the bubble while
  /// [state] is [AiBubbleState.streaming] or [AiBubbleState.thinking].
  final bool enableStreamingAnimation;

  /// Override the enter animation duration. Defaults to
  /// [AiConstants.normalDuration].
  final Duration? enterAnimationDuration;

  // ---------------------------------------------------------------------------
  // Convenience factories
  // ---------------------------------------------------------------------------

  /// Creates a user-authored bubble.
  factory AiChatBubble.user({
    Key? key,
    required String message,
    List<InlineSpan>? richMessage,
    String? markdownContent,
    Widget? child,
    VoidCallback? onEdit,
    AiBubbleState state = AiBubbleState.staticResponse,
    double? maxWidth,
  }) {
    return AiChatBubble(
      key: key,
      role: AiBubbleRole.user,
      style: AiBubbleStyle.gradient,
      state: state,
      message: message,
      richMessage: richMessage,
      markdownContent: markdownContent,
      maxWidth: maxWidth,
      footer: onEdit == null ? null : AiBubbleFooterData(onCopy: onEdit),
      child: child,
    );
  }

  /// Creates an AI-authored bubble.
  factory AiChatBubble.ai({
    Key? key,
    required String? message,
    List<InlineSpan>? richMessage,
    String? markdownContent,
    Widget? child,
    AiBubbleHeaderData? header,
    AiBubbleFooterData? footer,
    AiBubbleState state = AiBubbleState.staticResponse,
    double? maxWidth,
  }) {
    return AiChatBubble(
      key: key,
      role: AiBubbleRole.ai,
      style: AiBubbleStyle.glass,
      state: state,
      message: message,
      richMessage: richMessage,
      markdownContent: markdownContent,
      header: header,
      footer: footer,
      maxWidth: maxWidth,
      child: child,
    );
  }

  @override
  State<AiChatBubble> createState() => _AiChatBubbleState();
}

class _AiChatBubbleState extends State<AiChatBubble>
    with TickerProviderStateMixin {
  late final AnimationController _enterController;
  late final AnimationController _glowController;
  late final AnimationController _streamingController;
  late final Animation<double> _enterFade;
  late final Animation<Offset> _enterSlide;

  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _enterController = AnimationController(
      vsync: this,
      duration: widget.enterAnimationDuration ?? AiConstants.normalDuration,
    );
    _enterFade = CurvedAnimation(
      parent: _enterController,
      curve: Curves.easeOutCubic,
    );
    _enterSlide =
        Tween<Offset>(
          begin: widget.role == AiBubbleRole.user
              ? const Offset(0, 0.08)
              : const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _enterController, curve: Curves.easeOutCubic),
        );

    _glowController = AnimationController(
      vsync: this,
      duration: AiConstants.breathingDuration,
    )..repeat(reverse: true);

    _streamingController = AnimationController(
      vsync: this,
      duration: AiConstants.streamingDuration,
    );

    _enterController.forward();
    if (widget.state == AiBubbleState.streaming ||
        widget.state == AiBubbleState.thinking) {
      _streamingController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AiChatBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      if (widget.state == AiBubbleState.streaming ||
          widget.state == AiBubbleState.thinking) {
        if (!_streamingController.isAnimating) {
          _streamingController.repeat();
        }
      } else {
        _streamingController.stop();
        _streamingController.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _enterController.dispose();
    _glowController.dispose();
    _streamingController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Effective style resolution
  // ---------------------------------------------------------------------------

  AiBubbleStyle get _effectiveStyle {
    if (widget.style != null) return widget.style!;
    switch (widget.role) {
      case AiBubbleRole.user:
        return AiBubbleStyle.gradient;
      case AiBubbleRole.ai:
        return AiBubbleStyle.glass;
      case AiBubbleRole.system:
        return AiBubbleStyle.flat;
    }
  }

  bool get _isUser => widget.role == AiBubbleRole.user;
  bool get _isSystem => widget.role == AiBubbleRole.system;
  bool get _isStreaming =>
      widget.state == AiBubbleState.streaming ||
      widget.state == AiBubbleState.thinking;
  bool get _isError => widget.state == AiBubbleState.error;
  bool get _isTyping => widget.state == AiBubbleState.typing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final BorderRadius radius = BorderRadius.circular(
      AiConstants.capsuleRadius,
    );

    final Color accent = _resolveAccent(isDark);
    final EdgeInsets padding = widget.densePadding
        ? const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          )
        : const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          );

    final Widget content = _buildSurface(
      theme: theme,
      isDark: isDark,
      accent: accent,
      radius: radius,
      padding: padding,
    );

    final Widget animated = AnimatedBuilder(
      animation: _enterController,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: _enterFade.value.clamp(0.0, 1.0),
          child: Transform.translate(offset: _enterSlide.value, child: child),
        );
      },
      child: content,
    );

    if (_isSystem) {
      return Semantics(
        container: true,
        label: widget.message ?? 'System notification',
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Center(child: animated),
        ),
      );
    }

    final Widget aligned = Align(
      alignment: _isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.maxWidth ?? AiConstants.maxBubbleWidth,
        ),
        child: animated,
      ),
    );

    return Semantics(
      container: true,
      label: _semanticLabel(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: aligned,
      ),
    );
  }

  String _semanticLabel() {
    final StringBuffer buffer = StringBuffer();
    switch (widget.role) {
      case AiBubbleRole.ai:
        buffer.write('AI message');
        break;
      case AiBubbleRole.user:
        buffer.write('Your message');
        break;
      case AiBubbleRole.system:
        buffer.write('System notification');
        break;
    }
    if (widget.message != null && widget.message!.isNotEmpty) {
      buffer.write(': ');
      buffer.write(widget.message);
    } else if (widget.markdownContent != null) {
      buffer.write(': ');
      buffer.write(widget.markdownContent);
    }
    return buffer.toString();
  }

  // ---------------------------------------------------------------------------
  // Surface (the actual capsule)
  // ---------------------------------------------------------------------------

  Widget _buildSurface({
    required ThemeData theme,
    required bool isDark,
    required Color accent,
    required BorderRadius radius,
    required EdgeInsets padding,
  }) {
    final List<BoxShadow>? shadows = _resolveShadows(accent, isDark);

    final Color borderColor = _resolveBorderColor(accent, isDark);

    final Widget body = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: _effectiveStyle == AiBubbleStyle.glass && !_isUser
            ? ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14)
            : ui.ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
        child: AnimatedContainer(
          duration: AiConstants.fastDuration,
          padding: padding,
          decoration: BoxDecoration(
            color: _resolveBackground(theme, accent, isDark),
            gradient: _resolveGradient(isDark),
            borderRadius: radius,
            border: Border.all(color: borderColor, width: AppSizes.borderThin),
            boxShadow: shadows,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.headerVisible && !_isSystem)
                _buildHeader(theme, accent, isDark),
              if (widget.headerVisible && !_isSystem)
                const SizedBox(height: AppSpacing.sm),
              _buildContent(theme, isDark, accent),
              if (widget.footerVisible && widget.footer != null && !_isSystem)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: _buildFooter(theme, isDark),
                ),
            ],
          ),
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) {
        if (mounted && widget.onTap != null) {
          setState(() => _isHovered = true);
        }
      },
      onExit: (_) {
        if (mounted && widget.onTap != null) {
          setState(() => _isHovered = false);
        }
      },
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: (_) {
          if (mounted && widget.onTap != null) {
            setState(() => _isPressed = true);
          }
        },
        onTapUp: (_) {
          if (mounted && widget.onTap != null) {
            setState(() => _isPressed = false);
          }
        },
        onTapCancel: () {
          if (mounted && widget.onTap != null) {
            setState(() => _isPressed = false);
          }
        },
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: AnimatedScale(
          scale: _isPressed ? 0.985 : (_isHovered ? 1.005 : 1.0),
          duration: AiConstants.fastDuration,
          curve: Curves.easeOutCubic,
          child: body,
        ),
      ),
    );
  }

  Color _resolveAccent(bool isDark) {
    if (_isError) return AiConstants.aiRose;
    if (_isStreaming && widget.enableStreamingAnimation) {
      return AiConstants.aiCyan;
    }
    return AiConstants.aiViolet;
  }

  Color _resolveBackground(ThemeData theme, Color accent, bool isDark) {
    switch (_effectiveStyle) {
      case AiBubbleStyle.glass:
        return (_isUser
                ? (isDark
                      ? AiConstants.userBubbleTintDark
                      : AiConstants.userBubbleTintLight)
                : (isDark
                      ? AiConstants.aiBubbleTintDark
                      : AiConstants.aiBubbleTintLight))
            .withValues(alpha: isDark ? 0.78 : 0.82);
      case AiBubbleStyle.flat:
        return isDark ? AppColors.darkSurface : AppColors.lightSurface;
      case AiBubbleStyle.outlined:
        return Colors.transparent;
      case AiBubbleStyle.gradient:
        return Colors.transparent;
    }
  }

  Gradient? _resolveGradient(bool isDark) {
    switch (_effectiveStyle) {
      case AiBubbleStyle.gradient:
        if (_isError) {
          return const LinearGradient(
            colors: <Color>[Color(0xFFF43F5E), Color(0xFFB91C1C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
        }
        return _isUser ? AiConstants.userGradient : AiConstants.userGradient;
      case AiBubbleStyle.glass:
        return isDark
            ? AiConstants.aiGlassGradientDark
            : AiConstants.aiGlassGradient;
      case AiBubbleStyle.flat:
      case AiBubbleStyle.outlined:
        return null;
    }
  }

  Color _resolveBorderColor(Color accent, bool isDark) {
    switch (_effectiveStyle) {
      case AiBubbleStyle.glass:
        return accent.withValues(alpha: isDark ? 0.45 : 0.35);
      case AiBubbleStyle.outlined:
        return accent.withValues(alpha: 0.6);
      case AiBubbleStyle.gradient:
        return Colors.transparent;
      case AiBubbleStyle.flat:
        return accent.withValues(alpha: 0.25);
    }
  }

  List<BoxShadow>? _resolveShadows(Color accent, bool isDark) {
    if (!widget.enableGlow || _isSystem) {
      return <BoxShadow>[
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
          blurRadius: 18,
          spreadRadius: -6,
          offset: const Offset(0, 8),
        ),
      ];
    }
    if (_isStreaming && widget.enableStreamingAnimation) {
      return AiConstants.streamingGlow(accent);
    }
    if (_isError) return AiConstants.errorGlow();
    return AiConstants.floatingShadow(accent);
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _buildHeader(ThemeData theme, Color accent, bool isDark) {
    final AiBubbleHeaderData? data = widget.header;
    final Color foreground = _resolveForeground(theme, isDark);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _Avatar(role: widget.role, accent: accent, header: data),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      data?.title ?? (_isUser ? 'You' : 'Prep Quest AI'),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: foreground,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (data?.verified ?? (!_isUser && !_isSystem))
                    Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.xs),
                      child: _VerifiedBadge(
                        color: accent,
                        foreground: foreground,
                      ),
                    ),
                  if (data?.modelLabel != null) ...<Widget>[
                    const SizedBox(width: AppSpacing.xs),
                    _ModelBadge(label: data!.modelLabel!, accent: accent),
                  ],
                ],
              ),
              if (data?.timestamp != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    data!.timestamp!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: foreground.withValues(alpha: 0.65),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Color _resolveForeground(ThemeData theme, bool isDark) {
    if (_effectiveStyle == AiBubbleStyle.gradient || _isUser) {
      return Colors.white;
    }
    return isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
  }

  // ---------------------------------------------------------------------------
  // Content
  // ---------------------------------------------------------------------------

  Widget _buildContent(ThemeData theme, bool isDark, Color accent) {
    if (_isTyping) {
      return _TypingContent(
        accent: accent,
        foreground: _resolveForeground(theme, isDark),
      );
    }

    if (widget.child != null) {
      return DefaultTextStyle.merge(
        style: _baseTextStyle(theme, isDark),
        child: widget.child!,
      );
    }

    if (widget.streamingBuilder != null && _isStreaming) {
      return widget.streamingBuilder!(context, widget.message ?? '');
    }

    final Color foreground = _resolveForeground(theme, isDark);
    final TextStyle baseStyle = _baseTextStyle(
      theme,
      isDark,
    ).copyWith(color: foreground);

    Widget content;
    if (widget.richMessage != null) {
      content = Text.rich(
        TextSpan(children: widget.richMessage!),
        style: baseStyle,
      );
    } else if (widget.markdownContent != null) {
      content = _MarkdownLight(
        source: widget.markdownContent!,
        baseStyle: baseStyle,
        accent: accent,
      );
    } else {
      content = Text(widget.message ?? '', style: baseStyle);
    }

    final Widget inline = DefaultTextStyle.merge(
      style: baseStyle,
      child: content,
    );

    if (_isStreaming && widget.enableStreamingAnimation) {
      return Stack(
        children: <Widget>[
          inline,
          Positioned.fill(
            child: IgnorePointer(
              child: _ShimmerOverlay(
                controller: _streamingController,
                accent: accent,
              ),
            ),
          ),
        ],
      );
    }

    if (widget.state == AiBubbleState.thinking) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          inline,
          const SizedBox(height: AppSpacing.sm),
          _ThinkingTrails(
            controller: _streamingController,
            accent: accent,
            foreground: foreground,
          ),
        ],
      );
    }

    return inline;
  }

  TextStyle _baseTextStyle(ThemeData theme, bool isDark) {
    return theme.textTheme.bodyMedium?.copyWith(height: 1.45, fontSize: 14.5) ??
        const TextStyle(height: 1.45, fontSize: 14.5);
  }

  // ---------------------------------------------------------------------------
  // Footer
  // ---------------------------------------------------------------------------

  Widget _buildFooter(ThemeData theme, bool isDark) {
    final AiBubbleFooterData data = widget.footer!;
    final Color foreground = _resolveForeground(theme, isDark);
    final double iconSize = AppSizes.iconSm;

    final List<_FooterAction> actions = <_FooterAction>[];

    if (data.onCopy != null) {
      actions.add(
        _FooterAction(
          icon: Icons.copy_rounded,
          label: 'Copy',
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: _resolveCopyPayload()));
            HapticFeedback.selectionClick();
            data.onCopy?.call();
          },
          foreground: foreground,
        ),
      );
    }
    if (data.onShare != null) {
      actions.add(
        _FooterAction(
          icon: Icons.ios_share_rounded,
          label: 'Share',
          onTap: () {
            HapticFeedback.selectionClick();
            data.onShare?.call();
          },
          foreground: foreground,
        ),
      );
    }
    if (data.onSpeak != null) {
      actions.add(
        _FooterAction(
          icon: Icons.volume_up_rounded,
          label: 'Speak',
          onTap: () {
            HapticFeedback.selectionClick();
            data.onSpeak?.call();
          },
          foreground: foreground,
        ),
      );
    }
    if (data.onRegenerate != null) {
      actions.add(
        _FooterAction(
          icon: Icons.refresh_rounded,
          label: 'Regenerate',
          onTap: () {
            HapticFeedback.selectionClick();
            data.onRegenerate?.call();
          },
          foreground: foreground,
        ),
      );
    }
    if (data.onHelpful != null || data.onNotHelpful != null) {
      actions.add(
        _FooterAction(
          icon: Icons.thumb_up_rounded,
          label: 'Helpful',
          onTap: () {
            HapticFeedback.selectionClick();
            data.onHelpful?.call();
          },
          foreground: foreground,
          selected: data.helpfulSelected,
        ),
      );
      actions.add(
        _FooterAction(
          icon: Icons.thumb_down_rounded,
          label: 'Not helpful',
          onTap: () {
            HapticFeedback.selectionClick();
            data.onNotHelpful?.call();
          },
          foreground: foreground,
          selected: data.notHelpfulSelected,
        ),
      );
    }

    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: actions
          .map(
            (_FooterAction action) => _FooterPill(
              action: action,
              iconSize: iconSize,
              foreground: foreground,
              accent: _resolveAccent(isDark),
            ),
          )
          .toList(),
    );
  }

  String _resolveCopyPayload() {
    final String? text = widget.message ?? widget.markdownContent;
    if (text != null && text.isNotEmpty) return text;
    if (widget.richMessage != null) {
      return widget.richMessage!
          .map((InlineSpan span) => span is TextSpan ? span.text ?? '' : '')
          .join();
    }
    return '';
  }
}

// =============================================================================
// Private helper widgets
// =============================================================================

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.role,
    required this.accent,
    required this.header,
  });

  final AiBubbleRole role;
  final Color accent;
  final AiBubbleHeaderData? header;

  @override
  Widget build(BuildContext context) {
    final double size = AiConstants.compactAvatarSize;
    final bool isAi = role == AiBubbleRole.ai;
    final IconData icon = role == AiBubbleRole.user
        ? Icons.person_rounded
        : (isAi ? Icons.auto_awesome_rounded : Icons.info_rounded);

    return AnimatedContainer(
      duration: AiConstants.fastDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            accent.withValues(alpha: 0.95),
            AiConstants.aiIndigo.withValues(alpha: 0.95),
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: accent.withValues(alpha: 0.45),
            blurRadius: 12,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Center(
        child: Icon(icon, size: AppSizes.iconSm, color: Colors.white),
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge({required this.color, required this.foreground});

  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Verified AI',
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: const Icon(Icons.check_rounded, size: 10, color: Colors.white),
      ),
    );
  }
}

class _ModelBadge extends StatelessWidget {
  const _ModelBadge({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: accent.withValues(alpha: 0.4), width: 0.6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: accent,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _TypingContent extends StatelessWidget {
  const _TypingContent({required this.accent, required this.foreground});

  final Color accent;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < 3; i++)
          Padding(
            padding: EdgeInsets.only(right: i == 2 ? 0 : AppSpacing.xs),
            child: _TypingDot(
              delay: Duration(milliseconds: i * 120),
              accent: accent,
            ),
          ),
      ],
    );
  }
}

class _TypingDot extends StatefulWidget {
  const _TypingDot({required this.delay, required this.accent});

  final Duration delay;
  final Color accent;

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AiConstants.typingDotDuration,
  );

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final double t = Curves.easeInOut.transform(_controller.value);
        return Transform.translate(
          offset: Offset(0, -3 * t),
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.accent.withValues(alpha: 0.6 + 0.4 * t),
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerOverlay extends StatelessWidget {
  const _ShimmerOverlay({required this.controller, required this.accent});

  final AnimationController controller;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return ClipRRect(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1 + 2 * controller.value, 0),
                end: Alignment(0 + 2 * controller.value, 0),
                colors: <Color>[
                  Colors.transparent,
                  accent.withValues(alpha: 0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ThinkingTrails extends StatelessWidget {
  const _ThinkingTrails({
    required this.controller,
    required this.accent,
    required this.foreground,
  });

  final AnimationController controller;
  final Color accent;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return Row(
          children: <Widget>[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.5 + 0.5 * controller.value),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Thinking',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: foreground.withValues(alpha: 0.75),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FooterAction {
  const _FooterAction({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.foreground,
    this.selected,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color foreground;
  final bool? selected;
}

class _FooterPill extends StatefulWidget {
  const _FooterPill({
    required this.action,
    required this.iconSize,
    required this.foreground,
    required this.accent,
  });

  final _FooterAction action;
  final double iconSize;
  final Color foreground;
  final Color accent;

  @override
  State<_FooterPill> createState() => _FooterPillState();
}

class _FooterPillState extends State<_FooterPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.action.selected ?? false;
    final Color color = widget.foreground;
    final Color tint = isSelected
        ? widget.accent
        : widget.foreground.withValues(alpha: _hovered ? 0.18 : 0.10);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.action.onTap,
        child: AnimatedContainer(
          duration: AiConstants.fastDuration,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: color.withValues(
                alpha: isSelected ? 0.6 : (_hovered ? 0.45 : 0.25),
              ),
              width: 0.6,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                widget.action.icon,
                size: widget.iconSize - 2,
                color: color.withValues(alpha: isSelected ? 1.0 : 0.85),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                widget.action.label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: color.withValues(alpha: isSelected ? 1.0 : 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Lightweight markdown renderer
// =============================================================================

/// A small, dependency-free Markdown renderer that supports the subset of
/// syntax needed by AI chat surfaces in Prep Quest. It is deliberately
/// minimal so it stays fast on web and mobile without an extra package.
///
/// Supported:
/// - ATX headings (`#`, `##`, `###`)
/// - Bullet lists (`-`, `*`, `+`)
/// - Numbered lists
/// - Inline code (``)
/// - Code blocks (```)
/// - Links (`[label](url)`)
/// - Bold (`**`) and italic (`*`)
/// - Inline icons via `:icon_name:`
/// - Plain paragraphs
class _MarkdownLight extends StatelessWidget {
  const _MarkdownLight({
    required this.source,
    required this.baseStyle,
    required this.accent,
  });

  final String source;
  final TextStyle baseStyle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final List<MarkdownBlock> blocks = MarkdownParser.parse(source);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: blocks
          .map(
            (MarkdownBlock block) => _MarkdownBlockView(
              block: block,
              baseStyle: baseStyle,
              accent: accent,
            ),
          )
          .toList(),
    );
  }
}

enum _MarkdownBlockKind { paragraph, heading, bullet, numbered, code }

class MarkdownBlock {
  MarkdownBlock._(this.kind, this.content, [this.level = 1]);

  final _MarkdownBlockKind kind;
  final String content;
  final int level;
}

class MarkdownParser {
  static List<MarkdownBlock> parse(String src) {
    final List<String> lines = src.split(RegExp(r'\r?\n'));
    final List<MarkdownBlock> out = <MarkdownBlock>[];

    bool inCode = false;
    final StringBuffer codeBuf = StringBuffer();

    for (final String rawLine in lines) {
      final String line = rawLine;
      if (line.trimLeft().startsWith('```')) {
        if (inCode) {
          out.add(MarkdownBlock._(_MarkdownBlockKind.code, codeBuf.toString()));
          codeBuf.clear();
          inCode = false;
        } else {
          inCode = true;
        }
        continue;
      }
      if (inCode) {
        if (codeBuf.isNotEmpty) codeBuf.write('\n');
        codeBuf.write(line);
        continue;
      }

      if (line.trim().isEmpty) {
        continue;
      }

      final RegExpMatch? headingMatch = RegExp(
        r'^(#{1,3})\s+(.*)$',
      ).firstMatch(line);
      if (headingMatch != null) {
        out.add(
          MarkdownBlock._(
            _MarkdownBlockKind.heading,
            headingMatch.group(2)!,
            headingMatch.group(1)!.length,
          ),
        );
        continue;
      }

      final RegExpMatch? bulletMatch = RegExp(
        r'^\s*[-*+]\s+(.*)$',
      ).firstMatch(line);
      if (bulletMatch != null) {
        out.add(
          MarkdownBlock._(_MarkdownBlockKind.bullet, bulletMatch.group(1)!),
        );
        continue;
      }

      final RegExpMatch? numMatch = RegExp(
        r'^\s*\d+\.\s+(.*)$',
      ).firstMatch(line);
      if (numMatch != null) {
        out.add(
          MarkdownBlock._(_MarkdownBlockKind.numbered, numMatch.group(1)!),
        );
        continue;
      }

      out.add(MarkdownBlock._(_MarkdownBlockKind.paragraph, line));
    }

    if (inCode && codeBuf.isNotEmpty) {
      out.add(MarkdownBlock._(_MarkdownBlockKind.code, codeBuf.toString()));
    }

    return out;
  }
}

class _MarkdownBlockView extends StatelessWidget {
  const _MarkdownBlockView({
    required this.block,
    required this.baseStyle,
    required this.accent,
  });

  final MarkdownBlock block;
  final TextStyle baseStyle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    switch (block.kind) {
      case _MarkdownBlockKind.paragraph:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: _RichInline(
            source: block.content,
            baseStyle: baseStyle,
            accent: accent,
          ),
        );
      case _MarkdownBlockKind.heading:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            block.content,
            style: baseStyle.copyWith(
              fontSize: block.level == 1
                  ? 18
                  : block.level == 2
                  ? 16
                  : 14.5,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
        );
      case _MarkdownBlockKind.bullet:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 6, right: AppSpacing.sm),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Expanded(
                child: _RichInline(
                  source: block.content,
                  baseStyle: baseStyle,
                  accent: accent,
                ),
              ),
            ],
          ),
        );
      case _MarkdownBlockKind.numbered:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: _RichInline(
            source: block.content,
            baseStyle: baseStyle,
            accent: accent,
            numbered: true,
          ),
        );
      case _MarkdownBlockKind.code:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: accent.withValues(alpha: 0.25),
                width: 0.6,
              ),
            ),
            child: Text(
              block.content,
              style: baseStyle.copyWith(
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        );
    }
  }
}

class _RichInline extends StatelessWidget {
  const _RichInline({
    required this.source,
    required this.baseStyle,
    required this.accent,
    this.numbered = false,
  });

  final String source;
  final TextStyle baseStyle;
  final Color accent;
  final bool numbered;

  @override
  Widget build(BuildContext context) {
    final TextSpan prefix = numbered
        ? TextSpan(
            text: '• ',
            style: baseStyle.copyWith(
              color: accent,
              fontWeight: FontWeight.w800,
            ),
          )
        : const TextSpan();
    final List<InlineSpan> spans = MarkdownInline.parse(
      source,
      baseStyle,
      accent,
    );
    return Text.rich(TextSpan(children: <InlineSpan>[prefix, ...spans]));
  }
}

class MarkdownInline {
  static List<InlineSpan> parse(String src, TextStyle base, Color accent) {
    final List<InlineSpan> result = <InlineSpan>[];
    final RegExp pattern = RegExp(
      r'(`[^`]+`)|(\*\*[^*]+\*\*)|(\*[^*]+\*)|(\[[^\]]+\]\([^)]+\))|(:[a-z_]+:)',
      multiLine: true,
    );

    int last = 0;
    for (final RegExpMatch match in pattern.allMatches(src)) {
      if (match.start > last) {
        result.add(
          TextSpan(text: src.substring(last, match.start), style: base),
        );
      }

      final String token = match.group(0)!;
      if (token.startsWith('`')) {
        result.add(
          TextSpan(
            text: token.substring(1, token.length - 1),
            style: base.copyWith(
              fontFamily: 'monospace',
              backgroundColor: accent.withValues(alpha: 0.12),
            ),
          ),
        );
      } else if (token.startsWith('**')) {
        result.add(
          TextSpan(
            text: token.substring(2, token.length - 2),
            style: base.copyWith(fontWeight: FontWeight.w800),
          ),
        );
      } else if (token.startsWith('*')) {
        result.add(
          TextSpan(
            text: token.substring(1, token.length - 1),
            style: base.copyWith(fontStyle: FontStyle.italic),
          ),
        );
      } else if (token.startsWith('[')) {
        final RegExpMatch? linkMatch = RegExp(
          r'\[([^\]]+)\]\(([^)]+)\)',
        ).firstMatch(token);
        if (linkMatch != null) {
          result.add(
            TextSpan(
              text: linkMatch.group(1),
              style: base.copyWith(
                color: accent,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w700,
              ),
              recognizer: null,
            ),
          );
        }
      } else if (token.startsWith(':')) {
        final IconData? icon = _iconForName(token);
        if (icon != null) {
          result.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(icon, size: 16, color: accent),
              ),
            ),
          );
        } else {
          result.add(TextSpan(text: token, style: base));
        }
      }
      last = match.end;
    }

    if (last < src.length) {
      result.add(TextSpan(text: src.substring(last), style: base));
    }

    return result;
  }

  static IconData? _iconForName(String token) {
    switch (token) {
      case ':spark:':
        return Icons.auto_awesome_rounded;
      case ':book:':
        return Icons.menu_book_rounded;
      case ':bulb:':
        return Icons.lightbulb_rounded;
      case ':rocket:':
        return Icons.rocket_launch_rounded;
      case ':check:':
        return Icons.check_circle_rounded;
      case ':warning:':
        return Icons.warning_rounded;
      default:
        return null;
    }
  }
}
