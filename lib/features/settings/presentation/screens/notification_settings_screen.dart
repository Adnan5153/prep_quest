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

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  void _update(
    BuildContext context,
    WidgetRef ref,
    NotificationPreferences next,
  ) {
    ref.read(settingsControllerProvider.notifier).updateNotifications(next);
    AppSnackBar.showSuccess(context, SettingsStrings.notificationsSaved);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SettingsState state = ref.watch(settingsControllerProvider);
    final NotificationPreferences prefs = (state.settings ??
            SettingsEntity.defaults())
        .notifications;

    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: AppSizes.tabletMaxWidth.toDouble(),
      desktop: AppSizes.desktopMaxWidth.toDouble(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(SettingsStrings.notificationsTitle),
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
                  icon: Icons.notifications_active_outlined,
                  eyebrow: SettingsStrings.sectionPreferences,
                  title: SettingsStrings.notificationsTitle,
                  subtitle: SettingsStrings.notificationsSubtitle,
                ),
                const SizedBox(height: AppSpacing.sm),
                SettingsSection(
                  title: 'General',
                  showDividers: true,
                  children: <Widget>[
                    SettingsSwitchTile(
                      title: SettingsStrings.notifPush,
                      subtitle: SettingsStrings.notifPushSubtitle,
                      leading: _IconBubble(
                        icon: Icons.notifications_active_outlined,
                        color: AppColors.primary,
                      ),
                      value: prefs.pushEnabled,
                      onChanged: (bool v) => _update(
                        context,
                        ref,
                        prefs.copyWith(pushEnabled: v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SettingsSection(
                  title: 'Channels',
                  showDividers: true,
                  children: <Widget>[
                    SettingsSwitchTile(
                      title: SettingsStrings.notifStreak,
                      subtitle: SettingsStrings.notifStreakSubtitle,
                      leading: _IconBubble(
                        icon: Icons.local_fire_department_outlined,
                        color: AppColors.accent,
                      ),
                      value: prefs.streakReminders && prefs.pushEnabled,
                      enabled: prefs.pushEnabled,
                      onChanged: (bool v) => _update(
                        context,
                        ref,
                        prefs.copyWith(streakReminders: v),
                      ),
                    ),
                    SettingsSwitchTile(
                      title: SettingsStrings.notifDailyQuiz,
                      subtitle: SettingsStrings.notifDailyQuizSubtitle,
                      leading: _IconBubble(
                        icon: Icons.quiz_outlined,
                        color: AppColors.info,
                      ),
                      value: prefs.dailyQuizReminder && prefs.pushEnabled,
                      enabled: prefs.pushEnabled,
                      onChanged: (bool v) => _update(
                        context,
                        ref,
                        prefs.copyWith(dailyQuizReminder: v),
                      ),
                    ),
                    SettingsSwitchTile(
                      title: SettingsStrings.notifWeekly,
                      subtitle: SettingsStrings.notifWeeklySubtitle,
                      leading: _IconBubble(
                        icon: Icons.calendar_view_week_rounded,
                        color: AppColors.secondary,
                      ),
                      value: prefs.weeklyDigest && prefs.pushEnabled,
                      enabled: prefs.pushEnabled,
                      onChanged: (bool v) => _update(
                        context,
                        ref,
                        prefs.copyWith(weeklyDigest: v),
                      ),
                    ),
                    SettingsSwitchTile(
                      title: SettingsStrings.notifAchievement,
                      subtitle: SettingsStrings.notifAchievementSubtitle,
                      leading: _IconBubble(
                        icon: Icons.emoji_events_outlined,
                        color: AppColors.accent,
                      ),
                      value: prefs.achievementAlerts && prefs.pushEnabled,
                      enabled: prefs.pushEnabled,
                      onChanged: (bool v) => _update(
                        context,
                        ref,
                        prefs.copyWith(achievementAlerts: v),
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