import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../core/widgets/widget_constants.dart';
import '../constants/playground_constants.dart';
import '../constants/playground_sizes.dart';
import '../constants/playground_strings.dart';
import 'rewards/reward_chest.dart';
import 'rewards/xp_reward.dart';
import 'rewards/coin_reward.dart';

enum LevelRewardDialogNextLevel { hasNext, endOfPath }

class LevelRewardDialogVisual {
  const LevelRewardDialogVisual({
    required this.levelNumber,
    required this.xpEarned,
    required this.coinsEarned,
    required this.badgeEarned,
    this.nextLevelNumber,
    this.unlockedTitles = const <String>[],
    this.rarity = PlaygroundRarity.legendary,
    this.animate = true,
  });

  final int levelNumber;
  final int xpEarned;
  final int coinsEarned;
  final String? badgeEarned;
  final int? nextLevelNumber;
  final List<String> unlockedTitles;
  final PlaygroundRarity rarity;
  final bool animate;

  LevelRewardDialogNextLevel get nextLevelStatus => nextLevelNumber == null
      ? LevelRewardDialogNextLevel.endOfPath
      : LevelRewardDialogNextLevel.hasNext;
}

class LevelRewardDialog {
  const LevelRewardDialog._();

  static Future<void> show(
    BuildContext context, {
    required LevelRewardDialogVisual visual,
    VoidCallback? onPrimary,
    VoidCallback? onSecondary,
    String? primaryLabel,
    String? secondaryLabel,
    Color? scrimColor,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor:
          scrimColor ??
          PlaygroundColors.popupScrim.withValues(
            alpha: PlaygroundOpacity.rewardPopupScrim,
          ),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: _horizontalInset(context),
            vertical: AppSpacing.xl,
          ),
          child: _LevelRewardDialogWidget(
            visual: visual,
            primaryLabel: primaryLabel,
            secondaryLabel: secondaryLabel,
            onPrimary: onPrimary == null
                ? null
                : () {
                    Navigator.of(dialogContext).pop();
                    onPrimary();
                  },
            onSecondary: onSecondary == null
                ? null
                : () {
                    Navigator.of(dialogContext).pop();
                    onSecondary();
                  },
          ),
        );
      },
    );
  }

  static double _horizontalInset(BuildContext context) {
    if (ResponsiveBuilder.isDesktop(context)) {
      return AppSpacing.huge;
    }
    if (ResponsiveBuilder.isTablet(context)) {
      return AppSpacing.xxl;
    }
    return AppSpacing.lg;
  }
}

class _LevelRewardDialogWidget extends StatefulWidget {
  const _LevelRewardDialogWidget({
    required this.visual,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimary,
    required this.onSecondary,
  });

  final LevelRewardDialogVisual visual;
  final String? primaryLabel;
  final String? secondaryLabel;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;

  @override
  State<_LevelRewardDialogWidget> createState() =>
      _LevelRewardDialogWidgetState();
}

class _LevelRewardDialogWidgetState extends State<_LevelRewardDialogWidget>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController = AnimationController(
    vsync: this,
    duration: PlaygroundDurations.levelRewardDialogEntrance,
  );
  late final AnimationController _chestController = AnimationController(
    vsync: this,
    duration: PlaygroundDurations.levelRewardChestScale,
  );
  late final AnimationController _celebrateController = AnimationController(
    vsync: this,
    duration: PlaygroundDurations.levelRewardCelebration,
  );
  late final List<AnimationController> _floatControllers;
  late final List<Animation<double>> _floatTweens;

  static const int _maxParticles = 6;

  @override
  void initState() {
    super.initState();
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reducedMotion || !widget.visual.animate) {
      _entranceController.value = 1.0;
      _chestController.value = 1.0;
      _celebrateController.value = 0.0;
      _floatControllers = <AnimationController>[];
      _floatTweens = <Animation<double>>[];
      return;
    }
    _floatControllers = List<AnimationController>.generate(
      _maxParticles,
      (i) => AnimationController(
        vsync: this,
        duration: PlaygroundDurations.levelRewardFloatUp,
      ),
    );
    _floatTweens = _floatControllers
        .map(
          (c) => Tween<double>(
            begin: 0.0,
            end: PlaygroundSizes.levelRewardDialogFloatUpDistance,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeOut)),
        )
        .toList(growable: false);

    _entranceController.forward();
    Future<void>.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      _chestController
        ..value = 0.0
        ..animateTo(1.0, curve: Curves.easeOutBack);
    });
    Future<void>.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      _celebrateController.repeat();
      for (var i = 0; i < _floatControllers.length; i++) {
        Future<void>.delayed(
          Duration(
            milliseconds:
                i * PlaygroundDurations.progressionStaggerStep.inMilliseconds,
          ),
          () {
            if (!mounted || i >= _floatControllers.length) return;
            _floatControllers[i]
              ..reset()
              ..forward();
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _chestController.dispose();
    _celebrateController.dispose();
    for (final controller in _floatControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scale = ResponsiveBuilder.value<double>(
      context,
      mobile: 1.0,
      tablet: PlaygroundSizes.levelRewardDialogTabletScale,
      desktop: PlaygroundSizes.levelRewardDialogDesktopScale,
    );
    final semantic = widget.visual.nextLevelNumber == null
        ? '${PlaygroundStrings.levelRewardDialogSemantic}: '
              'Level ${widget.visual.levelNumber}'
        : '${PlaygroundStrings.levelRewardDialogSemantic}: '
              'Level ${widget.visual.levelNumber}, '
              '${widget.visual.xpEarned} XP, '
              '${widget.visual.coinsEarned} coins';

    return RepaintBoundary(
      child: Semantics(
        label: semantic,
        container: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: PlaygroundSizes.levelRewardDialogMaxWidth * scale,
            minHeight: PlaygroundSizes.levelRewardDialogMinHeight,
          ),
          child: AnimatedBuilder(
            animation: Listenable.merge(<Listenable>[
              _entranceController,
              _chestController,
              _celebrateController,
              ..._floatControllers,
            ]),
            builder: (context, _) {
              return _LevelRewardDialogSurface(
                visual: widget.visual,
                isDark: isDark,
                scale: scale,
                entrance: _entranceController.value,
                chestProgress: _chestController.value,
                celebratePhase: _celebrateController.value,
                floatTweens: _floatTweens,
                primaryLabel: widget.primaryLabel,
                secondaryLabel: widget.secondaryLabel,
                onPrimary: widget.onPrimary,
                onSecondary: widget.onSecondary,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LevelRewardDialogSurface extends StatelessWidget {
  const _LevelRewardDialogSurface({
    required this.visual,
    required this.isDark,
    required this.scale,
    required this.entrance,
    required this.chestProgress,
    required this.celebratePhase,
    required this.floatTweens,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimary,
    required this.onSecondary,
  });

  final LevelRewardDialogVisual visual;
  final bool isDark;
  final double scale;
  final double entrance;
  final double chestProgress;
  final double celebratePhase;
  final List<Animation<double>> floatTweens;
  final String? primaryLabel;
  final String? secondaryLabel;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final opacity = entrance.clamp(0.0, 1.0);
    final scaleAnim = 0.92 + 0.08 * Curves.easeOutBack.transform(opacity);
    final translateY = (1.0 - opacity) * 24.0;

    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(0, translateY),
        child: Transform.scale(
          scale: scaleAnim,
          child: _Frame(
            isDark: isDark,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: <Widget>[
                Positioned.fill(
                  child: IgnorePointer(
                    child: _CelebrationField(
                      celebratePhase: celebratePhase,
                      isDark: isDark,
                    ),
                  ),
                ),
                Padding(
                  padding: PlaygroundSizes.levelRewardDialogPadding,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height:
                            PlaygroundSizes.levelRewardDialogChestOffsetY +
                            (PlaygroundSizes.levelRewardDialogChestSize *
                                scale),
                      ),
                      _Header(visual: visual, isDark: isDark, scale: scale),
                      const SizedBox(height: AppSpacing.lg),
                      _RewardRow(
                        visual: visual,
                        isDark: isDark,
                        scale: scale,
                        floatTweens: floatTweens,
                        chestProgress: chestProgress,
                      ),
                      if (visual.unlockedTitles.isNotEmpty) ...<Widget>[
                        const SizedBox(height: AppSpacing.lg),
                        _UnlockedTitles(visual: visual, isDark: isDark),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      _Actions(
                        visual: visual,
                        isDark: isDark,
                        primaryLabel: primaryLabel,
                        secondaryLabel: secondaryLabel,
                        onPrimary: onPrimary,
                        onSecondary: onSecondary,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -PlaygroundSizes.levelRewardDialogChestOffsetY * 0.5,
                  child: _ChestStack(
                    chestProgress: chestProgress,
                    visual: visual,
                    isDark: isDark,
                    scale: scale,
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

class _Frame extends StatelessWidget {
  const _Frame({required this.isDark, required this.child});

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final fill = isDark ? AppColors.darkSurface : AppColors.lightBackground;
    return Container(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(
          PlaygroundSizes.levelRewardDialogCornerRadius,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.nodeDropShadow,
            blurRadius: PlaygroundSizes.levelRewardDialogShadowBlur,
            offset: PlaygroundSizes.levelRewardDialogShadowOffset,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ChestStack extends StatelessWidget {
  const _ChestStack({
    required this.chestProgress,
    required this.visual,
    required this.isDark,
    required this.scale,
  });

  final double chestProgress;
  final LevelRewardDialogVisual visual;
  final bool isDark;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final chestScale = chestProgress.clamp(0.0, 1.0);
    final eased = Curves.easeOutBack.transform(
      chestScale == 1.0 ? 1.0 : chestScale,
    );
    final size = PlaygroundSizes.levelRewardDialogChestSize * scale;
    return Transform.scale(
      scale: eased,
      child: SizedBox(
        width: size,
        height: size,
        child: RepaintBoundary(
          child: RewardChest(
            state: RewardChestState.opened,
            size: RewardChestSize.large,
            isDark: isDark,
            rarity: visual.rarity,
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.visual,
    required this.isDark,
    required this.scale,
  });

  final LevelRewardDialogVisual visual;
  final bool isDark;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final title = PlaygroundStrings.levelRewardDialogTitle;
    final subtitle =
        visual.nextLevelStatus == LevelRewardDialogNextLevel.hasNext
        ? PlaygroundStrings.levelRewardDialogNextLevelTemplate.replaceFirst(
            '%d',
            '${visual.nextLevelNumber}',
          )
        : PlaygroundStrings.levelRewardDialogSubtitle;
    final textColor = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    return Column(
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w800,
            fontSize: PlaygroundSizes.levelRewardDialogTitleFontSize * scale,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Level ${visual.levelNumber}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: PlaygroundColors.progressionPremium,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: muted,
            fontSize: PlaygroundSizes.levelRewardDialogSubtitleFontSize * scale,
          ),
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
    required this.floatTweens,
    required this.chestProgress,
  });

  final LevelRewardDialogVisual visual;
  final bool isDark;
  final double scale;
  final List<Animation<double>> floatTweens;
  final double chestProgress;

  @override
  Widget build(BuildContext context) {
    final orbSize = PlaygroundSizes.levelRewardDialogOrbSize * scale;
    final children = <Widget>[
      _RewardOrb(
        amount: visual.xpEarned,
        label: PlaygroundStrings.xpLabel,
        isDark: isDark,
        size: orbSize,
        floatTween: floatTweens.isNotEmpty ? floatTweens[0] : null,
        chestProgress: chestProgress,
        color: PlaygroundColors.xp,
        useXp: true,
      ),
      SizedBox(width: PlaygroundSizes.levelRewardDialogOrbGap),
      _RewardOrb(
        amount: visual.coinsEarned,
        label: PlaygroundStrings.coinShortLabel,
        isDark: isDark,
        size: orbSize,
        floatTween: floatTweens.length > 1 ? floatTweens[1] : null,
        chestProgress: chestProgress,
        color: PlaygroundColors.coin,
        useXp: false,
      ),
    ];

    if (visual.badgeEarned != null) {
      children.add(SizedBox(width: PlaygroundSizes.levelRewardDialogOrbGap));
      children.add(
        _BadgeTile(
          title: visual.badgeEarned!,
          isDark: isDark,
          floatTween: floatTweens.length > 2 ? floatTweens[2] : null,
          chestProgress: chestProgress,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}

class _RewardOrb extends StatelessWidget {
  const _RewardOrb({
    required this.amount,
    required this.label,
    required this.isDark,
    required this.size,
    required this.color,
    required this.chestProgress,
    required this.useXp,
    this.floatTween,
  });

  final int amount;
  final String label;
  final bool isDark;
  final double size;
  final Color color;
  final double chestProgress;
  final bool useXp;
  final Animation<double>? floatTween;

  @override
  Widget build(BuildContext context) {
    final opacity = chestProgress.clamp(0.0, 1.0);
    final translate = (floatTween?.value ?? 0) * -1.0;
    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(0, translate),
        child: SizedBox(
          width: size,
          height: size + 18,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: size,
                height: size,
                child: useXp
                    ? XpReward(
                        amount: amount,
                        size: XpRewardSize.large,
                        isDark: isDark,
                      )
                    : CoinReward(
                        amount: amount,
                        size: CoinRewardSize.large,
                        isDark: isDark,
                      ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({
    required this.title,
    required this.isDark,
    required this.chestProgress,
    this.floatTween,
  });

  final String title;
  final bool isDark;
  final double chestProgress;
  final Animation<double>? floatTween;

  @override
  Widget build(BuildContext context) {
    final opacity = chestProgress.clamp(0.0, 1.0);
    final translate = (floatTween?.value ?? 0) * -1.0;
    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(0, translate),
        child: SizedBox(
          width: PlaygroundSizes.levelRewardDialogOrbSize,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: PlaygroundSizes.levelRewardDialogOrbSize,
                height: PlaygroundSizes.levelRewardDialogOrbSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PlaygroundColors.progressionPremium.withValues(
                    alpha: 0.18,
                  ),
                  border: Border.all(
                    color: PlaygroundColors.progressionPremium,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.emoji_events,
                  size: PlaygroundSizes.levelRewardDialogOrbSize * 0.5,
                  color: PlaygroundColors.progressionPremium,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: PlaygroundColors.progressionPremium,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                PlaygroundStrings.levelRewardDialogBadgeUnlocked,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnlockedTitles extends StatelessWidget {
  const _UnlockedTitles({required this.visual, required this.isDark});

  final LevelRewardDialogVisual visual;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      alignment: WrapAlignment.center,
      children: <Widget>[
        for (final title in visual.unlockedTitles)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                WidgetConstants.outlineThickness * 6,
              ),
              color: PlaygroundColors.progressionPremium.withValues(
                alpha: 0.18,
              ),
              border: Border.all(
                color: PlaygroundColors.progressionPremium.withValues(
                  alpha: 0.6,
                ),
              ),
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: PlaygroundColors.progressionPremium,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        if (visual.unlockedTitles.isEmpty)
          Text(
            ' ',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: muted),
          ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.visual,
    required this.isDark,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimary,
    required this.onSecondary,
  });

  final LevelRewardDialogVisual visual;
  final bool isDark;
  final String? primaryLabel;
  final String? secondaryLabel;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final primary =
        primaryLabel ?? PlaygroundStrings.levelRewardDialogContinueAction;
    final secondary = secondaryLabel;
    return Row(
      children: <Widget>[
        if (secondary != null && onSecondary != null) ...<Widget>[
          Expanded(
            child: _SecondaryButton(
              label: secondary,
              isDark: isDark,
              onTap: onSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
        ],
        Expanded(
          flex: 2,
          child: _PrimaryButton(
            label: primary,
            isDark: isDark,
            onTap: onPrimary,
            isEndOfPath:
                visual.nextLevelStatus == LevelRewardDialogNextLevel.endOfPath,
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.isDark,
    required this.onTap,
    required this.isEndOfPath,
  });

  final String label;
  final bool isDark;
  final VoidCallback? onTap;
  final bool isEndOfPath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: PlaygroundSizes.levelRewardDialogCtaHeight,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: isEndOfPath
              ? PlaygroundColors.progressionPremium
              : PlaygroundColors.progressionUnlocked,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              PlaygroundSizes.levelRewardDialogCtaRadius,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: PlaygroundSizes.levelRewardDialogCtaFontSize,
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool isDark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    return SizedBox(
      height: PlaygroundSizes.levelRewardDialogCtaHeight,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: muted.withValues(alpha: 0.4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              PlaygroundSizes.levelRewardDialogCtaRadius,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: muted,
            fontWeight: FontWeight.w700,
            fontSize: PlaygroundSizes.levelRewardDialogCtaFontSize,
          ),
        ),
      ),
    );
  }
}

class _CelebrationField extends StatelessWidget {
  const _CelebrationField({required this.celebratePhase, required this.isDark});

  final double celebratePhase;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _CelebrationPainter(phase: celebratePhase, isDark: isDark),
      ),
    );
  }
}

class _CelebrationPainter extends CustomPainter {
  _CelebrationPainter({required this.phase, required this.isDark});

  final double phase;
  final bool isDark;

  static final Paint _paint = Paint()..style = PaintingStyle.fill;

  static const int _particleCount = 16;
  static const double _twoPi = math.pi * 2;

  @override
  void paint(Canvas canvas, Size size) {
    if (phase <= 0) return;
    final radius = math.max(size.width, size.height) * 0.55;
    final center = Offset(size.width / 2, size.height * 0.15);
    final palette = <Color>[
      PlaygroundColors.progressionPremium,
      PlaygroundColors.xp,
      PlaygroundColors.coin,
      PlaygroundColors.progressionUnlocked,
      PlaygroundColors.progressionBoss,
    ];
    for (var i = 0; i < _particleCount; i++) {
      final theta = (_twoPi * i) / _particleCount;
      final progress = (phase + i / _particleCount) % 1.0;
      final r = radius * progress;
      final pos =
          center + Offset(math.cos(theta) * r, math.sin(theta) * r * 0.85);
      final dotSize = 4.0 + (i % 3) * 1.0;
      _paint.color = palette[i % palette.length].withValues(
        alpha: (1.0 - progress) * 0.6,
      );
      canvas.drawCircle(pos, dotSize, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CelebrationPainter old) =>
      old.phase != phase || old.isDark != isDark;
}
