import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_radius.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../widgets/category_chip.dart';
import '../../../../widgets/premium_badge.dart';
import '../../ai_constants.dart';
import '../ai_history_colors.dart';
import '../ai_history_enums.dart';
import '../ai_history_models.dart';
import '../ai_history_utils.dart';
import 'ai_history_avatar.dart';
import 'ai_history_favorite_indicator.dart';

/// Production-ready row widget representing a single history entry.
class AiHistoryCard extends StatefulWidget {
  const AiHistoryCard({
    super.key,
    required this.entry,
    required this.isDark,
    required this.showCategory,
    required this.showTimestamp,
    required this.showPremiumBadge,
    required this.showFavorite,
    required this.showPinned,
    required this.showLeadingChevron,
    required this.onTap,
    required this.onLongPress,
  });

  final AiHistoryItem entry;
  final bool isDark;
  final bool showCategory;
  final bool showTimestamp;
  final bool showPremiumBadge;
  final bool showFavorite;
  final bool showPinned;
  final bool showLeadingChevron;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  State<AiHistoryCard> createState() => _AiHistoryCardState();
}

class _AiHistoryCardState extends State<AiHistoryCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late final AnimationController _entryController = AnimationController(
    vsync: this,
    duration: AiConstants.normalDuration,
  )..forward();

  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: _entryController,
    curve: Curves.easeOut,
  );

  late final Animation<Offset> _slideAnimation =
      Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
        CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
      );

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AiHistoryItem entry = widget.entry;

    final AiHistoryCardColors colors = _resolveColors(
      context: context,
      isDark: widget.isDark,
      entry: entry,
    );

    final double scale = _isPressed ? 0.985 : 1.0;

    final Widget avatar = AiHistoryAvatar(entry: entry, isDark: widget.isDark);

    final Widget body = Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.border, width: AppSizes.borderThin),
        boxShadow: _isHovered
            ? <BoxShadow>[
                BoxShadow(
                  color: colors.accent.withValues(alpha: 0.20),
                  blurRadius: 20,
                  spreadRadius: -4,
                  offset: const Offset(0, 12),
                ),
              ]
            : <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: widget.isDark ? 0.30 : 0.04,
                  ),
                  blurRadius: 10,
                  spreadRadius: -2,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                avatar,
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _buildContent(colors, theme)),
              ],
            ),
          ),
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _setPressed(false),
        child: Semantics(
          container: true,
          button: true,
          label: entry.semanticLabel ?? '${entry.title}, ${entry.timestamp}',
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: AnimatedScale(
                scale: scale,
                duration: AiConstants.fastDuration,
                curve: Curves.easeOut,
                child: body,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setHovered(bool value) {
    if (!mounted || _isHovered == value) return;
    setState(() => _isHovered = value);
  }

  void _setPressed(bool value) {
    if (!mounted || _isPressed == value) return;
    setState(() => _isPressed = value);
  }

  Widget _buildContent(AiHistoryCardColors colors, ThemeData theme) {
    final AiHistoryItem entry = widget.entry;

    final List<Widget> trailing = <Widget>[];

    if (widget.showPremiumBadge && entry.isPremium) {
      trailing
        ..add(
          const PremiumBadge(
            label: 'PREMIUM',
            animate: false,
            shadow: false,
            style: PremiumBadgeStyle.compact,
          ),
        )
        ..add(const SizedBox(width: AppSpacing.xs));
    }

    if (widget.showFavorite) {
      trailing
        ..add(
          AiHistoryFavoriteIndicator(
            active: entry.isFavorite,
            color: colors.accent,
          ),
        )
        ..add(const SizedBox(width: AppSpacing.xs));
    }

    if (widget.showLeadingChevron) {
      trailing.add(
        Icon(
          Icons.chevron_right_rounded,
          color: colors.muted,
          size: AppSizes.iconMd,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (widget.showPinned && entry.isPinned)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: Icon(
                  Icons.push_pin_rounded,
                  size: AppSizes.iconSm - 2,
                  color: colors.accent,
                  semanticLabel: 'Pinned',
                ),
              ),
            Expanded(
              child: Text(
                entry.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: entry.isUnread
                      ? (widget.isDark
                            ? AppColors.darkOnSurface
                            : AppColors.lightOnSurface)
                      : colors.title,
                ),
              ),
            ),
            if (trailing.isNotEmpty) ...<Widget>[
              const SizedBox(width: AppSpacing.sm),
              Row(mainAxisSize: MainAxisSize.min, children: trailing),
            ],
          ],
        ),
        if (widget.showCategory && entry.category != null) ...<Widget>[
          const SizedBox(height: AppSpacing.xs),
          CategoryChip(
            label: entry.category!,
            filled: false,
            textColor: colors.accent,
            borderColor: colors.accent.withValues(alpha: 0.35),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 2,
            ),
            selected: false,
          ),
        ],
        const SizedBox(height: AppSpacing.xs),
        Text(
          entry.preview,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.body,
            height: 1.35,
          ),
        ),
        if (widget.showTimestamp) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Icon(
                Icons.schedule_rounded,
                size: AppSizes.iconXs,
                color: colors.muted,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Flexible(
                child: Text(
                  entry.timestamp,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (entry.subtitle != null) ...<Widget>[
                const SizedBox(width: AppSpacing.sm),
                Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    color: colors.muted,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    entry.subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.muted,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  AiHistoryCardColors _resolveColors({
    required BuildContext context,
    required bool isDark,
    required AiHistoryItem entry,
  }) {
    final Color accent = AiHistoryUtils.accentFor(entry.type);

    final Color background = isDark
        ? entry.type == AiHistoryEntryType.exam
              ? AppColors.darkSurface.withValues(alpha: 0.92)
              : AppColors.darkSurface
        : AppColors.lightBackground;

    final Color border = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : AppColors.lightMuted.withValues(alpha: 0.18);

    final Color title = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;

    final Color body = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    final Color muted = isDark
        ? AppColors.darkMuted
        : AppColors.lightMuted.withValues(alpha: 0.85);

    return AiHistoryCardColors(
      background: background,
      border: border,
      title: title,
      body: body,
      muted: muted,
      accent: accent,
    );
  }
}
