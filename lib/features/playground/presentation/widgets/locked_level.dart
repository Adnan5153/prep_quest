import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../constants/playground_constants.dart';
import '../constants/playground_sizes.dart';
import '../constants/playground_strings.dart';

enum LockedLevelRequirement { level, missions, premium, custom }

class LockedLevelRequirementSpec {
  const LockedLevelRequirementSpec({required this.kind, required this.label});

  final LockedLevelRequirement kind;
  final String label;
}

class LockedLevelVisual {
  const LockedLevelVisual({
    required this.levelNumber,
    required this.title,
    this.subtitle,
    required this.requirements,
    this.animate = true,
  });

  final int levelNumber;
  final String title;
  final String? subtitle;
  final List<LockedLevelRequirementSpec> requirements;
  final bool animate;
}

class LockedLevel extends StatefulWidget {
  const LockedLevel({super.key, required this.visual, this.onTap});

  final LockedLevelVisual visual;
  final VoidCallback? onTap;

  @override
  State<LockedLevel> createState() => _LockedLevelState();
}

class _LockedLevelState extends State<LockedLevel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController = AnimationController(
    vsync: this,
    duration: PlaygroundDurations.lockedLevelShimmer,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateMotion();
  }

  @override
  void didUpdateWidget(covariant LockedLevel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visual.animate != widget.visual.animate) {
      _updateMotion();
    }
  }

  void _updateMotion() {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    if (reducedMotion || !widget.visual.animate) {
      _shimmerController.stop();
      _shimmerController.value = 0.0;
      return;
    }
    if (!_shimmerController.isAnimating) {
      _shimmerController.repeat();
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final semantic =
        '${PlaygroundStrings.lockedLevelSemantic} '
        '${widget.visual.levelNumber}: ${widget.visual.title}';

    return RepaintBoundary(
      child: Semantics(
        label: semantic,
        button: widget.onTap != null,
        enabled: false,
        container: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) => _LockedLevelSurface(
              visual: widget.visual,
              isDark: isDark,
              shimmerPhase: _shimmerController.value,
            ),
          ),
        ),
      ),
    );
  }
}

class _LockedLevelSurface extends StatelessWidget {
  const _LockedLevelSurface({
    required this.visual,
    required this.isDark,
    required this.shimmerPhase,
  });

  final LockedLevelVisual visual;
  final bool isDark;
  final double shimmerPhase;

  @override
  Widget build(BuildContext context) {
    final fillColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightBackground;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.06);
    final textColor = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return Opacity(
      opacity: PlaygroundAlpha.progressionLockedOverlay,
      child: Container(
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(
            PlaygroundSizes.lockedLevelCornerRadius,
          ),
          border: Border.all(
            color: borderColor,
            width: PlaygroundSizes.cardBorderWidth,
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: AppColors.nodeDropShadow,
              blurRadius: PlaygroundSizes.challengeTileShadowBlur,
              offset: PlaygroundSizes.challengeTileShadowOffset,
            ),
          ],
        ),
        padding: PlaygroundSizes.lockedLevelPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _LockBadge(isDark: isDark),
            SizedBox(width: PlaygroundSizes.lockedLevelIconOffset),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Level ${visual.levelNumber} · ${visual.title}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (visual.subtitle != null && visual.subtitle!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: PlaygroundSizes.cardStackGap,
                      ),
                      child: Text(
                        visual.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: muted),
                      ),
                    ),
                  if (visual.requirements.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: PlaygroundSizes.cardInnerGap,
                      ),
                      child: Wrap(
                        spacing: PlaygroundSizes.cardStackGap,
                        runSpacing: PlaygroundSizes.cardStackGap,
                        children: <Widget>[
                          for (final req in visual.requirements)
                            _RequirementChip(spec: req, muted: muted),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: PlaygroundSizes.cardInnerGap),
            Opacity(
              opacity: 1.0,
              child: Icon(
                Icons.lock_outline,
                size: PlaygroundSizes.lockedLevelIconSize,
                color: PlaygroundColors.progressionLocked,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LockBadge extends StatelessWidget {
  const _LockBadge({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
    return Container(
      width: PlaygroundSizes.lockedLevelIconSize,
      height: PlaygroundSizes.lockedLevelIconSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        border: Border.all(
          color: PlaygroundColors.progressionLocked.withValues(alpha: 0.45),
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.lock,
        size: PlaygroundSizes.lockedLevelIconSize * 0.6,
        color: PlaygroundColors.progressionLocked,
      ),
    );
  }
}

class _RequirementChip extends StatelessWidget {
  const _RequirementChip({required this.spec, required this.muted});

  final LockedLevelRequirementSpec spec;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    final icon = switch (spec.kind) {
      LockedLevelRequirement.level => Icons.signal_cellular_alt,
      LockedLevelRequirement.missions => Icons.checklist,
      LockedLevelRequirement.premium => Icons.star_outline,
      LockedLevelRequirement.custom => Icons.info_outline,
    };
    final color = switch (spec.kind) {
      LockedLevelRequirement.level => PlaygroundColors.progressionInProgress,
      LockedLevelRequirement.missions => PlaygroundColors.progressionCompleted,
      LockedLevelRequirement.premium => PlaygroundColors.progressionPremium,
      LockedLevelRequirement.custom => muted,
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: PlaygroundSizes.cardTagPaddingHorizontal,
        vertical: PlaygroundSizes.cardTagPaddingVertical,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          PlaygroundSizes.cardTagCornerRadius,
        ),
        border: Border.all(color: muted.withValues(alpha: 0.4)),
        color: color.withValues(alpha: 0.10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            size: PlaygroundSizes.levelCardTagFontSize + 3,
            color: color,
          ),
          const SizedBox(width: PlaygroundSizes.cardStackGap),
          Text(
            spec.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: PlaygroundSizes.lockedLevelRequirementFontSize,
            ),
          ),
        ],
      ),
    );
  }
}
