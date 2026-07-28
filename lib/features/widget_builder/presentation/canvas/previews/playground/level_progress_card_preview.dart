import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../features/playground/presentation/widgets/cards/level_progress_card.dart';
import '../../../providers/widget_builder_provider.dart';

class LevelProgressCardPreview extends StatelessWidget {
  const LevelProgressCardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = _mapBrightness(
      provider.playgroundLevelProgressCardBrightness,
    );

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Level Progress Card', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Stage-by-stage progression with stars and reward',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            _ThemedTileRow(
              brightness: brightness,
              child: _buildControlled(provider),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'State Showcase',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  _StateTile(
                    label: 'Current',
                    visual: LevelProgressVisual(
                      level: 14,
                      totalStages: 6,
                      completedStages: 2,
                      totalStars: 3,
                      earnedStars: 1,
                      currentXP: 220,
                      requiredXP: 500,
                      state: LevelCardState.current,
                      title: 'Ancient Civilizations',
                      subtitle: 'Earn XP to reach the next stage',
                      reward: LevelProgressReward.xp(250),
                    ),
                  ),
                  _StateTile(
                    label: 'Completed',
                    visual: LevelProgressVisual(
                      level: 13,
                      totalStages: 6,
                      completedStages: 6,
                      totalStars: 3,
                      earnedStars: 3,
                      currentXP: 500,
                      requiredXP: 500,
                      state: LevelCardState.completed,
                      title: 'Ancient Civilizations',
                      subtitle: 'Stage completed',
                      reward: LevelProgressReward.coin(120),
                    ),
                  ),
                  _StateTile(
                    label: 'Locked',
                    visual: LevelProgressVisual(
                      level: 15,
                      totalStages: 6,
                      completedStages: 0,
                      totalStars: 3,
                      earnedStars: 0,
                      currentXP: 0,
                      requiredXP: 500,
                      state: LevelCardState.locked,
                      title: 'Renaissance Masters',
                      subtitle: 'Reach level 14 to unlock',
                      reward: LevelProgressReward.gem(40),
                    ),
                  ),
                  _StateTile(
                    label: 'Premium',
                    visual: LevelProgressVisual(
                      level: 22,
                      totalStages: 6,
                      completedStages: 4,
                      totalStars: 3,
                      earnedStars: 2,
                      currentXP: 380,
                      requiredXP: 500,
                      state: LevelCardState.premium,
                      title: 'Quantum Physics',
                      subtitle: 'Premium track',
                      reward: LevelProgressReward.badge(1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Responsive Widths',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _WidthTile(
                    label: 'Mobile · 320 dp',
                    width: 320,
                    visual: _sampleVisual(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _WidthTile(
                    label: 'Tablet · 480 dp',
                    width: 480,
                    visual: _sampleVisual(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _WidthTile(
                    label: 'Desktop · 640 dp',
                    width: 640,
                    visual: _sampleVisual(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LevelProgressVisual _sampleVisual() {
    return LevelProgressVisual(
      level: 14,
      totalStages: 6,
      completedStages: 2,
      totalStars: 3,
      earnedStars: 1,
      currentXP: 220,
      requiredXP: 500,
      title: 'Ancient Civilizations',
      subtitle: 'Earn XP to reach the next stage',
      reward: LevelProgressReward.xp(250),
    );
  }
}

LevelProgressCard _buildControlled(WidgetBuilderProvider provider) {
  final state = _mapState(provider.playgroundLevelProgressCardState);
  final reward = _buildReward(
    provider.playgroundLevelProgressCardRewardKind,
    provider.playgroundLevelProgressCardRewardAmount,
  );

  return LevelProgressCard(
    visual: LevelProgressVisual(
      level: provider.playgroundLevelProgressCardLevel,
      totalStages: provider.playgroundLevelProgressCardTotalStages,
      completedStages: provider.playgroundLevelProgressCardCompletedStages,
      totalStars: provider.playgroundLevelProgressCardTotalStars,
      earnedStars: provider.playgroundLevelProgressCardEarnedStars,
      currentXP: provider.playgroundLevelProgressCardCurrentXP,
      requiredXP: provider.playgroundLevelProgressCardRequiredXP,
      state: state,
      title: provider.playgroundLevelProgressCardTitle,
      subtitle: provider.playgroundLevelProgressCardSubtitle,
      reward: reward,
    ),
    onTap: () {},
  );
}

LevelCardState _mapState(String value) {
  switch (value) {
    case 'completed':
      return LevelCardState.completed;
    case 'locked':
      return LevelCardState.locked;
    case 'premium':
      return LevelCardState.premium;
    default:
      return LevelCardState.current;
  }
}

LevelProgressReward _buildReward(String kind, int amount) {
  switch (kind) {
    case 'coin':
      return LevelProgressReward.coin(amount);
    case 'gem':
      return LevelProgressReward.gem(amount);
    case 'badge':
      return LevelProgressReward.badge(amount);
    default:
      return LevelProgressReward.xp(amount);
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.md),
        child,
      ],
    );
  }
}

class _StateTile extends StatelessWidget {
  const _StateTile({required this.label, required this.visual});

  final String label;
  final LevelProgressVisual visual;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 340,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _ThemedTile(
            brightness: Brightness.light,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: LevelProgressCard(visual: visual, onTap: () {}),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: theme.textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _WidthTile extends StatelessWidget {
  const _WidthTile({
    required this.label,
    required this.width,
    required this.visual,
  });

  final String label;
  final double width;
  final LevelProgressVisual visual;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: theme.textTheme.labelSmall),
        const SizedBox(height: AppSpacing.sm),
        _ThemedTile(
          brightness: Brightness.light,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SizedBox(
              width: width,
              child: Center(
                child: LevelProgressCard(visual: visual, onTap: () {}),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ThemedTileRow extends StatelessWidget {
  const _ThemedTileRow({required this.brightness, required this.child});

  final _BrightnessMode brightness;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    switch (brightness) {
      case _BrightnessMode.light:
        return SizedBox(
          width: double.infinity,
          child: _ThemedTile(
            brightness: Brightness.light,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: child,
            ),
          ),
        );
      case _BrightnessMode.dark:
        return SizedBox(
          width: double.infinity,
          child: _ThemedTile(
            brightness: Brightness.dark,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: child,
            ),
          ),
        );
      case _BrightnessMode.sideBySide:
        return LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 720;
            final halfWidth = wide ? (constraints.maxWidth - 12) / 2 : null;
            final tiles = <Widget>[
              SizedBox(
                width: halfWidth,
                child: _ThemedTile(
                  brightness: Brightness.light,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: child,
                  ),
                ),
              ),
              SizedBox(
                width: halfWidth,
                child: _ThemedTile(
                  brightness: Brightness.dark,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: child,
                  ),
                ),
              ),
            ];
            return wide
                ? Row(children: tiles)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      tiles[0],
                      const SizedBox(height: AppSpacing.lg),
                      tiles[1],
                    ],
                  );
          },
        );
    }
  }
}

class _ThemedTile extends StatelessWidget {
  const _ThemedTile({required this.brightness, required this.child});

  final Brightness brightness;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
    return Container(
      decoration: BoxDecoration(
        color: brightness == Brightness.dark
            ? const Color(0xFF15151B)
            : const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(data: theme, child: child),
    );
  }
}

enum _BrightnessMode { light, dark, sideBySide }

_BrightnessMode _mapBrightness(String value) {
  switch (value) {
    case 'lightOnly':
      return _BrightnessMode.light;
    case 'darkOnly':
      return _BrightnessMode.dark;
    default:
      return _BrightnessMode.sideBySide;
  }
}
