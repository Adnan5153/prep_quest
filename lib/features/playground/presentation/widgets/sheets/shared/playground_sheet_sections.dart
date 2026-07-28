import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/primary_button.dart';
import '../../../../../../core/widgets/secondary_button.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';
import 'playground_sheet_container.dart';

class PlaygroundSheetHeader extends StatelessWidget {
  const PlaygroundSheetHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.semanticLabel,
    this.isDark = false,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final String? semanticLabel;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleLarge?.copyWith(
      color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
      fontWeight: FontWeight.w800,
    );
    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
      fontWeight: FontWeight.w500,
    );
    return Semantics(
      label: semanticLabel ?? title,
      header: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: titleStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...<Widget>[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: subtitleStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...<Widget>[
            const SizedBox(width: AppSpacing.sm),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class PlaygroundSheetStatTile extends StatelessWidget {
  const PlaygroundSheetStatTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.semanticValue,
    this.isDark = false,
    this.accentFill,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String? semanticValue;
  final bool isDark;
  final Color? accentFill;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor =
        accentFill ??
        (isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.04));
    return Semantics(
      label: semanticValue ?? '$label: $value',
      container: true,
      child: Container(
        height: PlaygroundSizes.bottomSheetStatTileHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: PlaygroundSizes.bottomSheetStatTilePaddingHorizontal,
          vertical: PlaygroundSizes.bottomSheetStatTilePaddingVertical,
        ),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: PlaygroundSheetBorder.statRadius,
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: PlaygroundSizes.bottomSheetStatTileIconSize,
              height: PlaygroundSizes.bottomSheetStatTileIconSize,
              decoration: BoxDecoration(
                color: iconColor.withValues(
                  alpha: PlaygroundSheetOpacity.accentSurface,
                ),
                borderRadius: BorderRadius.circular(
                  PlaygroundSizes.bottomSheetStatTileRadius,
                ),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: PlaygroundSizes.bottomSheetStatTileIconSize * 0.6,
              ),
            ),
            const SizedBox(width: PlaygroundSizes.bottomSheetStatTileGap),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? AppColors.darkMuted
                          : AppColors.lightMuted,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkOnSurface
                          : AppColors.lightOnSurface,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaygroundSheetStatGrid extends StatelessWidget {
  const PlaygroundSheetStatGrid({
    super.key,
    required this.tiles,
    this.columns = 2,
    this.gap,
    this.runGap,
  });

  final List<PlaygroundSheetStatTile> tiles;
  final int columns;
  final double? gap;
  final double? runGap;

  @override
  Widget build(BuildContext context) {
    if (tiles.isEmpty) return const SizedBox.shrink();
    final effectiveColumns = columns.clamp(1, 4);
    final effectiveGap = gap ?? PlaygroundSizes.bottomSheetItemGap;
    final effectiveRunGap = runGap ?? effectiveGap;
    return Wrap(
      spacing: effectiveGap,
      runSpacing: effectiveRunGap,
      children: tiles
          .map(
            (tile) => SizedBox(
              width: _resolveTileWidth(context, effectiveColumns, effectiveGap),
              child: tile,
            ),
          )
          .toList(growable: false),
    );
  }

  double _resolveTileWidth(BuildContext context, int columns, double gap) {
    final width = MediaQuery.sizeOf(context).width;
    final available = width - (effectiveGap * (columns - 1));
    final tileWidth = available / columns;
    return tileWidth.clamp(120.0, 320.0);
  }

  int get effectiveGap => columns - 1;
}

class PlaygroundSheetProgress extends StatelessWidget {
  const PlaygroundSheetProgress({
    super.key,
    required this.value,
    required this.caption,
    this.fillColor,
    this.trackColor,
    this.semanticValue,
    this.isDark = false,
  });

  final double value;
  final String caption;
  final Color? fillColor;
  final Color? trackColor;
  final String? semanticValue;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fill = fillColor ?? PlaygroundColors.sheetAccent;
    final track =
        trackColor ??
        (isDark
            ? Colors.white.withValues(alpha: PlaygroundSheetOpacity.handle)
            : Colors.black.withValues(alpha: PlaygroundSheetOpacity.handle));
    return Semantics(
      label: semanticValue ?? caption,
      value: '${(value.clamp(0.0, 1.0) * 100).round()}%',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ClipRRect(
            borderRadius: PlaygroundSheetBorder.progressRadius,
            child: LinearProgressIndicator(
              value: value.clamp(0.0, 1.0),
              minHeight: PlaygroundSizes.bottomSheetProgressHeight,
              backgroundColor: track,
              valueColor: AlwaysStoppedAnimation<Color>(fill),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            caption,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class PlaygroundSheetActionRow extends StatelessWidget {
  const PlaygroundSheetActionRow({
    super.key,
    required this.primaryLabel,
    required this.onPrimary,
    this.primaryIcon,
    this.primarySemantic,
    this.primaryEnabled = true,
    this.secondaryLabel,
    this.onSecondary,
    this.secondaryIcon,
    this.secondarySemantic,
    this.secondaryEnabled = true,
    this.height,
    this.alignment = PlaygroundSheetActionAlignment.horizontal,
  });

  final String primaryLabel;
  final VoidCallback? onPrimary;
  final IconData? primaryIcon;
  final String? primarySemantic;
  final bool primaryEnabled;

  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final IconData? secondaryIcon;
  final String? secondarySemantic;
  final bool secondaryEnabled;

  final double? height;
  final PlaygroundSheetActionAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final primary = _buildPrimary();
    final secondary = _buildSecondary();
    if (alignment == PlaygroundSheetActionAlignment.stacked) {
      final spacing = secondary != null
          ? const SizedBox(height: AppSpacing.sm)
          : null;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[?secondary, ?spacing, primary],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        if (secondary != null)
          Expanded(
            child: SizedBox(height: height, child: secondary),
          ),
        if (secondary != null)
          const SizedBox(width: PlaygroundSizes.bottomSheetActionGap),
        Expanded(
          child: SizedBox(height: height, child: primary),
        ),
      ],
    );
  }

  Widget _buildPrimary() {
    return PrimaryButton(
      text: primaryLabel,
      onPressed: primaryEnabled ? onPrimary : null,
      icon: primaryIcon,
      isEnabled: primaryEnabled,
      height: height ?? PlaygroundSizes.bottomSheetActionHeight,
      borderRadius: PlaygroundSizes.bottomSheetActionRadius,
      semanticLabel: primarySemantic ?? primaryLabel,
      fullWidth: true,
    );
  }

  Widget? _buildSecondary() {
    if (secondaryLabel == null) return null;
    return SecondaryButton(
      text: secondaryLabel!,
      onPressed: secondaryEnabled ? onSecondary : null,
      icon: secondaryIcon,
      isEnabled: secondaryEnabled,
      height: height ?? PlaygroundSizes.bottomSheetActionHeight,
      borderRadius: PlaygroundSizes.bottomSheetActionRadius,
      semanticLabel: secondarySemantic ?? secondaryLabel,
      fullWidth: true,
    );
  }
}

enum PlaygroundSheetActionAlignment { horizontal, stacked }

class PlaygroundSheetDivider extends StatelessWidget {
  const PlaygroundSheetDivider({super.key, this.isDark = false});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: PlaygroundSizes.bottomSheetDividerHeight,
      color: (isDark ? AppColors.darkMuted : AppColors.lightMuted).withValues(
        alpha: PlaygroundSheetOpacity.handle,
      ),
    );
  }
}

class PlaygroundSheetRarityBadge extends StatelessWidget {
  const PlaygroundSheetRarityBadge({
    super.key,
    required this.rarity,
    this.icon,
    this.isDark = false,
  });

  final PlaygroundRarity rarity;
  final IconData? icon;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(rarity);
    final label = _labelFor(rarity);
    return Semantics(
      label: label,
      container: true,
      child: Container(
        height: PlaygroundSizes.bottomSheetRarityBadgeHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: PlaygroundSizes.bottomSheetRarityBadgePaddingHorizontal,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: PlaygroundSheetOpacity.accentSurface),
          borderRadius: PlaygroundSheetBorder.rarityRadius,
          border: Border.all(
            color: color.withValues(alpha: 0.6),
            width: PlaygroundSizes.bottomSheetBorderWidth,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon ?? _defaultIcon(rarity),
              color: color,
              size: PlaygroundSizes.bottomSheetRarityBadgeIconSize,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorFor(PlaygroundRarity rarity) {
    switch (rarity) {
      case PlaygroundRarity.common:
        return PlaygroundColors.rarityCommon;
      case PlaygroundRarity.rare:
        return PlaygroundColors.rarityRare;
      case PlaygroundRarity.epic:
        return PlaygroundColors.rarityEpic;
      case PlaygroundRarity.legendary:
        return PlaygroundColors.rarityLegendary;
    }
  }

  String _labelFor(PlaygroundRarity rarity) {
    switch (rarity) {
      case PlaygroundRarity.common:
        return 'COMMON';
      case PlaygroundRarity.rare:
        return 'RARE';
      case PlaygroundRarity.epic:
        return 'EPIC';
      case PlaygroundRarity.legendary:
        return 'LEGENDARY';
    }
  }

  IconData _defaultIcon(PlaygroundRarity rarity) {
    switch (rarity) {
      case PlaygroundRarity.common:
        return Icons.circle_outlined;
      case PlaygroundRarity.rare:
        return Icons.bookmark_rounded;
      case PlaygroundRarity.epic:
        return Icons.diamond_outlined;
      case PlaygroundRarity.legendary:
        return Icons.workspace_premium_rounded;
    }
  }
}

class PlaygroundSheetStagger extends StatelessWidget {
  const PlaygroundSheetStagger({
    super.key,
    required this.children,
    this.enabled = true,
  });

  final List<Widget> children;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled || children.length <= 1) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    }
    final cap = PlaygroundSizes.bottomSheetSectionStaggerCap.toInt();
    final visibleCount = children.length > cap ? cap : children.length;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List<Widget>.generate(visibleCount, (index) {
        final isLast = index == visibleCount - 1;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AnimatedEntrance(index: index, child: children[index]),
            if (!isLast) const SizedBox(height: AppSpacing.sm),
          ],
        );
      }),
    );
  }
}

class AnimatedEntrance extends StatefulWidget {
  const AnimatedEntrance({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<AnimatedEntrance> createState() => _AnimatedEntranceState();
}

class _AnimatedEntranceState extends State<AnimatedEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: PlaygroundSheetDurations.entrance,
      vsync: this,
    );
    _fade =
        Tween<double>(
          begin: PlaygroundSheetMotion.fadeBegin,
          end: PlaygroundSheetMotion.fadeEnd,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: PlaygroundSheetCurves.enter,
          ),
        );
    _slide = Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: PlaygroundSheetCurves.enter,
          ),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (reduceMotion) {
      _controller.value = PlaygroundSheetMotion.fadeEnd;
      return;
    }
    final delay =
        (widget.index * PlaygroundSheetDurations.stagger.inMilliseconds).clamp(
          0,
          400,
        );
    Future<void>.delayed(Duration(milliseconds: delay), () {
      if (!mounted) return;
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fade.value,
          child: FractionalTranslation(translation: _slide.value, child: child),
        );
      },
      child: widget.child,
    );
  }
}
