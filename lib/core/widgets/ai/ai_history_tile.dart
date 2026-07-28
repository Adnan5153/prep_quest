import 'package:flutter/material.dart';

import '../../constants/app_radius.dart';
import 'ai_history_section/ai_history_models.dart';
import 'ai_history_section/widgets/ai_history_card.dart';

export 'ai_history_section/ai_history_models.dart';

/// A reusable, presentation-only row that represents a single AI history
/// entry.
///
/// Thin wrapper around [AiHistoryCard] — the canonical row implementation
/// that owns the hover, press, ripple and entry animations. [AiHistoryTile]
/// exposes a stable, declarative API intended to be reused by every AI
/// surface (AI Tutor, AI Chat, AI Prompt Studio, AI Exam Simulator, AI
/// Summary and future modules) without leaking the per-flag plumbing of
/// the underlying card.
///
/// The widget is intentionally stateless and contains no business logic:
/// no data fetching, no provider/repository access, no Firebase, no
/// networking. Callers own the [AiHistoryItem] lifecycle and pass it in.
class AiHistoryTile extends StatelessWidget {
  const AiHistoryTile({
    super.key,
    required this.entry,
    this.onTap,
    this.onLongPress,
    this.isDark,
    this.showCategory = true,
    this.showTimestamp = true,
    this.showPremiumBadge = true,
    this.showFavorite = true,
    this.showPinned = true,
    this.showLeadingChevron = true,
    this.dense = false,
    this.semanticLabel,
  });

  /// History item driving the row. [AiHistoryItem.id] should remain stable
  /// across rebuilds to preserve element identity inside lists.
  final AiHistoryItem entry;

  /// Optional tap callback. Precedence matches [AiHistorySection]: if
  /// [AiHistoryItem.onTap] is set on the model it wins; otherwise this
  /// callback is invoked.
  final ValueChanged<AiHistoryItem>? onTap;

  /// Optional long-press callback. Same precedence as [onTap].
  final ValueChanged<AiHistoryItem>? onLongPress;

  /// Force a specific brightness. When `null`, brightness is resolved from
  /// [Theme.of(context).brightness].
  final bool? isDark;

  /// Show the accent-tinted [CategoryChip] row beneath the title.
  final bool showCategory;

  /// Show the bottom row containing the schedule icon, timestamp and
  /// optional subtitle.
  final bool showTimestamp;

  /// Show the compact [PremiumBadge] when [AiHistoryItem.isPremium] is true.
  final bool showPremiumBadge;

  /// Show the animated favorite heart when [AiHistoryItem.isFavorite] is true.
  final bool showFavorite;

  /// Show the leading pin glyph when [AiHistoryItem.isPinned] is true.
  final bool showPinned;

  /// Show the trailing chevron at the end of the row.
  final bool showLeadingChevron;

  /// Slightly tighter visual density suitable for packed lists. Implemented
  /// by scaling the rendered card; does not affect layout or hit-targets.
  final bool dense;

  /// Accessibility override for the tile's screen-reader label. When null
  /// the underlying card falls back to `'${entry.title}, ${entry.timestamp}'`.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool resolvedDark = isDark ?? theme.brightness == Brightness.dark;

    final VoidCallback resolvedTap = _resolveTap();
    final VoidCallback resolvedLongPress = _resolveLongPress();

    final Widget card = AiHistoryCard(
      entry: entry,
      isDark: resolvedDark,
      showCategory: showCategory,
      showTimestamp: showTimestamp,
      showPremiumBadge: showPremiumBadge,
      showFavorite: showFavorite,
      showPinned: showPinned,
      showLeadingChevron: showLeadingChevron,
      onTap: resolvedTap,
      onLongPress: resolvedLongPress,
    );

    final Widget scaled = dense
        ? Transform.scale(
            scale: 0.96,
            alignment: Alignment.topLeft,
            child: card,
          )
        : card;

    final ClipRRect clipped = ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: scaled,
    );

    return Semantics(
      container: true,
      button: true,
      label: semanticLabel,
      child: clipped,
    );
  }

  VoidCallback _resolveTap() {
    final VoidCallback? entryTap = entry.onTap;
    if (entryTap != null) {
      return entryTap;
    }
    final ValueChanged<AiHistoryItem>? widgetTap = onTap;
    return () {
      widgetTap?.call(entry);
    };
  }

  VoidCallback _resolveLongPress() {
    final VoidCallback? entryLongPress = entry.onLongPress;
    if (entryLongPress != null) {
      return entryLongPress;
    }
    final ValueChanged<AiHistoryItem>? widgetLongPress = onLongPress;
    return () {
      widgetLongPress?.call(entry);
    };
  }
}
