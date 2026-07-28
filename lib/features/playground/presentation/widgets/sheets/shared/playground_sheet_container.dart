import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';
import '../../../constants/playground_strings.dart';
import 'playground_sheet_layout.dart';

class PlaygroundSheetContainer extends StatelessWidget {
  const PlaygroundSheetContainer({
    super.key,
    required this.semanticLabel,
    required this.layout,
    required this.height,
    required this.child,
  });

  final String semanticLabel;
  final PlaygroundSheetLayout layout;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark
        ? PlaygroundColors.sheetSurfaceDark
        : PlaygroundColors.sheetSurfaceLight;
    final outlineColor = isDark
        ? Colors.white.withValues(alpha: PlaygroundSheetOpacity.outlineDark)
        : Colors.black.withValues(alpha: PlaygroundSheetOpacity.outlineLight);

    return RepaintBoundary(
      child: Semantics(
        label: semanticLabel,
        container: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: layout.maxWidth,
            minHeight: layout.minHeight,
            maxHeight: layout.maxHeight,
          ),
          child: Container(
            height: height,
            margin: EdgeInsets.symmetric(horizontal: layout.horizontalPadding),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(
                PlaygroundSizes.bottomSheetCornerRadius,
              ),
              border: Border.all(
                color: outlineColor,
                width: PlaygroundSizes.bottomSheetBorderWidth,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.nodeDropShadow.withValues(
                    alpha: PlaygroundSheetOpacity.shadow,
                  ),
                  blurRadius: PlaygroundSizes.bottomSheetShadowBlur,
                  offset: Offset(0, PlaygroundSizes.bottomSheetShadowOffsetY),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                PlaygroundSizes.bottomSheetCornerRadius,
              ),
              child: SafeArea(
                top: false,
                minimum: EdgeInsets.only(bottom: AppSpacing.xs),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlaygroundSheetHandle extends StatelessWidget {
  const PlaygroundSheetHandle({super.key, this.paddingTop});

  final double? paddingTop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = isDark
        ? PlaygroundColors.sheetHandleDark
        : PlaygroundColors.sheetHandleLight;
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop ?? AppSpacing.md,
        bottom: AppSpacing.sm,
      ),
      child: Semantics(
        label: PlaygroundStrings.sheetHandleSemantic,
        excludeSemantics: true,
        child: Center(
          child: Container(
            width: PlaygroundSizes.bottomSheetHandleWidth,
            height: PlaygroundSizes.bottomSheetHandleHeight,
            decoration: BoxDecoration(
              color: color.withValues(alpha: PlaygroundSheetOpacity.handle),
              borderRadius: BorderRadius.circular(
                PlaygroundSizes.bottomSheetHandleRadius,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlaygroundSheetFrame extends StatelessWidget {
  const PlaygroundSheetFrame({
    super.key,
    required this.layout,
    required this.semanticLabel,
    required this.content,
    this.actions,
  });

  final PlaygroundSheetLayout layout;
  final String semanticLabel;
  final Widget content;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: ReadingOrderTraversalPolicy(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const PlaygroundSheetHandle(),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: layout.horizontalPadding,
              ),
              child: content,
            ),
          ),
          if (actions != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                layout.horizontalPadding,
                layout.sectionGap,
                layout.horizontalPadding,
                layout.verticalPadding,
              ),
              child: actions!,
            ),
        ],
      ),
    );
  }
}

class PlaygroundSheetSpacing {
  const PlaygroundSheetSpacing._();

  static SizedBox get xs => const SizedBox(width: AppSizes.borderThin);
  static SizedBox get small => const SizedBox(height: AppSpacing.sm);
  static SizedBox get medium => const SizedBox(height: AppSpacing.md);
  static SizedBox get large => const SizedBox(height: AppSpacing.lg);
  static SizedBox get horizontalSmall => const SizedBox(width: AppSpacing.sm);
  static SizedBox get horizontalMedium => const SizedBox(width: AppSpacing.md);
}

class PlaygroundSheetBorder {
  const PlaygroundSheetBorder._();

  static BorderRadius get radius =>
      BorderRadius.circular(PlaygroundSizes.bottomSheetCornerRadius);

  static BorderRadius get statRadius =>
      BorderRadius.circular(PlaygroundSizes.bottomSheetStatTileRadius);

  static BorderRadius get actionRadius =>
      BorderRadius.circular(PlaygroundSizes.bottomSheetActionRadius);

  static BorderRadius get quickRadius =>
      BorderRadius.circular(PlaygroundSizes.bottomSheetQuickActionRadius);

  static BorderRadius get rarityRadius =>
      BorderRadius.circular(PlaygroundSizes.bottomSheetRarityBadgeRadius);

  static BorderRadius get unlockedRadius =>
      BorderRadius.circular(PlaygroundSizes.bottomSheetUnlockedTileRadius);

  static BorderRadius get heroRadius =>
      BorderRadius.circular(PlaygroundSizes.bottomSheetHeroRadius);

  static BorderRadius get progressRadius =>
      BorderRadius.circular(PlaygroundSizes.bottomSheetProgressRadius);
}
