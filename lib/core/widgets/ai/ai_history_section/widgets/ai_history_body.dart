import 'package:flutter/material.dart';

import '../../../../widgets/responsive_builder.dart';
import '../ai_history_enums.dart';
import '../ai_history_models.dart';
import '../ai_history_utils.dart';
import 'ai_history_card.dart';
import 'ai_history_empty.dart';
import 'ai_history_error.dart';
import 'ai_history_loading.dart';

/// Body of the AI History section.
///
/// Dispatches between the four supported [AiHistoryState]s and
/// renders the appropriate placeholder or list.
class AiHistoryBody extends StatelessWidget {
  const AiHistoryBody({
    super.key,
    required this.isDark,
    required this.state,
    required this.items,
    required this.maxItems,
    required this.separatorHeight,
    required this.shrinkWrap,
    required this.scrollPhysics,
    required this.onItemTap,
    required this.onItemLongPress,
    required this.onRetry,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.emptyIcon,
    required this.errorTitle,
    required this.errorSubtitle,
    required this.loadingItemCount,
    required this.showCategory,
    required this.showTimestamp,
    required this.showPremiumBadge,
    required this.showFavorite,
    required this.showPinned,
    required this.showLeadingChevron,
  });

  final bool isDark;
  final AiHistoryState state;
  final List<AiHistoryItem> items;
  final int? maxItems;
  final double separatorHeight;
  final bool shrinkWrap;
  final ScrollPhysics? scrollPhysics;
  final ValueChanged<AiHistoryItem> onItemTap;
  final ValueChanged<AiHistoryItem> onItemLongPress;
  final VoidCallback? onRetry;
  final String? emptyTitle;
  final String? emptySubtitle;
  final IconData emptyIcon;
  final String? errorTitle;
  final String? errorSubtitle;
  final int loadingItemCount;
  final bool showCategory;
  final bool showTimestamp;
  final bool showPremiumBadge;
  final bool showFavorite;
  final bool showPinned;
  final bool showLeadingChevron;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case AiHistoryState.loading:
        return AiHistoryLoading(
          isDark: isDark,
          itemCount: loadingItemCount,
          separatorHeight: separatorHeight,
        );
      case AiHistoryState.empty:
        return AiHistoryEmpty(
          isDark: isDark,
          title: emptyTitle,
          subtitle: emptySubtitle,
          icon: emptyIcon,
        );
      case AiHistoryState.error:
        return AiHistoryError(
          isDark: isDark,
          title: errorTitle,
          subtitle: errorSubtitle,
          onRetry: onRetry,
        );
      case AiHistoryState.ready:
        return _buildReadyBody(context);
    }
  }

  Widget _buildReadyBody(BuildContext context) {
    if (items.isEmpty) {
      return AiHistoryEmpty(
        isDark: isDark,
        title: emptyTitle,
        subtitle: emptySubtitle,
        icon: emptyIcon,
      );
    }

    final List<AiHistoryItem> sorted = AiHistoryUtils.sortByPinThenTitle(items);
    final int limit = maxItems != null && maxItems! > 0
        ? maxItems!.clamp(0, sorted.length)
        : sorted.length;
    final List<AiHistoryItem> visible = sorted.sublist(0, limit);

    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: 560,
      desktop: 640,
      largeDesktop: 720,
    );

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: ListView.separated(
          shrinkWrap: true,
          physics: scrollPhysics ?? const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: visible.length,
          separatorBuilder: (BuildContext context, int index) =>
              SizedBox(height: separatorHeight),
          itemBuilder: (BuildContext context, int index) {
            final AiHistoryItem entry = visible[index];
            return AiHistoryCard(
              entry: entry,
              isDark: isDark,
              showCategory: showCategory,
              showTimestamp: showTimestamp,
              showPremiumBadge: showPremiumBadge,
              showFavorite: showFavorite,
              showPinned: showPinned,
              showLeadingChevron: showLeadingChevron,
              onTap: () => onItemTap(entry),
              onLongPress: () => onItemLongPress(entry),
            );
          },
        ),
      ),
    );
  }
}
