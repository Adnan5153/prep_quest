import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';
import 'premium_badge.dart';

/// A production-ready responsive streak card widget.
///
/// Reinforces gamification by displaying user's learning streaks, weekly
/// progress, and motivational messages.
class StreakCard extends StatefulWidget {
  const StreakCard({
    super.key,
    required this.currentStreak,
    this.longestStreak,
    this.weeklyProgress = const [true, true, true, false, false, false, false],
    this.targetDays = 7,
    this.title = 'Daily Streak',
    this.subtitle,
    this.rewardText,
    this.motivationalMessage = 'Keep up the great work!',
    this.icon = Icons.local_fire_department_rounded,
    this.backgroundColor,
    this.gradient,
    this.showFireAnimation = true,
    this.showWeeklyProgress = true,
    this.showReward = false,
    this.showLongestStreak = true,
    this.showMilestone = false,
    this.progress = 0.0,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation = AppSizes.cardElevation,
  });

  final int currentStreak;
  final int? longestStreak;
  final List<bool> weeklyProgress;
  final int targetDays;
  final String title;
  final String? subtitle;
  final String? rewardText;
  final String motivationalMessage;
  final IconData icon;
  final Color? backgroundColor;
  final Gradient? gradient;
  final bool showFireAnimation;
  final bool showWeeklyProgress;
  final bool showReward;
  final bool showLongestStreak;
  final bool showMilestone;
  final double progress;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final double elevation;

  @override
  State<StreakCard> createState() => _StreakCardState();
}

class _StreakCardState extends State<StreakCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _fireController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _fireController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    if (widget.showFireAnimation) {
      _fireController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(StreakCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showFireAnimation != oldWidget.showFireAnimation) {
      if (widget.showFireAnimation) {
        _fireController.repeat(reverse: true);
      } else {
        _fireController.stop();
      }
    }
  }

  @override
  void dispose() {
    _fireController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: widget.margin,
          padding: widget.padding ?? const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? theme.cardColor,
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? AppRadius.lg,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _isHovered ? 0.12 : 0.06),
                blurRadius: _isHovered ? 15 : 8,
                offset: Offset(0, _isHovered ? 6 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(theme, isDark),
              if (widget.progress > 0 || widget.showWeeklyProgress) ...[
                const SizedBox(height: AppSpacing.lg),
                if (widget.progress > 0) _buildProgressBar(theme),
                if (widget.showWeeklyProgress) ...[
                  const SizedBox(height: AppSpacing.md),
                  _buildWeeklyProgress(theme, isDark),
                ],
              ],
              if (widget.showReward && widget.rewardText != null) ...[
                const SizedBox(height: AppSpacing.lg),
                _buildRewardSection(theme),
              ],
              const SizedBox(height: AppSpacing.md),
              Text(
                widget.motivationalMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withValues(
                    alpha: 0.8,
                  ),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFireIcon(),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.subtitle != null)
                Text(widget.subtitle!, style: theme.textTheme.bodySmall),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      '${widget.currentStreak} Day Streak',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                  if (widget.showMilestone) ...[
                    const SizedBox(width: AppSpacing.sm),
                    const PremiumBadge(
                      label: 'MILESTONE',
                      style: PremiumBadgeStyle.compact,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        if (widget.showLongestStreak && widget.longestStreak != null)
          _buildStatBadge(theme, 'LONGEST', '${widget.longestStreak}', isDark),
      ],
    );
  }

  Widget _buildFireIcon() {
    return AnimatedBuilder(
      animation: _fireController,
      builder: (context, child) {
        final scale = 1.0 + (_fireController.value * 0.15);
        return Transform.scale(
          scale: widget.showFireAnimation ? scale : 1.0,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.icon,
              color: AppColors.accent,
              size: AppSizes.iconLg,
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatBadge(
    ThemeData theme,
    String label,
    String value,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily Goal',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${(widget.progress * 100).toInt()}%',
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: LinearProgressIndicator(
            value: widget.progress,
            minHeight: 8,
            backgroundColor: AppColors.accent.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyProgress(ThemeData theme, bool isDark) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final isCompleted =
            index < widget.weeklyProgress.length &&
            widget.weeklyProgress[index];
        return Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.accent
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.03)),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted
                      ? AppColors.accent
                      : (isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.1)),
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              days[index],
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                color: isCompleted ? AppColors.accent : null,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildRewardSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.stars_rounded, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              widget.rewardText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
