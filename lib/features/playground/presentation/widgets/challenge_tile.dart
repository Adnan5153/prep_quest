import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/widget_constants.dart';
import '../constants/playground_constants.dart';
import '../constants/playground_sizes.dart';
import '../constants/playground_strings.dart';

class ChallengeTileVisual {
  const ChallengeTileVisual({
    required this.title,
    required this.subtitle,
    required this.kind,
    required this.difficulty,
    required this.xpReward,
    required this.coinReward,
    this.isLocked = false,
    this.isCompleted = false,
    this.isPremium = false,
  });

  final String title;
  final String subtitle;
  final PlaygroundChallengeKind kind;
  final String difficulty;
  final int xpReward;
  final int coinReward;
  final bool isLocked;
  final bool isCompleted;
  final bool isPremium;

  bool get isInteractive => !isLocked && !isCompleted;
}

class ChallengeTile extends StatefulWidget {
  const ChallengeTile({super.key, required this.visual, this.onTap});

  final ChallengeTileVisual visual;
  final VoidCallback? onTap;

  @override
  State<ChallengeTile> createState() => _ChallengeTileState();
}

class _ChallengeTileState extends State<ChallengeTile> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (!widget.visual.isInteractive) return;
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final semanticState = widget.visual.isLocked
        ? PlaygroundStrings.challengeTileLockedSemantic
        : widget.visual.isCompleted
        ? PlaygroundStrings.challengeTileCompletedSemantic
        : '';
    final semantic = '$semanticState ${widget.visual.title}'.trim();

    return RepaintBoundary(
      child: Semantics(
        label: semantic,
        button: widget.visual.isInteractive,
        enabled: widget.visual.isInteractive,
        container: true,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: PlaygroundSizes.challengeTileMinHeight,
            maxWidth: PlaygroundSizes.challengeTileMaxWidth,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => _setPressed(true),
            onTapUp: (_) => _setPressed(false),
            onTapCancel: () => _setPressed(false),
            onTap: widget.visual.isInteractive ? widget.onTap : null,
            child: AnimatedScale(
              scale: _pressed ? PlaygroundSizes.challengeTilePressScale : 1.0,
              duration: WidgetConstants.pressAnimationDuration,
              curve: PlaygroundCurves.stateEase,
              child: _ChallengeTileSurface(
                visual: widget.visual,
                isDark: isDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChallengeTileSurface extends StatelessWidget {
  const _ChallengeTileSurface({required this.visual, required this.isDark});

  final ChallengeTileVisual visual;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? AppColors.darkSurface : AppColors.lightBackground;
    final textColor = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final accent = _accentColor();
    final opacity = visual.isLocked
        ? PlaygroundOpacity.locked
        : visual.isCompleted
        ? PlaygroundOpacity.dimmed
        : 1.0;

    return Opacity(
      opacity: opacity,
      child: Container(
        padding: PlaygroundSizes.challengeTilePadding,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(
            PlaygroundSizes.challengeTileCornerRadius,
          ),
          border: Border.all(
            color: accent.withValues(
              alpha: PlaygroundAlpha.challengeTileHighlightAlpha,
            ),
          ),
          boxShadow: <BoxShadow>[
            const BoxShadow(
              color: AppColors.nodeDropShadow,
              blurRadius: PlaygroundSizes.challengeTileShadowBlur,
              offset: PlaygroundSizes.challengeTileShadowOffset,
            ),
            if (visual.isPremium)
              BoxShadow(
                color: PlaygroundColors.progressionPremium.withValues(
                  alpha: PlaygroundAlpha.levelCardPremiumGlow,
                ),
                blurRadius: PlaygroundSizes.challengeTileHighlightBlur,
              ),
          ],
        ),
        child: Row(
          children: <Widget>[
            _ChallengeIcon(visual: visual, accent: accent),
            const SizedBox(width: PlaygroundSizes.challengeTileLeadingGap),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    visual.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: PlaygroundSizes.challengeTileTitleFontSize,
                    ),
                  ),
                  const SizedBox(height: PlaygroundSizes.cardStackGap),
                  Text(
                    visual.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: muted,
                      fontSize: PlaygroundSizes.challengeTileSubtitleFontSize,
                    ),
                  ),
                  const SizedBox(height: PlaygroundSizes.cardStackGap),
                  _DifficultyDots(
                    difficulty: visual.difficulty,
                    accent: accent,
                    muted: muted,
                  ),
                ],
              ),
            ),
            const SizedBox(width: PlaygroundSizes.challengeTileRewardGap),
            _RewardColumn(visual: visual, muted: muted),
          ],
        ),
      ),
    );
  }

  Color _accentColor() {
    if (visual.isLocked) return PlaygroundColors.progressionLocked;
    if (visual.isCompleted) return PlaygroundColors.progressionCompleted;
    if (visual.isPremium) return PlaygroundColors.progressionPremium;
    if (visual.kind == PlaygroundChallengeKind.miniBoss) {
      return PlaygroundColors.progressionBoss;
    }
    return PlaygroundColors.progressionUnlocked;
  }
}

class _ChallengeIcon extends StatelessWidget {
  const _ChallengeIcon({required this.visual, required this.accent});

  final ChallengeTileVisual visual;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final icon = visual.isLocked
        ? Icons.lock_outline
        : visual.isCompleted
        ? Icons.check_circle_outline
        : switch (visual.kind) {
            PlaygroundChallengeKind.reading => Icons.menu_book_outlined,
            PlaygroundChallengeKind.quiz => Icons.quiz_outlined,
            PlaygroundChallengeKind.miniBoss => Icons.shield_outlined,
            PlaygroundChallengeKind.aiTask => Icons.auto_awesome_outlined,
            PlaygroundChallengeKind.mock => Icons.assignment_outlined,
          };
    return Container(
      width: PlaygroundSizes.challengeTileIconSize * 1.8,
      height: PlaygroundSizes.challengeTileIconSize * 1.8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accent.withValues(alpha: 0.14),
        border: Border.all(
          color: accent.withValues(
            alpha: PlaygroundAlpha.challengeTileHighlightAlpha,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: PlaygroundSizes.challengeTileIconSize,
        color: accent,
      ),
    );
  }
}

class _DifficultyDots extends StatelessWidget {
  const _DifficultyDots({
    required this.difficulty,
    required this.accent,
    required this.muted,
  });

  final String difficulty;
  final Color accent;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    final count = _count();
    final label = _label();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var index = 0; index < count; index++)
          Padding(
            padding: EdgeInsets.only(
              right: index == count - 1
                  ? 0
                  : PlaygroundSizes.challengeTileDifficultyDotGap,
            ),
            child: Container(
              width: PlaygroundSizes.challengeTileDifficultyDotSize,
              height: PlaygroundSizes.challengeTileDifficultyDotSize,
              decoration: BoxDecoration(shape: BoxShape.circle, color: accent),
            ),
          ),
        const SizedBox(width: PlaygroundSizes.cardInnerGap),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: muted),
        ),
      ],
    );
  }

  int _count() {
    if (difficulty == PlaygroundProgressionDifficulty.expert) return 4;
    if (difficulty == PlaygroundProgressionDifficulty.hard) return 3;
    if (difficulty == PlaygroundProgressionDifficulty.medium) return 2;
    return 1;
  }

  String _label() {
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
}

class _RewardColumn extends StatelessWidget {
  const _RewardColumn({required this.visual, required this.muted});

  final ChallengeTileVisual visual;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    if (visual.isLocked) {
      return Icon(
        Icons.chevron_right,
        color: muted,
        size: PlaygroundSizes.challengeTileIconSize,
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (visual.xpReward > 0)
          _Reward(label: '+${visual.xpReward} XP', color: PlaygroundColors.xp),
        if (visual.coinReward > 0) ...<Widget>[
          const SizedBox(height: PlaygroundSizes.cardStackGap),
          _Reward(label: '+${visual.coinReward}', color: PlaygroundColors.coin),
        ],
      ],
    );
  }
}

class _Reward extends StatelessWidget {
  const _Reward({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
        fontSize: PlaygroundSizes.challengeTileRewardFontSize,
        fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
      ),
    );
  }
}
