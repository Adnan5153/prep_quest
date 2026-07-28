import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../core/widgets/widget_constants.dart';
import '../constants/playground_constants.dart';
import '../constants/playground_sizes.dart';
import '../constants/playground_strings.dart';

enum LevelCardState { locked, unlocked, inProgress, completed, premium, boss }

enum LevelCardVariant { compact, standard, expanded }

class LevelCardReward {
  const LevelCardReward({this.xp, this.coins, this.badges = 0});

  final int? xp;
  final int? coins;
  final int badges;

  bool get hasContent =>
      (xp != null && xp! > 0) || (coins != null && coins! > 0) || badges > 0;
}

class LevelCardVisual {
  const LevelCardVisual({
    required this.title,
    required this.subtitle,
    required this.difficulty,
    required this.state,
    required this.reward,
    required this.progress,
    required this.duration,
    this.energy,
    this.tags = const <String>[],
    this.variant = LevelCardVariant.standard,
  });

  final String title;
  final String subtitle;
  final String difficulty;
  final LevelCardState state;
  final LevelCardReward reward;
  final double progress;
  final int duration;
  final int? energy;
  final List<String> tags;
  final LevelCardVariant variant;

  double get normalizedProgress => progress.clamp(0.0, 1.0);

  bool get isInteractive =>
      state == LevelCardState.unlocked ||
      state == LevelCardState.inProgress ||
      state == LevelCardState.premium ||
      state == LevelCardState.boss;

  bool get isLocked => state == LevelCardState.locked;
  bool get isCompleted => state == LevelCardState.completed;
  bool get isPremium =>
      state == LevelCardState.premium ||
      difficulty == PlaygroundProgressionDifficulty.expert;
}

class LevelCard extends StatefulWidget {
  const LevelCard({super.key, required this.visual, this.onTap});

  final LevelCardVisual visual;
  final VoidCallback? onTap;

  @override
  State<LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<LevelCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: PlaygroundDurations.levelCardProgress,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animateTo(widget.visual.normalizedProgress);
  }

  @override
  void didUpdateWidget(covariant LevelCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visual.progress != widget.visual.progress) {
      _animateTo(
        widget.visual.normalizedProgress,
        from: oldWidget.visual.normalizedProgress,
      );
    }
  }

  void _animateTo(double target, {double? from}) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    if (reducedMotion) {
      _progressController.value = target;
      return;
    }
    if (from != null) _progressController.value = from;
    _progressController.animateTo(target, curve: PlaygroundCurves.stateEase);
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _setPressed(bool value) {
    if (!widget.visual.isInteractive) return;
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scale = ResponsiveBuilder.value<double>(
      context,
      mobile: 1.0,
      tablet: PlaygroundSizes.levelCardTabletScale,
      desktop: PlaygroundSizes.levelCardDesktopScale,
    );

    return RepaintBoundary(
      child: Semantics(
        label: _semanticLabel(),
        button: widget.visual.isInteractive,
        enabled: widget.visual.isInteractive,
        container: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: PlaygroundSizes.levelCardMinWidth * scale,
            maxWidth: PlaygroundSizes.levelCardMaxWidth * scale,
            minHeight: PlaygroundSizes.levelCardMinHeight * scale,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => _setPressed(true),
            onTapUp: (_) => _setPressed(false),
            onTapCancel: () => _setPressed(false),
            onTap: widget.visual.isInteractive ? widget.onTap : null,
            child: AnimatedScale(
              scale: _pressed
                  ? PlaygroundSizes.levelCardPressScale
                  : PlaygroundSizes.levelCardHoverScale,
              duration: WidgetConstants.pressAnimationDuration,
              curve: PlaygroundCurves.stateEase,
              child: _LevelCardSurface(
                visual: widget.visual,
                isDark: isDark,
                scale: scale,
                progress: _progressController.value,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _semanticLabel() {
    final base = widget.visual.isLocked
        ? PlaygroundStrings.levelCardLockedSemantic
        : widget.visual.isCompleted
        ? PlaygroundStrings.levelCardCompletedSemantic
        : widget.visual.isPremium
        ? PlaygroundStrings.levelCardPremiumSemantic
        : PlaygroundStrings.levelCardCurrentSemantic;
    return '$base: ${widget.visual.title}';
  }
}

class _LevelCardSurface extends StatelessWidget {
  const _LevelCardSurface({
    required this.visual,
    required this.isDark,
    required this.scale,
    required this.progress,
  });

  final LevelCardVisual visual;
  final bool isDark;
  final double scale;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final fillColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightBackground;
    final borderColor = visual.isPremium
        ? PlaygroundColors.premiumChrome.withValues(alpha: 0.55)
        : isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.06);
    final opacity = visual.isLocked
        ? PlaygroundOpacity.locked
        : visual.isCompleted
        ? PlaygroundOpacity.dimmed
        : 1.0;
    return Opacity(
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(
            PlaygroundSizes.levelCardCornerRadius * scale,
          ),
          border: Border.all(
            color: borderColor,
            width: PlaygroundSizes.cardBorderWidth,
          ),
          boxShadow: _shadows(),
          gradient: visual.isPremium
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    PlaygroundColors.cardPremiumStart,
                    PlaygroundColors.cardPremiumEnd,
                  ],
                )
              : null,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: PlaygroundSizes.levelCardPaddingHorizontal * scale,
          vertical: PlaygroundSizes.levelCardPaddingVertical * scale,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Header(visual: visual, isDark: isDark, scale: scale),
            SizedBox(height: PlaygroundSizes.cardInnerGap * scale),
            _ProgressBar(
              progress: progress,
              isPremium: visual.isPremium,
              isDark: isDark,
              scale: scale,
            ),
            SizedBox(height: PlaygroundSizes.cardInnerGap * scale),
            _DifficultyRow(visual: visual, isDark: isDark),
            SizedBox(height: PlaygroundSizes.cardInnerGap * scale),
            _MetaRow(visual: visual, isDark: isDark, scale: scale),
            if (visual.reward.hasContent) ...<Widget>[
              SizedBox(height: PlaygroundSizes.cardInnerGap * scale),
              _RewardRow(visual: visual, isDark: isDark, scale: scale),
            ],
            if (visual.tags.isNotEmpty) ...<Widget>[
              SizedBox(height: PlaygroundSizes.cardInnerGap * scale),
              _TagRow(visual: visual, isDark: isDark, scale: scale),
            ],
          ],
        ),
      ),
    );
  }

  List<BoxShadow> _shadows() {
    if (visual.isPremium) {
      return <BoxShadow>[
        BoxShadow(
          color: PlaygroundColors.cardGlowAccent.withValues(
            alpha: PlaygroundAlpha.levelCardPremiumGlow,
          ),
          blurRadius: PlaygroundSizes.levelCardPremiumShadowBlur,
          spreadRadius: PlaygroundSizes.levelCardPremiumShadowSpread,
          offset: PlaygroundSizes.levelCardShadowOffset,
        ),
        const BoxShadow(
          color: AppColors.nodeDropShadow,
          blurRadius: PlaygroundSizes.levelCardShadowBlur,
          offset: PlaygroundSizes.levelCardShadowOffset,
        ),
      ];
    }
    return const <BoxShadow>[
      BoxShadow(
        color: AppColors.nodeDropShadow,
        blurRadius: PlaygroundSizes.levelCardShadowBlur,
        offset: PlaygroundSizes.levelCardShadowOffset,
      ),
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.visual,
    required this.isDark,
    required this.scale,
  });

  final LevelCardVisual visual;
  final bool isDark;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: PlaygroundSizes.levelCardIconSize * scale,
          height: PlaygroundSizes.levelCardIconSize * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.school_outlined,
            size: PlaygroundSizes.levelCardIconSize * scale * 0.6,
            color: textColor,
          ),
        ),
        SizedBox(width: PlaygroundSizes.cardInnerGap * scale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                visual.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: PlaygroundSizes.levelCardTitleFontSize,
                ),
              ),
              SizedBox(height: PlaygroundSizes.cardStackGap * scale),
              Text(
                visual.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: muted,
                  fontSize: PlaygroundSizes.levelCardSubtitleFontSize,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.progress,
    required this.isPremium,
    required this.isDark,
    required this.scale,
  });

  final double progress;
  final bool isPremium;
  final bool isDark;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    final height = PlaygroundSizes.levelCardProgressHeight * scale;
    final trackColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
    final fillColor = isPremium
        ? PlaygroundColors.premiumChrome
        : PlaygroundColors.progressionInProgress;
    return RepaintBoundary(
      child: SizedBox(
        height: height,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: trackColor,
                borderRadius: BorderRadius.circular(
                  PlaygroundSizes.levelCardProgressRadius,
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: clamped,
              child: Container(
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(
                    PlaygroundSizes.levelCardProgressRadius,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: fillColor.withValues(
                        alpha: PlaygroundAlpha.levelCardPremiumGlow,
                      ),
                      blurRadius: PlaygroundSizes.levelCardGlowBlur,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyRow extends StatelessWidget {
  const _DifficultyRow({required this.visual, required this.isDark});

  final LevelCardVisual visual;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final count = _difficultyCount(visual.difficulty);
    final label = _difficultyLabel(visual.difficulty);
    final color = _difficultyColor(visual.difficulty);
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    return Row(
      children: <Widget>[
        for (var index = 0; index < count; index++)
          Padding(
            padding: EdgeInsets.only(
              right: index == count - 1
                  ? 0
                  : PlaygroundSizes.levelCardDifficultyDotGap,
            ),
            child: Container(
              width: PlaygroundSizes.levelCardDifficultyDotSize,
              height: PlaygroundSizes.levelCardDifficultyDotSize,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
          ),
        SizedBox(width: PlaygroundSizes.cardInnerGap),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: muted),
        ),
      ],
    );
  }

  int _difficultyCount(String difficulty) {
    if (difficulty == PlaygroundProgressionDifficulty.expert) return 4;
    if (difficulty == PlaygroundProgressionDifficulty.hard) return 3;
    if (difficulty == PlaygroundProgressionDifficulty.medium) return 2;
    return 1;
  }

  String _difficultyLabel(String difficulty) {
    if (difficulty == PlaygroundProgressionDifficulty.expert) {
      return PlaygroundStrings.levelCardDifficultyExpert;
    }
    if (difficulty == PlaygroundProgressionDifficulty.hard) {
      return PlaygroundStrings.levelCardDifficultyHard;
    }
    if (difficulty == PlaygroundProgressionDifficulty.medium) {
      return PlaygroundStrings.levelCardDifficultyMedium;
    }
    return PlaygroundStrings.levelCardDifficultyEasy;
  }

  Color _difficultyColor(String difficulty) {
    if (difficulty == PlaygroundProgressionDifficulty.expert) {
      return PlaygroundColors.progressionPremium;
    }
    if (difficulty == PlaygroundProgressionDifficulty.hard) {
      return PlaygroundColors.progressionBoss;
    }
    if (difficulty == PlaygroundProgressionDifficulty.medium) {
      return PlaygroundColors.progressionInProgress;
    }
    return PlaygroundColors.progressionCompleted;
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.visual,
    required this.isDark,
    required this.scale,
  });

  final LevelCardVisual visual;
  final bool isDark;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final entries = <Widget>[];
    if (visual.duration > 0) {
      entries.add(
        _MetaItem(
          icon: Icons.schedule_outlined,
          value: PlaygroundStrings.levelCardDurationTemplate.replaceFirst(
            '%d',
            '${visual.duration}',
          ),
          muted: muted,
        ),
      );
    }
    if (visual.energy != null) {
      entries.add(
        _MetaItem(
          icon: Icons.bolt_outlined,
          value: '${visual.energy}',
          muted: muted,
        ),
      );
    }
    if (visual.isCompleted) {
      entries.add(
        _MetaItem(
          icon: Icons.check_circle,
          value: PlaygroundStrings.missionCardCompleted,
          muted: muted,
        ),
      );
    }
    return Row(
      children: <Widget>[
        for (var index = 0; index < entries.length; index++) ...<Widget>[
          if (index > 0) SizedBox(width: PlaygroundSizes.cardInnerGap * scale),
          entries[index],
        ],
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.icon,
    required this.value,
    required this.muted,
  });

  final IconData icon;
  final String value;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          icon,
          size: PlaygroundSizes.levelCardTimerFontSize + 4,
          color: muted,
        ),
        SizedBox(width: PlaygroundSizes.cardStackGap),
        Text(
          value,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: muted),
        ),
      ],
    );
  }
}

class _RewardRow extends StatelessWidget {
  const _RewardRow({
    required this.visual,
    required this.isDark,
    required this.scale,
  });

  final LevelCardVisual visual;
  final bool isDark;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final items = <Widget>[];
    final xp = visual.reward.xp;
    if (xp != null && xp > 0) {
      items.add(
        _Pill(
          text: '+$xp ${PlaygroundStrings.xpLabel}',
          color: PlaygroundColors.xp,
          scale: scale,
        ),
      );
    }
    final coins = visual.reward.coins;
    if (coins != null && coins > 0) {
      items.add(
        _Pill(
          text: '+$coins ${PlaygroundStrings.coinShortLabel}',
          color: PlaygroundColors.coin,
          scale: scale,
        ),
      );
    }
    if (visual.reward.badges > 0) {
      items.add(
        _Pill(
          text: '${visual.reward.badges}x badge',
          color: PlaygroundColors.progressionPremium,
          scale: scale,
        ),
      );
    }
    return Row(
      children: <Widget>[
        Text(
          PlaygroundStrings.levelProgressRewardLabel,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: muted,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: PlaygroundSizes.cardInnerGap * scale),
        for (var index = 0; index < items.length; index++) ...<Widget>[
          if (index > 0) SizedBox(width: PlaygroundSizes.cardStackGap * scale),
          items[index],
        ],
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.color, required this.scale});

  final String text;
  final Color color;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: PlaygroundSizes.levelCardRewardPillHeight,
      padding: EdgeInsets.symmetric(
        horizontal: PlaygroundSizes.cardRewardPillPaddingHorizontal,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          PlaygroundSizes.cardRewardPillRadius,
        ),
        color: color.withValues(alpha: 0.16),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: PlaygroundSizes.levelCardRewardPillFontSize,
        ),
      ),
    );
  }
}

class _TagRow extends StatelessWidget {
  const _TagRow({
    required this.visual,
    required this.isDark,
    required this.scale,
  });

  final LevelCardVisual visual;
  final bool isDark;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    return Wrap(
      spacing: PlaygroundSizes.cardStackGap * scale,
      runSpacing: PlaygroundSizes.cardStackGap * scale,
      children: <Widget>[
        for (final tag in visual.tags)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: PlaygroundSizes.cardTagPaddingHorizontal,
              vertical: PlaygroundSizes.cardTagPaddingVertical,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                PlaygroundSizes.cardTagCornerRadius,
              ),
              border: Border.all(color: muted.withValues(alpha: 0.4)),
            ),
            child: Text(
              tag,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: muted,
                fontSize: PlaygroundSizes.levelCardTagFontSize,
              ),
            ),
          ),
      ],
    );
  }
}
