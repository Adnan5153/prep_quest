import 'package:flutter/material.dart';

/// Lightweight markdown renderer used by [AiResponseCard] when
/// `markdown: true` is requested.
///
/// Supports a deliberate subset of CommonMark so the AI module family
/// can ship without taking on a full markdown dependency:
///
/// * `# Heading`, `## Subheading`, `### Minor`
/// * `- bullet item` / `* bullet item`
/// * `1. numbered item`
/// * Blank-line separated paragraphs
/// * **bold** (`**text**`)
/// * *italic* (`*text*` or `_text_`)
/// * `inline code`
///
/// Unsupported tokens are rendered as literal text. Code blocks,
/// links, and images are intentionally out of scope — callers that need
/// them should plug in a real renderer and bypass this widget.
class AiResponseMarkdown extends StatelessWidget {
  const AiResponseMarkdown({
    super.key,
    required this.text,
    this.style,
    this.maxLines,
    this.selectable = false,
  });

  /// Raw markdown source.
  final String text;

  /// Base text style applied to all rendered spans.
  final TextStyle? style;

  /// Optional max-line cap applied to paragraphs.
  final int? maxLines;

  /// When `true`, paragraphs are rendered through [SelectableText.rich].
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle resolved =
        style ?? theme.textTheme.bodyMedium ?? const TextStyle();

    final List<_Block> blocks = _parse(text);

    if (selectable) {
      return SelectableText.rich(
        TextSpan(
          style: resolved,
          children: blocks.map((b) => b.toTextSpan(resolved)).toList(),
        ),
        maxLines: maxLines,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final _Block block in blocks)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text.rich(
              block.toTextSpan(resolved),
              maxLines: maxLines,
              overflow: maxLines != null
                  ? TextOverflow.ellipsis
                  : TextOverflow.clip,
            ),
          ),
      ],
    );
  }

  static List<_Block> _parse(String source) {
    final List<_Block> result = <_Block>[];
    final List<String> lines = source.split('\n');
    int i = 0;

    while (i < lines.length) {
      final String line = lines[i];
      final String trimmed = line.trimRight();

      if (trimmed.isEmpty) {
        i++;
        continue;
      }

      // Heading
      if (trimmed.startsWith('### ')) {
        result.add(_Block.heading(trimmed.substring(4), level: 3));
        i++;
        continue;
      }
      if (trimmed.startsWith('## ')) {
        result.add(_Block.heading(trimmed.substring(3), level: 2));
        i++;
        continue;
      }
      if (trimmed.startsWith('# ')) {
        result.add(_Block.heading(trimmed.substring(2), level: 1));
        i++;
        continue;
      }

      // Bullet list
      if (_isBullet(trimmed)) {
        final List<String> items = <String>[];
        while (i < lines.length && _isBullet(lines[i].trimRight())) {
          items.add(_stripBullet(lines[i].trimRight()));
          i++;
        }
        result.add(_Block.bullets(items));
        continue;
      }

      // Numbered list
      if (_isNumbered(trimmed)) {
        final List<String> items = <String>[];
        while (i < lines.length && _isNumbered(lines[i].trimRight())) {
          items.add(_stripNumber(lines[i].trimRight()));
          i++;
        }
        result.add(_Block.numbered(items));
        continue;
      }

      // Paragraph: consume contiguous non-blank lines until a blank,
      // heading, or list starts.
      final StringBuffer buffer = StringBuffer(trimmed);
      i++;
      while (i < lines.length) {
        final String next = lines[i].trimRight();
        if (next.isEmpty ||
            next.startsWith('#') ||
            _isBullet(next) ||
            _isNumbered(next)) {
          break;
        }
        buffer
          ..write(' ')
          ..write(next);
        i++;
      }
      result.add(_Block.paragraph(buffer.toString()));
    }

    return result;
  }

  static bool _isBullet(String line) =>
      line.startsWith('- ') || line.startsWith('* ');

  static String _stripBullet(String line) {
    if (line.startsWith('- ')) return line.substring(2);
    if (line.startsWith('* ')) return line.substring(2);
    return line;
  }

  static bool _isNumbered(String line) {
    final RegExp re = RegExp(r'^\d+\.\s+');
    return re.hasMatch(line);
  }

  static String _stripNumber(String line) {
    final RegExp re = RegExp(r'^\d+\.\s+');
    return line.replaceFirst(re, '');
  }
}

/// Parsed markdown block. One of: heading, paragraph, bullets, numbered.
class _Block {
  _Block._({
    required this.kind,
    required this.raw,
    this.level = 0,
    this.items = const <String>[],
  });

  factory _Block.heading(String text, {required int level}) =>
      _Block._(kind: _BlockKind.heading, raw: text, level: level);

  factory _Block.paragraph(String text) =>
      _Block._(kind: _BlockKind.paragraph, raw: text);

  factory _Block.bullets(List<String> items) =>
      _Block._(kind: _BlockKind.bullets, raw: '', items: items);

  factory _Block.numbered(List<String> items) =>
      _Block._(kind: _BlockKind.numbered, raw: '', items: items);

  final _BlockKind kind;
  final String raw;
  final int level;
  final List<String> items;

  InlineSpan toTextSpan(TextStyle base) {
    switch (kind) {
      case _BlockKind.heading:
        final TextStyle headingStyle = base.copyWith(
          fontSize: switch (level) {
            1 => (base.fontSize ?? 14.0) + 6,
            2 => (base.fontSize ?? 14.0) + 4,
            _ => (base.fontSize ?? 14.0) + 2,
          },
          fontWeight: FontWeight.w800,
          height: 1.3,
        );
        return _InlineParser.parse(raw, headingStyle);
      case _BlockKind.paragraph:
        return _InlineParser.parse(raw, base);
      case _BlockKind.bullets:
        return TextSpan(
          style: base,
          children: <InlineSpan>[
            for (int i = 0; i < items.length; i++)
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        const TextSpan(text: '•  '),
                        _InlineParser.parse(items[i], base),
                      ],
                      style: base,
                    ),
                  ),
                ),
              ),
          ],
        );
      case _BlockKind.numbered:
        return TextSpan(
          style: base,
          children: <InlineSpan>[
            for (int i = 0; i < items.length; i++)
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(text: '${i + 1}.  '),
                        _InlineParser.parse(items[i], base),
                      ],
                      style: base,
                    ),
                  ),
                ),
              ),
          ],
        );
    }
  }
}

enum _BlockKind { heading, paragraph, bullets, numbered }

/// Parses a single line of text into bold / italic / inline-code spans
/// using a small state machine.
class _InlineParser {
  static final RegExp _tokenRe = RegExp(
    r'(\*\*[^*]+\*\*)|(\*[^*]+\*)|(_[^_]+_)|(`[^`]+`)',
  );

  static TextSpan parse(String text, TextStyle base) {
    final List<InlineSpan> spans = <InlineSpan>[];
    int cursor = 0;

    for (final RegExpMatch match in _tokenRe.allMatches(text)) {
      if (match.start > cursor) {
        spans.add(
          TextSpan(text: text.substring(cursor, match.start), style: base),
        );
      }
      final String token = match.group(0)!;
      if (token.startsWith('**')) {
        spans.add(
          TextSpan(
            text: token.substring(2, token.length - 2),
            style: base.copyWith(fontWeight: FontWeight.w700),
          ),
        );
      } else if (token.startsWith('*') || token.startsWith('_')) {
        spans.add(
          TextSpan(
            text: token.substring(1, token.length - 1),
            style: base.copyWith(fontStyle: FontStyle.italic),
          ),
        );
      } else if (token.startsWith('`')) {
        spans.add(
          TextSpan(
            text: token.substring(1, token.length - 1),
            style: base.copyWith(
              fontFamily: 'monospace',
              fontFamilyFallback: const <String>['monospace'],
              backgroundColor: base.color?.withValues(alpha: 0.08),
            ),
          ),
        );
      }
      cursor = match.end;
    }

    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor), style: base));
    }

    if (spans.isEmpty) {
      return TextSpan(text: text, style: base);
    }
    return TextSpan(style: base, children: spans);
  }
}
