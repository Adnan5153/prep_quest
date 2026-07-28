import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/overlays/coin_counter.dart';
import '../../../../../../../../features/playground/presentation/widgets/overlays/energy_indicator.dart';
import '../../../../../../../../features/playground/presentation/widgets/overlays/playground_top_bar.dart';
import '../../../../../../../../features/playground/presentation/widgets/overlays/profile_summary.dart';
import '../../../../../../../../features/playground/presentation/widgets/overlays/streak_card.dart';
import '../../../../../../../../features/playground/presentation/widgets/overlays/xp_indicator.dart';
import '../../../providers/widget_builder_provider.dart';

class PlaygroundTopBarPreview extends StatelessWidget {
  const PlaygroundTopBarPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = _mapBrightness(provider.playgroundTopBarBrightness);
    final controlled = _buildTopBar(provider);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Playground Top Bar', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Composed HUD: profile + XP + coins + energy + streak',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            _ThemedTileRow(brightness: brightness, child: controlled),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Responsive Widths',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _WidthTile(label: 'Mobile · 360 dp', width: 360),
                  const SizedBox(height: AppSpacing.md),
                  _WidthTile(label: 'Tablet · 768 dp', width: 768),
                  const SizedBox(height: AppSpacing.md),
                  _WidthTile(label: 'Desktop · 1280 dp', width: 1280),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Scenario Presets',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const <Widget>[
                  _ScenarioTile(
                    label: 'Healthy Run',
                    profileName: 'Aarav Khan',
                    level: 14,
                    xpInLevel: 220,
                    xpForNextLevel: 500,
                    coins: 1840,
                    remaining: 5,
                    max: 5,
                    streakDays: 27,
                  ),
                  _ScenarioTile(
                    label: 'Energy Low',
                    profileName: 'Maya Chen',
                    level: 27,
                    xpInLevel: 410,
                    xpForNextLevel: 500,
                    coins: 9200,
                    remaining: 1,
                    max: 5,
                    streakDays: 6,
                  ),
                  _ScenarioTile(
                    label: 'Streak at Risk',
                    profileName: 'Noah Park',
                    level: 3,
                    xpInLevel: 50,
                    xpForNextLevel: 500,
                    coins: 230,
                    remaining: 0,
                    max: 5,
                    streakDays: 1,
                  ),
                  _ScenarioTile(
                    label: 'Big Reward',
                    profileName: 'Saanvi Rao',
                    level: 42,
                    xpInLevel: 480,
                    xpForNextLevel: 500,
                    coins: 12500,
                    remaining: 4,
                    max: 5,
                    streakDays: 100,
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

ProfileVisual _buildProfile(WidgetBuilderProvider provider) {
  final leagueRaw = provider.playgroundProfileSummaryLeagueName;
  final league = leagueRaw == null || leagueRaw.isEmpty ? null : leagueRaw;
  return ProfileVisual(
    displayName: provider.playgroundProfileSummaryDisplayName,
    level: provider.playgroundProfileSummaryLevel,
    initials: provider.playgroundProfileSummaryInitials,
    isOnline: provider.playgroundProfileSummaryIsOnline,
    isPremium: provider.playgroundProfileSummaryIsPremium,
    notificationCount: provider.playgroundProfileSummaryNotificationCount,
    leagueName: league,
  );
}

XpVisual _buildXp(WidgetBuilderProvider provider) {
  return XpVisual(
    totalXp: provider.playgroundXpIndicatorTotalXp,
    userLevel: provider.playgroundXpIndicatorUserLevel,
    xpInLevel: provider.playgroundXpIndicatorXpInLevel,
    xpForNextLevel: provider.playgroundXpIndicatorXpForNextLevel,
    gainDelta: provider.playgroundXpIndicatorGainDelta,
    isAnimatingGain: provider.playgroundXpIndicatorIsAnimatingGain,
  );
}

CoinVisual _buildCoin(WidgetBuilderProvider provider) {
  return CoinVisual(
    balance: provider.playgroundCoinCounterBalance,
    gainDelta: provider.playgroundCoinCounterGainDelta,
    isAnimatingGain: provider.playgroundCoinCounterIsAnimatingGain,
  );
}

EnergyVisual _buildEnergy(WidgetBuilderProvider provider) {
  return EnergyVisual(
    remaining: provider.playgroundEnergyIndicatorRemaining,
    max: provider.playgroundEnergyIndicatorMax,
    rechargeSecondsRemaining: provider.playgroundEnergyIndicatorRechargeSeconds,
    isAnimatingRefill: provider.playgroundEnergyIndicatorIsAnimatingRefill,
  );
}

StreakVisual _buildStreak(WidgetBuilderProvider provider) {
  return StreakVisual(
    days: provider.playgroundStreakCardDays,
    isAtRisk: provider.playgroundStreakCardIsAtRisk,
    milestoneReached: provider.playgroundStreakCardMilestoneReached,
  );
}

PlaygroundTopBar _buildTopBar(WidgetBuilderProvider provider) {
  return PlaygroundTopBar(
    profile: _buildProfile(provider),
    xp: _buildXp(provider),
    coins: _buildCoin(provider),
    energy: _buildEnergy(provider),
    streak: _buildStreak(provider),
  );
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

class _WidthTile extends StatelessWidget {
  const _WidthTile({required this.label, required this.width});
  final String label;
  final double width;

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
          child: SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: _buildSampleTopBar(),
            ),
          ),
        ),
      ],
    );
  }

  PlaygroundTopBar _buildSampleTopBar() {
    return PlaygroundTopBar(
      profile: const ProfileVisual(
        displayName: 'Aarav Khan',
        level: 14,
        initials: 'AK',
        isOnline: true,
        notificationCount: 3,
        leagueName: 'Sapphire League',
      ),
      xp: const XpVisual(
        totalXp: 4720,
        userLevel: 14,
        xpInLevel: 220,
        xpForNextLevel: 500,
      ),
      coins: const CoinVisual(balance: 1840),
      energy: const EnergyVisual(remaining: 4, max: 5),
      streak: const StreakVisual(days: 27),
    );
  }
}

class _ScenarioTile extends StatelessWidget {
  const _ScenarioTile({
    required this.label,
    required this.profileName,
    required this.level,
    required this.xpInLevel,
    required this.xpForNextLevel,
    required this.coins,
    required this.remaining,
    required this.max,
    required this.streakDays,
  });

  final String label;
  final String profileName;
  final int level;
  final int xpInLevel;
  final int xpForNextLevel;
  final int coins;
  final int remaining;
  final int max;
  final int streakDays;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _ThemedTile(
            brightness: Brightness.light,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: PlaygroundTopBar(
                profile: ProfileVisual(
                  displayName: profileName,
                  level: level,
                  initials: _initials(profileName),
                ),
                xp: XpVisual(
                  totalXp: level * xpForNextLevel,
                  userLevel: level,
                  xpInLevel: xpInLevel,
                  xpForNextLevel: xpForNextLevel,
                ),
                coins: CoinVisual(balance: coins),
                energy: EnergyVisual(remaining: remaining, max: max),
                streak: StreakVisual(
                  days: streakDays,
                  isAtRisk: remaining <= 1 && streakDays > 0,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return '${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}'
        .toUpperCase();
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
            final wide = constraints.maxWidth >= 480;
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
