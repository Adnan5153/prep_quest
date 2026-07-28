import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import '../widgets/settings_slider_tile.dart';
import '../widgets/settings_switch_tile.dart';

class AccessibilitySettingsScreen extends ConsumerWidget {
  const AccessibilitySettingsScreen({super.key});

  void _update(
    BuildContext context,
    WidgetRef ref,
    AccessibilityPreferences next,
  ) {
    ref.read(settingsControllerProvider.notifier).updateAccessibility(next);
    AppSnackBar.showSuccess(context, SettingsStrings.accessibilitySaved);
  }

  String _formatScale(double v) {
    final int pct = (v * 100).round();
    return '$pct%';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SettingsState state = ref.watch(settingsControllerProvider);
    final AccessibilityPreferences prefs = (state.settings ??
            SettingsEntity.defaults())
        .accessibility;

    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: AppSizes.tabletMaxWidth.toDouble(),
      desktop: AppSizes.desktopMaxWidth.toDouble(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(SettingsStrings.accessibilityTitle),
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
                  icon: Icons.accessibility_new_rounded,
                  eyebrow: SettingsStrings.sectionPreferences,
                  title: SettingsStrings.accessibilityTitle,
                  subtitle: SettingsStrings.accessibilitySubtitle,
                ),
                const SizedBox(height: AppSpacing.sm),
                SettingsSection(
                  title: 'Display',
                  children: <Widget>[
                    SettingsSliderTile(
                      title: SettingsStrings.accessibilityTextScale,
                      subtitle: SettingsStrings.accessibilityTextScaleSubtitle,
                      leadingIcon: Icons.text_fields_rounded,
                      min: 0.8,
                      max: 1.3,
                      divisions: 10,
                      value: prefs.textScale,
                      onChanged: (double v) => _update(
                        context,
                        ref,
                        prefs.copyWith(textScale: v),
                      ),
                      valueLabel: _formatScale(prefs.textScale),
                      semanticFormatter: _formatScale,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Divider(
                      height: 1,
                      indent: AppSpacing.lg,
                      endIndent: AppSpacing.lg,
                      color: Theme.of(context)
                          .dividerColor
                          .withValues(alpha: 0.4),
                    ),
                    SettingsSwitchTile(
                      title: SettingsStrings.accessibilityHighContrast,
                      subtitle:
                          SettingsStrings.accessibilityHighContrastSubtitle,
                      leading: const Icon(Icons.contrast_rounded),
                      value: prefs.highContrast,
                      onChanged: (bool v) => _update(
                        context,
                        ref,
                        prefs.copyWith(highContrast: v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SettingsSection(
                  title: 'Motion & feedback',
                  showDividers: true,
                  children: <Widget>[
                    SettingsSwitchTile(
                      title: SettingsStrings.accessibilityReduceMotion,
                      subtitle:
                          SettingsStrings.accessibilityReduceMotionSubtitle,
                      leading: const Icon(Icons.motion_photos_off_outlined),
                      value: prefs.reduceMotion,
                      onChanged: (bool v) => _update(
                        context,
                        ref,
                        prefs.copyWith(reduceMotion: v),
                      ),
                    ),
                    SettingsSwitchTile(
                      title: SettingsStrings.accessibilityHaptics,
                      subtitle:
                          SettingsStrings.accessibilityHapticsSubtitle,
                      leading: const Icon(Icons.vibration_rounded),
                      value: prefs.hapticsEnabled,
                      onChanged: (bool v) => _update(
                        context,
                        ref,
                        prefs.copyWith(hapticsEnabled: v),
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