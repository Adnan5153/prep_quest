import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/overlays/profile_summary.dart';
import '../../../providers/widget_builder_provider.dart';

class ProfileSummaryPreview extends StatelessWidget {
  const ProfileSummaryPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = _mapBrightness(
      provider.playgroundProfileSummaryBrightness,
    );
    final controlled = _buildProfile(provider);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Profile Summary', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            _ThemedTileRow(
              brightness: brightness,
              child: ProfileSummary(visual: controlled),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Identity Presets',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const <Widget>[
                  _PresetTile(
                    name: 'Aarav Khan',
                    initials: 'AK',
                    level: 14,
                    isOnline: true,
                    isPremium: false,
                    notifications: 3,
                    league: 'Sapphire League',
                  ),
                  _PresetTile(
                    name: 'Maya Chen',
                    initials: 'MC',
                    level: 27,
                    isOnline: true,
                    isPremium: true,
                    notifications: 0,
                    league: 'Diamond League',
                  ),
                  _PresetTile(
                    name: 'Noah Park',
                    initials: 'NP',
                    level: 3,
                    isOnline: false,
                    isPremium: false,
                    notifications: 1,
                    league: null,
                  ),
                  _PresetTile(
                    name: 'Saanvi Rao',
                    initials: 'SR',
                    level: 42,
                    isOnline: true,
                    isPremium: true,
                    notifications: 12,
                    league: 'Legend League',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Notification States',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const <Widget>[
                  _NotificationTile(count: 0),
                  _NotificationTile(count: 1),
                  _NotificationTile(count: 5),
                  _NotificationTile(count: 12),
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

class _PresetTile extends StatelessWidget {
  const _PresetTile({
    required this.name,
    required this.initials,
    required this.level,
    required this.isOnline,
    required this.isPremium,
    required this.notifications,
    required this.league,
  });

  final String name;
  final String initials;
  final int level;
  final bool isOnline;
  final bool isPremium;
  final int notifications;
  final String? league;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 96,
            child: Center(
              child: ProfileSummary(
                visual: ProfileVisual(
                  displayName: name,
                  level: level,
                  initials: initials,
                  isOnline: isOnline,
                  isPremium: isPremium,
                  notificationCount: notifications,
                  leagueName: league,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            name,
            style: Theme.of(context).textTheme.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Lvl $level ${isPremium ? '· Premium' : ''}',
            style: Theme.of(context).textTheme.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 96,
            child: Center(
              child: ProfileSummary(
                visual: ProfileVisual(
                  displayName: 'Player',
                  level: 12,
                  initials: 'PL',
                  notificationCount: count,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            count == 0 ? 'No notifications' : '$count notifications',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
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
              child: Center(child: child),
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
              child: Center(child: child),
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
                    child: Center(child: child),
                  ),
                ),
              ),
              SizedBox(
                width: halfWidth,
                child: _ThemedTile(
                  brightness: Brightness.dark,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Center(child: child),
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
