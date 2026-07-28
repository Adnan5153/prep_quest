import 'package:flutter/material.dart';

import 'ai_response_markdown.dart';

/// Body content for [AiResponseCard].
///
/// Switches between plain text and a lightweight markdown renderer
/// based on [markdown]. When [maxLines] is supplied, the body is
/// rendered through [AnimatedSize] so callers can drive expansion by
/// passing different `maxLines` values without rebuilding the whole
/// card.
class AiResponseBody extends StatelessWidget {
  const AiResponseBody({
    super.key,
    required this.text,
    this.markdown = false,
    this.selectable = false,
    this.maxLines,
    this.fontSize,
    this.lineHeight = 1.5,
  });

  /// Raw body content. Interpreted as markdown when [markdown] is true.
  final String text;

  /// When `true`, the body is rendered through [AiResponseMarkdown].
  final bool markdown;

  /// When `true`, the body is rendered through [SelectableText] so the
  /// user can copy a substring via long-press. Has no effect when
  /// [markdown] is true.
  final bool selectable;

  /// Optional max-line cap. When supplied, the text is clipped with an
  /// ellipsis.
  final int? maxLines;

  /// Optional override for the font size. Defaults to the theme's
  /// `bodyMedium` size.
  final double? fontSize;

  /// Line height multiplier applied to the body text style.
  final double lineHeight;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color foreground = isDark ? Colors.white : const Color(0xFF1F2937);

    final TextStyle baseStyle =
        (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
          color: foreground.withValues(alpha: 0.92),
          fontSize: fontSize ?? 14.0,
          height: lineHeight,
        );

    if (markdown) {
      return AiResponseMarkdown(
        text: text,
        style: baseStyle,
        maxLines: maxLines,
        selectable: selectable,
      );
    }

    if (selectable) {
      return SelectableText(text, maxLines: maxLines, style: baseStyle);
    }

    return Text(
      text,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.clip,
      style: baseStyle,
    );
  }
}

/// Convenience helper that fades the bottom of the body when collapsed.
/// Used by [AiResponseCard] when [canExpand] is `true` and the card is
/// in its collapsed state — gives a visual hint that more content is
/// available without forcing a layout change.
class AiResponseBodyFadeMask extends StatelessWidget {
  const AiResponseBodyFadeMask({
    super.key,
    required this.child,
    this.enabled = true,
  });

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.black, Colors.black, Colors.transparent],
          stops: <double>[0.0, 0.75, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}
