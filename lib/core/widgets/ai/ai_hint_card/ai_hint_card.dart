import 'package:flutter/material.dart';
import 'ai_hint_constants.dart';
import 'ai_hint_header.dart';
import 'ai_hint_footer.dart';

/// A premium, responsive AI Hint Card for study guidance.
class AiHintCard extends StatelessWidget {
  const AiHintCard({
    super.key,
    required this.title,
    required this.hint,
    this.type = AiHintType.quickTip,
    this.difficulty = AiHintDifficulty.beginner,
    this.topic,
    this.quickTip,
    this.badgeText,
    this.showBadge = true,
    this.showActions = true,
    this.onCopy,
    this.onBookmark,
    this.onShare,
    this.isBookmarked = false,
    this.backgroundColor,
    this.borderColor,
    this.gradient,
    this.shadow,
    this.semanticLabel,
  });

  final String title;
  final String hint;
  final AiHintType type;
  final AiHintDifficulty difficulty;
  final String? topic;
  final String? quickTip;
  final String? badgeText;
  final bool showBadge;
  final bool showActions;
  final VoidCallback? onCopy;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;
  final bool isBookmarked;
  final Color? backgroundColor;
  final Color? borderColor;
  final Gradient? gradient;
  final List<BoxShadow>? shadow;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = AiHintConstants.colorForType(type);

    final defaultGradient = isDark
        ? AiHintConstants.darkGradient
        : AiHintConstants.lightGradient;

    final cardBorderColor =
        borderColor ??
        (isDark ? AiHintConstants.darkBorder : AiHintConstants.lightBorder);

    return Semantics(
      label: semanticLabel ?? 'AI Hint: $title',
      container: true,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: AiHintConstants.maxCardWidth,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AiHintConstants.cardRadius),
            child: Stack(
              children: [
                // Background surface
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: gradient ?? defaultGradient,
                      color: backgroundColor,
                      boxShadow: shadow,
                      border: Border.all(color: cardBorderColor),
                      borderRadius: BorderRadius.circular(
                        AiHintConstants.cardRadius,
                      ),
                    ),
                  ),
                ),

                // Accent strip
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: AiHintConstants.accentStripWidth,
                  child: Container(color: accent),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.only(
                    left: AiHintConstants.accentStripWidth,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact =
                          constraints.maxWidth <
                          AiHintConstants.compactBreakpoint;

                      return Padding(
                        padding: EdgeInsets.all(isCompact ? 16 : 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AiHintHeader(
                              title: title,
                              type: type,
                              badgeText: badgeText,
                              showBadge: showBadge,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              hint,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                                color: theme.textTheme.bodyMedium?.color
                                    ?.withValues(alpha: 0.85),
                              ),
                            ),
                            if (topic != null || quickTip != null) ...[
                              const SizedBox(height: 16),
                              _MetaInfo(
                                topic: topic,
                                difficulty: difficulty,
                                quickTip: quickTip,
                              ),
                            ],
                            if (showActions) ...[
                              const SizedBox(height: 8),
                              AiHintFooter(
                                onCopy: onCopy,
                                onBookmark: onBookmark,
                                onShare: onShare,
                                isBookmarked: isBookmarked,
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaInfo extends StatelessWidget {
  const _MetaInfo({this.topic, required this.difficulty, this.quickTip});

  final String? topic;
  final AiHintDifficulty difficulty;
  final String? quickTip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final difficultyColor = AiHintConstants.colorForDifficulty(difficulty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (topic != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.topic_rounded, size: 14, color: theme.hintColor),
                  const SizedBox(width: 4),
                  Text(
                    topic!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.hintColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bar_chart_rounded, size: 14, color: difficultyColor),
                const SizedBox(width: 4),
                Text(
                  difficulty.name.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: difficultyColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (quickTip != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.hintColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.hintColor.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_fix_high_rounded, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    quickTip!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
