import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import 'ai_loading_card.dart';

/// Vertical stack of [AiLoadingCard]s. Public counterpart to the
/// private `AiHistoryLoading` (which lives inside the AI History
/// section). Reusable by every AI surface that needs N stacked
/// skeleton cards.
class AiLoadingSection extends StatelessWidget {
  const AiLoadingSection({
    super.key,
    this.isDark,
    this.itemCount = 4,
    this.separatorHeight = AppSpacing.sm,
    this.showAvatar = true,
    this.showTitle = true,
    this.showSubtitle = true,
    this.showBody = true,
    this.showFooter = false,
    this.bodyLineCount = 3,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation = 0,
    this.semanticLabel,
  });

  final bool? isDark;
  final int itemCount;
  final double separatorHeight;
  final bool showAvatar;
  final bool showTitle;
  final bool showSubtitle;
  final bool showBody;
  final bool showFooter;
  final int bodyLineCount;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final double elevation;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final int count = itemCount.clamp(1, 8);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < count; i++) ...<Widget>[
          if (i > 0) SizedBox(height: separatorHeight),
          AiLoadingCard(
            isDark: isDark,
            showAvatar: showAvatar,
            showTitle: showTitle,
            showSubtitle: showSubtitle,
            showBody: showBody,
            showFooter: showFooter,
            bodyLineCount: bodyLineCount,
            padding: padding,
            margin: margin,
            borderRadius: borderRadius,
            elevation: elevation,
            semanticLabel: semanticLabel,
          ),
        ],
      ],
    );
  }
}
