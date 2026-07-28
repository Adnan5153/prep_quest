import 'package:flutter/material.dart';

import 'ai_summary_constants.dart';

class AiSummaryTags extends StatelessWidget {
  const AiSummaryTags({super.key, required this.tags, required this.accent});

  final List<String> tags;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Wrap(
      spacing: AiSummaryConstants.tagGap,
      runSpacing: AiSummaryConstants.tagGap,
      children: <Widget>[
        for (final String tag in tags)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AiSummaryConstants.gapMd,
              vertical: AiSummaryConstants.gapXxs,
            ),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: isDark ? 0.14 : 0.08),
              borderRadius: BorderRadius.circular(AiSummaryConstants.tagRadius),
              border: Border.all(
                color: accent.withValues(alpha: 0.3),
                width: 1.0,
              ),
            ),
            child: Text(
              tag,
              style: theme.textTheme.labelSmall?.copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                fontSize: 11,
              ),
            ),
          ),
      ],
    );
  }
}
