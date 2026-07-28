import 'package:flutter/material.dart';

import 'ai_summary_constants.dart';
import 'ai_summary_models.dart';

class AiSummaryBody extends StatelessWidget {
  const AiSummaryBody({
    super.key,
    required this.sections,
    required this.accent,
    required this.tone,
    required this.isDark,
    required this.collapsed,
    required this.collapsedMaxLines,
  });

  final List<AiSummarySection> sections;
  final Color accent;
  final AiSummaryTone tone;
  final bool isDark;
  final bool collapsed;
  final int collapsedMaxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < sections.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(height: AiSummaryConstants.sectionGap),
          _SectionView(
            section: sections[i],
            accent: accent,
            isDark: isDark,
            collapsed: collapsed,
            collapsedMaxLines: collapsedMaxLines,
          ),
        ],
      ],
    );
  }
}

class _SectionView extends StatelessWidget {
  const _SectionView({
    required this.section,
    required this.accent,
    required this.isDark,
    required this.collapsed,
    required this.collapsedMaxLines,
  });

  final AiSummarySection section;
  final Color accent;
  final bool isDark;
  final bool collapsed;
  final int collapsedMaxLines;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color foreground = isDark ? Colors.white : const Color(0xFF1F2937);
    final TextStyle? textBase = theme.textTheme.bodyMedium?.copyWith(
      color: foreground.withValues(alpha: 0.88),
      height: 1.55,
    );

    switch (section) {
      case AiSummaryTextSection s:
        return _TextBlock(
          text: s.text,
          base: textBase,
          collapsed: collapsed,
          maxLines: collapsedMaxLines,
        );

      case AiSummaryBulletListSection s:
        return _BulletList(items: s.items, base: textBase, accent: accent);

      case AiSummaryNumberedListSection s:
        return _NumberedList(
          items: s.items,
          base: textBase,
          foreground: foreground,
        );

      case AiSummaryKeyTakeawaysSection s:
        return _KeyTakeaways(items: s.items, base: textBase, accent: accent);

      case AiSummaryCodeSection s:
        return _CodeBlock(code: s.code, language: s.language, isDark: isDark);

      case AiSummaryHighlightSection s:
        return _HighlightBlock(
          text: s.text,
          terms: s.terms,
          base: textBase,
          foreground: foreground,
        );
    }
  }
}

class _TextBlock extends StatelessWidget {
  const _TextBlock({
    required this.text,
    required this.base,
    required this.collapsed,
    required this.maxLines,
  });

  final String text;
  final TextStyle? base;
  final bool collapsed;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final List<String> paragraphs = text
        .split(RegExp(r'\n\s*\n'))
        .map((String e) => e.trim())
        .where((String e) => e.isNotEmpty)
        .toList(growable: false);

    if (paragraphs.isEmpty) {
      return const SizedBox.shrink();
    }

    final int? clamped = collapsed && maxLines > 0 ? maxLines : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < paragraphs.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(height: AiSummaryConstants.gapSm),
          Text(
            paragraphs[i],
            style: base,
            maxLines: clamped,
            overflow: clamped != null
                ? TextOverflow.ellipsis
                : TextOverflow.clip,
          ),
        ],
      ],
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({
    required this.items,
    required this.base,
    required this.accent,
  });

  final List<String> items;
  final TextStyle? base;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final String item in items) ...<Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: AiSummaryConstants.gapSm),
              Expanded(child: Text(item, style: base)),
            ],
          ),
          const SizedBox(height: AiSummaryConstants.listItemGap),
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
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < items.length; i++) ...<Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
              const SizedBox(width: AiSummaryConstants.gapSm),
              Expanded(child: Text(items[i], style: base)),
            ],
          ),
          const SizedBox(height: AiSummaryConstants.listItemGap),
        ],
      ],
    );
  }
}

class _KeyTakeaways extends StatelessWidget {
  const _KeyTakeaways({
    required this.items,
    required this.base,
    required this.accent,
  });

  final List<String> items;
  final TextStyle? base;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color foreground = base?.color ?? Colors.white;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AiSummaryConstants.gapMd),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark(base) ? 0.12 : 0.06),
        borderRadius: BorderRadius.circular(AiSummaryConstants.sectionRadius),
        border: Border.all(color: accent.withValues(alpha: 0.25), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.bookmark_rounded, size: 18, color: accent),
              const SizedBox(width: AiSummaryConstants.gapXs),
              Text(
                'Key Takeaways',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AiSummaryConstants.gapSm),
          for (int i = 0; i < items.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(height: AiSummaryConstants.listItemGap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 14,
                    color: accent,
                  ),
                ),
                const SizedBox(width: AiSummaryConstants.gapXs),
                Expanded(
                  child: Text(
                    items[i],
                    style: base?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  bool isDark(TextStyle? base) {
    if (base == null) return false;
    final Color? color = base.color;
    if (color == null) return false;
    return color.computeLuminance() > 0.5;
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
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = isDark
        ? const Color(0xFF0B0F14)
        : const Color(0xFFF1F2F6);
    final Color foreground = isDark
        ? const Color(0xFFE4E7EB)
        : const Color(0xFF1F2937);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AiSummaryConstants.gapMd),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AiSummaryConstants.sectionRadius),
        border: Border.all(
          color: foreground.withValues(alpha: 0.08),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (language != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AiSummaryConstants.gapSm),
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
    final List<TextSpan> spans = _buildSpans();
    return RichText(
      text: TextSpan(style: base, children: spans),
    );
  }

  List<TextSpan> _buildSpans() {
    if (terms.isEmpty) {
      return <TextSpan>[TextSpan(text: text)];
    }
    final RegExp pattern = RegExp(
      terms.map(RegExp.escape).join('|'),
      caseSensitive: false,
    );
    final List<TextSpan> result = <TextSpan>[];
    int last = 0;
    for (final RegExpMatch match in pattern.allMatches(text)) {
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
