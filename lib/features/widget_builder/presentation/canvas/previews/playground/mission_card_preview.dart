import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../features/playground/presentation/widgets/cards/mission_card.dart';
import '../../../providers/widget_builder_provider.dart';

class MissionCardPreview extends StatelessWidget {
  const MissionCardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = _mapBrightness(provider.playgroundMissionCardBrightness);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Mission Card', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Quest card with progress, timer, reward and claim action',
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
                    label: 'Active',
                    visual: MissionVisual(
                      id: 'demo-active',
                      title: 'Solve 5 Daily Quizzes',
                      description:
                          'Complete five quizzes in any category before midnight.',
                      required: 5,
                      progress: 3,
                      reward: MissionCardReward.xp(150),
                      state: MissionCardState.active,
                      tag: MissionCardTag.daily,
                      timerSecondsRemaining: 5400,
                    ),
                  ),
                  _StateTile(
                    label: 'Completed',
                    visual: MissionVisual(
                      id: 'demo-completed',
                      title: 'Weekly Streak Champion',
                      description: 'Maintain a 7-day streak for bonus gems.',
                      required: 7,
                      progress: 7,
                      reward: MissionCardReward.gem(20),
                      state: MissionCardState.completed,
                      tag: MissionCardTag.weekly,
                    ),
                  ),
                  _StateTile(
                    label: 'Locked',
                    visual: MissionVisual(
                      id: 'demo-locked',
                      title: 'Premium Trial Challenge',
                      description: 'Unlock by reaching Sapphire League.',
                      required: 10,
                      progress: 0,
                      reward: MissionCardReward.badge(1),
                      state: MissionCardState.locked,
                      tag: MissionCardTag.premium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Tag Variants',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  _StateTile(
                    label: 'Daily',
                    visual: MissionVisual(
                      id: 'tag-daily',
                      title: 'Daily Practice',
                      description: 'Answer ten questions today.',
                      required: 10,
                      progress: 4,
                      reward: MissionCardReward.xp(80),
                      state: MissionCardState.active,
                      tag: MissionCardTag.daily,
                      timerSecondsRemaining: 7200,
                    ),
                  ),
                  _StateTile(
                    label: 'Weekly',
                    visual: MissionVisual(
                      id: 'tag-weekly',
                      title: 'Weekly Marathon',
                      description: 'Solve fifty questions this week.',
                      required: 50,
                      progress: 32,
                      reward: MissionCardReward.coin(500),
                      state: MissionCardState.active,
                      tag: MissionCardTag.weekly,
                      timerSecondsRemaining: 259200,
                    ),
                  ),
                  _StateTile(
                    label: 'Premium',
                    visual: MissionVisual(
                      id: 'tag-premium',
                      title: 'Premium Sprint',
                      description: 'Beat three premium exams.',
                      required: 3,
                      progress: 1,
                      reward: MissionCardReward.gem(75),
                      state: MissionCardState.active,
                      tag: MissionCardTag.premium,
                      timerSecondsRemaining: 86400,
                    ),
                  ),
                  _StateTile(
                    label: 'Special',
                    visual: MissionVisual(
                      id: 'tag-special',
                      title: 'Founders Festival',
                      description: 'Participate in the founder event.',
                      required: 1,
                      progress: 0,
                      reward: MissionCardReward.badge(1),
                      state: MissionCardState.active,
                      tag: MissionCardTag.special,
                      timerSecondsRemaining: 172800,
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

  MissionVisual _sampleVisual() {
    return MissionVisual(
      id: 'sample-mission',
      title: 'Solve 5 Daily Quizzes',
      description: 'Complete five quizzes in any category before midnight.',
      required: 5,
      progress: 3,
      reward: MissionCardReward.xp(150),
      state: MissionCardState.active,
      tag: MissionCardTag.daily,
      timerSecondsRemaining: 5400,
    );
  }
}

MissionCard _buildControlled(WidgetBuilderProvider provider) {
  final state = _mapState(provider.playgroundMissionCardState);
  final tag = _mapTag(provider.playgroundMissionCardTag);
  final reward = _buildReward(
    provider.playgroundMissionCardRewardKind,
    provider.playgroundMissionCardRewardAmount,
  );

  final visual = MissionVisual(
    id: 'wb-mission',
    title: provider.playgroundMissionCardTitle,
    description: provider.playgroundMissionCardDescription,
    required: provider.playgroundMissionCardRequired,
    progress: provider.playgroundMissionCardProgress,
    reward: reward,
    state: state,
    tag: tag,
    timerSecondsRemaining: provider.playgroundMissionCardTimerSeconds,
  );

  return MissionCard(
    visual: visual,
    onTap: () {},
    onClaim: state == MissionCardState.completed ? () {} : null,
  );
}

MissionCardState _mapState(String value) {
  switch (value) {
    case 'completed':
      return MissionCardState.completed;
    case 'locked':
      return MissionCardState.locked;
    default:
      return MissionCardState.active;
  }
}

MissionCardTag _mapTag(String value) {
  switch (value) {
    case 'weekly':
      return MissionCardTag.weekly;
    case 'premium':
      return MissionCardTag.premium;
    case 'special':
      return MissionCardTag.special;
    default:
      return MissionCardTag.daily;
  }
}

MissionCardReward _buildReward(String kind, int amount) {
  switch (kind) {
    case 'coin':
      return MissionCardReward.coin(amount);
    case 'gem':
      return MissionCardReward.gem(amount);
    case 'badge':
      return MissionCardReward.badge(amount);
    default:
      return MissionCardReward.xp(amount);
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
  final MissionVisual visual;

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
              child: MissionCard(
                visual: visual,
                onTap: () {},
                onClaim: visual.isCompleted ? () {} : null,
              ),
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
  final MissionVisual visual;

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
                child: MissionCard(
                  visual: visual,
                  onTap: () {},
                  onClaim: visual.isCompleted ? () {} : null,
                ),
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
