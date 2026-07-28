import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';
import 'ai_constants.dart';
import 'ai_history_section/ai_history_enums.dart';
import 'ai_history_section/ai_history_models.dart';
import 'ai_history_section/widgets/ai_history_body.dart';
import 'ai_history_section/widgets/ai_history_header.dart';

export 'ai_history_section/ai_history_enums.dart';
export 'ai_history_section/ai_history_models.dart';

/// A reusable, production-ready history section for the AI module family.
///
/// The widget renders a premium header plus a scrollable list of
/// previously generated AI conversations, prompts, summaries and
/// exam simulations. It is intentionally a presentation-only
/// component — it never fetches data or talks to repositories.
///
/// Use it inside the AI Tutor, Smart Prompt, AI Exam Simulator and
/// future AI surfaces. All data is passed through [items].
class AiHistorySection extends StatelessWidget {
  const AiHistorySection({
    super.key,
    required this.items,
    this.state = AiHistoryState.ready,
    this.title,
    this.subtitle,
    this.icon = Icons.history_rounded,
    this.onViewAll,
    this.viewAllText,
    this.showHeader = true,
    this.showViewAll = true,
    this.showCategory = true,
    this.showTimestamp = true,
    this.showPremiumBadge = true,
    this.showFavorite = true,
    this.showPinned = true,
    this.showLeadingChevron = true,
    this.maxItems,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.elevation = 0,
    this.scrollPhysics,
    this.shrinkWrap = true,
    this.separatorHeight = AppSpacing.sm,
    this.semanticLabel,
    this.onRetry,
    this.onItemTap,
    this.onItemLongPress,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyIcon = Icons.history_toggle_off_rounded,
    this.errorTitle,
    this.errorSubtitle,
    this.loadingItemCount = 4,
  });

  final List<AiHistoryItem> items;
  final AiHistoryState state;
  final String? title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onViewAll;
  final String? viewAllText;
  final bool showHeader;
  final bool showViewAll;
  final bool showCategory;
  final bool showTimestamp;
  final bool showPremiumBadge;
  final bool showFavorite;
  final bool showPinned;
  final bool showLeadingChevron;
  final int? maxItems;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final double elevation;
  final ScrollPhysics? scrollPhysics;
  final bool shrinkWrap;
  final double separatorHeight;
  final String? semanticLabel;
  final VoidCallback? onRetry;
  final ValueChanged<AiHistoryItem>? onItemTap;
  final ValueChanged<AiHistoryItem>? onItemLongPress;
  final String? emptyTitle;
  final String? emptySubtitle;
  final IconData emptyIcon;
  final String? errorTitle;
  final String? errorSubtitle;
  final int loadingItemCount;

  void _dispatchTap(AiHistoryItem entry) {
    if (entry.onTap != null) {
      entry.onTap!();
      return;
    }
    onItemTap?.call(entry);
  }

  void _dispatchLongPress(AiHistoryItem entry) {
    if (entry.onLongPress != null) {
      entry.onLongPress!();
      return;
    }
    onItemLongPress?.call(entry);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color resolvedBackground =
        backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.lightBackground);
    final Color resolvedBorder =
        borderColor ?? theme.colorScheme.outlineVariant.withValues(alpha: 0.5);
    final double resolvedRadius = borderRadius ?? AppRadius.lg;

    return Semantics(
      container: true,
      label: semanticLabel ?? (title ?? 'AI history'),
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: resolvedBackground,
          borderRadius: BorderRadius.circular(resolvedRadius),
          border: Border.all(color: resolvedBorder),
          boxShadow: elevation > 0
              ? <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.06),
                    blurRadius: 18,
                    spreadRadius: -4,
                    offset: const Offset(0, 12),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(resolvedRadius),
          child: Padding(
            padding:
                padding ??
                const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (showHeader)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: AiHistoryHeader(
                      isDark: isDark,
                      title: title,
                      subtitle: subtitle,
                      icon: icon,
                      showViewAll: showViewAll,
                      viewAllText: viewAllText,
                      onViewAll: onViewAll,
                    ),
                  ),
                AnimatedSize(
                  duration: AiConstants.normalDuration,
                  curve: Curves.easeInOut,
                  child: AiHistoryBody(
                    isDark: isDark,
                    state: state,
                    items: items,
                    maxItems: maxItems,
                    separatorHeight: separatorHeight,
                    shrinkWrap: shrinkWrap,
                    scrollPhysics: scrollPhysics,
                    onItemTap: _dispatchTap,
                    onItemLongPress: _dispatchLongPress,
                    onRetry: onRetry,
                    emptyTitle: emptyTitle,
                    emptySubtitle: emptySubtitle,
                    emptyIcon: emptyIcon,
                    errorTitle: errorTitle,
                    errorSubtitle: errorSubtitle,
                    loadingItemCount: loadingItemCount,
                    showCategory: showCategory,
                    showTimestamp: showTimestamp,
                    showPremiumBadge: showPremiumBadge,
                    showFavorite: showFavorite,
                    showPinned: showPinned,
                    showLeadingChevron: showLeadingChevron,
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
