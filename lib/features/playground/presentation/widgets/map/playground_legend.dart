import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';
import '../painters/legend_swatch_painter.dart';

enum LegendItemKind { node, building, reward, path }

class LegendItem {
  const LegendItem({
    required this.kind,
    required this.label,
    required this.swatch,
  });

  final LegendItemKind kind;
  final String label;
  final LegendSwatch swatch;
}

enum LegendSwatchKind { dot, icon, gradient, dashed, building, xpCoin, badge }

class LegendSwatch {
  const LegendSwatch({required this.kind, this.color, this.icon, this.colors});

  final LegendSwatchKind kind;
  final Color? color;
  final IconData? icon;
  final List<Color>? colors;
}

class PlaygroundLegend extends StatefulWidget {
  const PlaygroundLegend({
    super.key,
    required this.items,
    this.title = PlaygroundStrings.mapLegendTitle,
  });

  final String title;
  final List<LegendItem> items;

  @override
  State<PlaygroundLegend> createState() => _PlaygroundLegendState();
}

class _PlaygroundLegendState extends State<PlaygroundLegend>
    with SingleTickerProviderStateMixin {
  static const double _collapsedSize = PlaygroundSizes.mapLegendToggleSize;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: PlaygroundMapDurations.legendExpand,
    value: 0.0,
  );
  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _controller,
    curve: PlaygroundMapCurves.legendExpand,
    reverseCurve: PlaygroundMapCurves.legendCollapse,
  );

  bool _expanded = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_reduceMotion()) {
      setState(() => _expanded = !_expanded);
      return;
    }
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  bool _reduceMotion() {
    return WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _curve,
              builder: (context, _) {
                return _LegendSurface(
                  title: widget.title,
                  items: widget.items,
                  expanded: _expanded || _reduceMotion(),
                  expansion: _curve.value,
                  isDark: isDark,
                  onToggle: _toggle,
                  collapsedSize: _collapsedSize,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendSurface extends StatelessWidget {
  const _LegendSurface({
    required this.title,
    required this.items,
    required this.expanded,
    required this.expansion,
    required this.isDark,
    required this.onToggle,
    required this.collapsedSize,
  });

  final String title;
  final List<LegendItem> items;
  final bool expanded;
  final double expansion;
  final bool isDark;
  final VoidCallback onToggle;
  final double collapsedSize;

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveBuilder.value<int>(
      context,
      mobile: PlaygroundMapLimits.legendColumnsMobile,
      tablet: PlaygroundMapLimits.legendColumnsTablet,
      desktop: PlaygroundMapLimits.legendColumnsDesktop,
    );
    final maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: 280.0,
      tablet: 420.0,
      desktop: 520.0,
    );

    final showExpanded = expanded || expansion > 0;
    final width = showExpanded ? maxWidth : collapsedSize;
    final height = showExpanded
        ? (expanded
              ? _resolvedHeight(items.length, columns)
              : _resolvedHeight(items.length, columns) * expansion)
        : collapsedSize;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned.fill(
            child: _LegendBackdrop(
              isDark: isDark,
              expansion: expansion,
              borderRadius: BorderRadius.circular(
                PlaygroundSizes.mapLegendCornerRadius,
              ),
              child: expanded
                  ? _LegendBody(
                      title: title,
                      items: items,
                      columns: columns,
                      isDark: isDark,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _LegendToggle(
              isDark: isDark,
              expanded: expanded,
              onTap: onToggle,
            ),
          ),
        ],
      ),
    );
  }

  double _resolvedHeight(int itemCount, int columns) {
    final rows = (itemCount / columns).ceil();
    final headerHeight = PlaygroundSizes.mapLegendItemHeight + AppSpacing.sm;
    final bodyHeight =
        rows * PlaygroundSizes.mapLegendItemHeight + AppSpacing.sm * rows;
    final max = PlaygroundMapLimits.legendExpandedMaxHeight;
    return (headerHeight + bodyHeight).clamp(0.0, max);
  }
}

class _LegendBackdrop extends StatelessWidget {
  const _LegendBackdrop({
    required this.isDark,
    required this.expansion,
    required this.borderRadius,
    required this.child,
  });

  final bool isDark;
  final double expansion;
  final BorderRadius borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final alpha = isDark
        ? PlaygroundMapOpacity.legendBackdropDark
        : PlaygroundMapOpacity.legendBackdropLight;
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: PlaygroundSizes.mapLegendBlurSigma,
          sigmaY: PlaygroundSizes.mapLegendBlurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: (isDark ? AppColors.darkSurface : AppColors.lightSurface)
                .withValues(alpha: alpha),
            borderRadius: borderRadius,
            border: Border.all(
              color:
                  (isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface)
                      .withValues(alpha: PlaygroundMapOpacity.legendScrim),
              width: AppSizes.borderThin,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.darkBackground.withValues(alpha: 0.45),
                blurRadius: PlaygroundSizes.mapLegendShadowBlur,
                offset: PlaygroundSizes.mapLegendShadowOffset,
              ),
            ],
          ),
          child: Opacity(opacity: expansion, child: child),
        ),
      ),
    );
  }
}

class _LegendBody extends StatelessWidget {
  const _LegendBody({
    required this.title,
    required this.items,
    required this.columns,
    required this.isDark,
  });

  final String title;
  final List<LegendItem> items;
  final int columns;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                color: titleColor,
                fontSize: PlaygroundSizes.mapLegendTitleFontSize,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: <Widget>[
                  for (final item in items)
                    SizedBox(
                      width: _itemWidth(columns),
                      child: LegendTile(
                        item: item,
                        isDark: isDark,
                        mutedColor: mutedColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _itemWidth(int columns) {
    final totalWidth = 280.0 - AppSpacing.sm * 2;
    final itemWidth = (totalWidth - (columns - 1) * AppSpacing.xs) / columns;
    return itemWidth;
  }
}

class _LegendToggle extends StatelessWidget {
  const _LegendToggle({
    required this.isDark,
    required this.expanded,
    required this.onTap,
  });

  final bool isDark;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: expanded
          ? PlaygroundStrings.mapLegendCollapseSemantic
          : PlaygroundStrings.mapLegendExpandSemantic,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: PlaygroundSizes.mapLegendToggleSize,
          height: PlaygroundSizes.mapLegendToggleSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (isDark ? AppColors.darkSurface : AppColors.lightSurface)
                .withValues(alpha: 0.92),
            border: Border.all(
              color:
                  (isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface)
                      .withValues(alpha: PlaygroundMapOpacity.legendScrim),
              width: AppSizes.borderThin,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.darkBackground.withValues(alpha: 0.35),
                blurRadius: PlaygroundSizes.mapLegendShadowBlur * 0.6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            expanded ? Icons.close_rounded : Icons.help_outline_rounded,
            size: PlaygroundSizes.mapLegendIconSize,
            color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
          ),
        ),
      ),
    );
  }
}

class LegendTile extends StatelessWidget {
  const LegendTile({
    super.key,
    required this.item,
    required this.isDark,
    required this.mutedColor,
  });

  final LegendItem item;
  final bool isDark;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: PlaygroundSizes.mapLegendItemPadding,
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkSurface : AppColors.lightSurface)
            .withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(
          PlaygroundSizes.mapLegendItemRadius,
        ),
        border: Border.all(
          color: mutedColor.withValues(alpha: PlaygroundMapOpacity.legendScrim),
          width: AppSizes.borderThin,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _LegendSwatchView(swatch: item.swatch, isDark: isDark),
          SizedBox(width: PlaygroundSizes.mapLegendItemGap),
          Flexible(
            child: Text(
              item.label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.darkOnSurface
                    : AppColors.lightOnSurface,
                fontSize: PlaygroundSizes.mapLegendTextFontSize,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendSwatchView extends StatelessWidget {
  const _LegendSwatchView({required this.swatch, required this.isDark});

  final LegendSwatch swatch;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    switch (swatch.kind) {
      case LegendSwatchKind.dot:
        return Container(
          width: PlaygroundSizes.mapLegendDotSize,
          height: PlaygroundSizes.mapLegendDotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: swatch.color ?? AppColors.primary,
            border: Border.all(
              color:
                  (isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface)
                      .withValues(alpha: PlaygroundMapOpacity.legendScrim),
              width: AppSizes.borderThin,
            ),
          ),
        );
      case LegendSwatchKind.icon:
        return Container(
          width: PlaygroundSizes.mapLegendIconSize,
          height: PlaygroundSizes.mapLegendIconSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (swatch.color ?? AppColors.primary).withValues(
              alpha: PlaygroundMapOpacity.legendBackdropLight,
            ),
          ),
          child: Icon(
            swatch.icon ?? Icons.circle,
            size: PlaygroundSizes.mapLegendIconSize * 0.7,
            color: swatch.color ?? AppColors.primary,
          ),
        );
      case LegendSwatchKind.gradient:
        return Container(
          width: PlaygroundSizes.mapLegendIconSize,
          height: PlaygroundSizes.mapLegendIconSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xs),
            gradient: LinearGradient(
              colors:
                  swatch.colors ??
                  <Color>[AppColors.accent, AppColors.sparkleGold],
            ),
          ),
        );
      case LegendSwatchKind.dashed:
        return SizedBox(
          width: PlaygroundSizes.mapLegendIconSize * 1.2,
          height: PlaygroundSizes.mapLegendIconSize * 0.4,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: LegendSwatchPainter(
                color: swatch.color ?? AppColors.lightMuted,
              ),
            ),
          ),
        );
      case LegendSwatchKind.building:
        return Icon(
          swatch.icon ?? Icons.castle_outlined,
          size: PlaygroundSizes.mapLegendIconSize,
          color: swatch.color ?? AppColors.primary,
        );
      case LegendSwatchKind.xpCoin:
        return Icon(
          swatch.icon ?? Icons.bolt_rounded,
          size: PlaygroundSizes.mapLegendIconSize,
          color: swatch.color ?? AppColors.accent,
        );
      case LegendSwatchKind.badge:
        return Icon(
          swatch.icon ?? Icons.workspace_premium_rounded,
          size: PlaygroundSizes.mapLegendIconSize,
          color: swatch.color ?? AppColors.sparkleGold,
        );
    }
  }
}

class PlaygroundLegendDefaults {
  const PlaygroundLegendDefaults._();

  static List<LegendItem> defaultItems({required bool isDark}) {
    return <LegendItem>[
      LegendItem(
        kind: LegendItemKind.node,
        label: PlaygroundStrings.mapLegendNodeLocked,
        swatch: LegendSwatch(
          kind: LegendSwatchKind.dot,
          color: AppColors.buildingLocked,
        ),
      ),
      LegendItem(
        kind: LegendItemKind.node,
        label: PlaygroundStrings.mapLegendNodeUnlocked,
        swatch: LegendSwatch(
          kind: LegendSwatchKind.dot,
          color: AppColors.primary,
        ),
      ),
      LegendItem(
        kind: LegendItemKind.node,
        label: PlaygroundStrings.mapLegendNodeInProgress,
        swatch: LegendSwatch(
          kind: LegendSwatchKind.dot,
          color: AppColors.accent,
        ),
      ),
      LegendItem(
        kind: LegendItemKind.node,
        label: PlaygroundStrings.mapLegendNodeCompleted,
        swatch: LegendSwatch(
          kind: LegendSwatchKind.dot,
          color: AppColors.success,
        ),
      ),
      LegendItem(
        kind: LegendItemKind.node,
        label: PlaygroundStrings.mapLegendNodeBoss,
        swatch: LegendSwatch(
          kind: LegendSwatchKind.icon,
          color: AppColors.sparkleGold,
          icon: Icons.workspace_premium_rounded,
        ),
      ),
      LegendItem(
        kind: LegendItemKind.node,
        label: PlaygroundStrings.mapLegendNodePremium,
        swatch: LegendSwatch(
          kind: LegendSwatchKind.gradient,
          colors: <Color>[AppColors.accent, AppColors.sparkleGold],
        ),
      ),
      LegendItem(
        kind: LegendItemKind.building,
        label: PlaygroundStrings.mapLegendBuildingAcademy,
        swatch: LegendSwatch(
          kind: LegendSwatchKind.building,
          color: AppColors.academyPrimary,
          icon: Icons.school_rounded,
        ),
      ),
      LegendItem(
        kind: LegendItemKind.building,
        label: PlaygroundStrings.mapLegendBuildingLibrary,
        swatch: LegendSwatch(
          kind: LegendSwatchKind.building,
          color: AppColors.libraryPrimary,
          icon: Icons.local_library_rounded,
        ),
      ),
      LegendItem(
        kind: LegendItemKind.reward,
        label: PlaygroundStrings.mapLegendRewardXp,
        swatch: LegendSwatch(
          kind: LegendSwatchKind.xpCoin,
          color: AppColors.accent,
          icon: Icons.bolt_rounded,
        ),
      ),
      LegendItem(
        kind: LegendItemKind.reward,
        label: PlaygroundStrings.mapLegendRewardCoin,
        swatch: LegendSwatch(
          kind: LegendSwatchKind.xpCoin,
          color: AppColors.buildingGold,
          icon: Icons.monetization_on_rounded,
        ),
      ),
      LegendItem(
        kind: LegendItemKind.reward,
        label: PlaygroundStrings.mapLegendRewardBadge,
        swatch: LegendSwatch(
          kind: LegendSwatchKind.badge,
          color: AppColors.sparkleGold,
          icon: Icons.workspace_premium_rounded,
        ),
      ),
      LegendItem(
        kind: LegendItemKind.path,
        label: PlaygroundStrings.mapLegendPathCompleted,
        swatch: LegendSwatch(
          kind: LegendSwatchKind.gradient,
          colors: <Color>[AppColors.success, AppColors.success],
        ),
      ),
      LegendItem(
        kind: LegendItemKind.path,
        label: PlaygroundStrings.mapLegendPathActive,
        swatch: LegendSwatch(
          kind: LegendSwatchKind.gradient,
          colors: <Color>[AppColors.accent, AppColors.warning],
        ),
      ),
      LegendItem(
        kind: LegendItemKind.path,
        label: PlaygroundStrings.mapLegendPathFuture,
        swatch: LegendSwatch(
          kind: LegendSwatchKind.dashed,
          color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
        ),
      ),
    ];
  }
}
