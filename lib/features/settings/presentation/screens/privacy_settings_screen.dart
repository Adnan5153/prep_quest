import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../router.dart';
import '../../domain/entities/settings_entity.dart';
import '../constants/settings_strings.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_footer.dart';
import '../widgets/settings_header.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_switch_tile.dart';

class PrivacySettingsScreen extends ConsumerWidget {
  const PrivacySettingsScreen({super.key});

  void _update(
    BuildContext context,
    WidgetRef ref,
    PrivacyPreferences next,
  ) {
    ref.read(settingsControllerProvider.notifier).updatePrivacy(next);
    AppSnackBar.showSuccess(context, SettingsStrings.privacySaved);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SettingsState state = ref.watch(settingsControllerProvider);
    final PrivacyPreferences prefs = (state.settings ??
            SettingsEntity.defaults())
        .privacy;

    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: AppSizes.tabletMaxWidth.toDouble(),
      desktop: AppSizes.desktopMaxWidth.toDouble(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(SettingsStrings.privacyTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.goNamed(AppRoutes.settings),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                SettingsHeader(
                  icon: Icons.shield_outlined,
                  eyebrow: SettingsStrings.sectionData,
                  title: SettingsStrings.privacyTitle,
                  subtitle: SettingsStrings.privacySubtitle,
                ),
                const SizedBox(height: AppSpacing.sm),
                SettingsSection(
                  title: 'Data collection',
                  showDividers: true,
                  children: <Widget>[
                    SettingsSwitchTile(
                      title: SettingsStrings.privacyAnalytics,
                      subtitle: SettingsStrings.privacyAnalyticsSubtitle,
                      leading: _IconBubble(
                        icon: Icons.bar_chart_rounded,
                        color: AppColors.info,
                      ),
                      value: prefs.analyticsEnabled,
                      onChanged: (bool v) => _update(
                        context,
                        ref,
                        prefs.copyWith(analyticsEnabled: v),
                      ),
                    ),
                    SettingsSwitchTile(
                      title: SettingsStrings.privacyCrash,
                      subtitle: SettingsStrings.privacyCrashSubtitle,
                      leading: _IconBubble(
                        icon: Icons.bug_report_outlined,
                        color: AppColors.error,
                      ),
                      value: prefs.crashReportsEnabled,
                      onChanged: (bool v) => _update(
                        context,
                        ref,
                        prefs.copyWith(crashReportsEnabled: v),
                      ),
                    ),
                    SettingsSwitchTile(
                      title: SettingsStrings.privacyPersonalised,
                      subtitle: SettingsStrings.privacyPersonalisedSubtitle,
                      leading: _IconBubble(
                        icon: Icons.auto_awesome_outlined,
                        color: AppColors.accent,
                      ),
                      value: prefs.personalisedRecommendations,
                      onChanged: (bool v) => _update(
                        context,
                        ref,
                        prefs.copyWith(personalisedRecommendations: v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SettingsSection(
                  title: 'Social & AI',
                  showDividers: true,
                  children: <Widget>[
                    SettingsSwitchTile(
                      title: SettingsStrings.privacyLeaderboard,
                      subtitle: SettingsStrings.privacyLeaderboardSubtitle,
                      leading: _IconBubble(
                        icon: Icons.leaderboard_outlined,
                        color: AppColors.primary,
                      ),
                      value: prefs.shareProgressOnLeaderboard,
                      onChanged: (bool v) => _update(
                        context,
                        ref,
                        prefs.copyWith(shareProgressOnLeaderboard: v),
                      ),
                    ),
                    SettingsSwitchTile(
                      title: SettingsStrings.privacyAiMemory,
                      subtitle: SettingsStrings.privacyAiMemorySubtitle,
                      leading: _IconBubble(
                        icon: Icons.psychology_outlined,
                        color: AppColors.secondary,
                      ),
                      value: prefs.allowAitutorMemory,
                      onChanged: (bool v) => _update(
                        context,
                        ref,
                        prefs.copyWith(allowAitutorMemory: v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                const SettingsFooter(version: '1.0.0'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.iconLg,
      height: AppSizes.iconLg,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: color, size: AppSizes.iconMd),
    );
  }
}