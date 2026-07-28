import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../router.dart';
import '../../domain/entities/settings_entity.dart';
import '../constants/settings_strings.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_footer.dart';
import '../widgets/settings_header.dart';
import '../widgets/settings_radio_tile.dart';
import '../widgets/settings_section.dart';

/// Lets the user pick between System / Light / Dark.
class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  void _onChanged(
    BuildContext context,
    WidgetRef ref,
    AppThemeMode mode,
  ) {
    ref.read(settingsControllerProvider.notifier).updateTheme(mode);
    AppSnackBar.showSuccess(
      context,
      '${SettingsStrings.themeUpdated}: ${mode.displayName}',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SettingsState state = ref.watch(settingsControllerProvider);
    final SettingsEntity settings =
        state.settings ?? SettingsEntity.defaults();

    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: AppSizes.tabletMaxWidth.toDouble(),
      desktop: AppSizes.desktopMaxWidth.toDouble(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(SettingsStrings.themeTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.canPop() ? context.pop() : context.goNamed(AppRoutes.settings),
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
                  icon: Icons.brightness_6_rounded,
                  eyebrow: SettingsStrings.sectionAppearance,
                  title: SettingsStrings.themeTitle,
                  subtitle: SettingsStrings.themeSubtitle,
                ),
                const SizedBox(height: AppSpacing.sm),
                _PreviewRow(themeMode: settings.themeMode),
                const SizedBox(height: AppSpacing.sm),
                SettingsSection(
                  title: 'Choose a theme',
                  showDividers: true,
                  children: <Widget>[
                    SettingsRadioTile<AppThemeMode>(
                      title: SettingsStrings.themeSystem,
                      subtitle:
                          'Match the OS appearance automatically.',
                      value: AppThemeMode.system,
                      groupValue: settings.themeMode,
                      leadingIcon: Icons.brightness_auto_rounded,
                      onChanged: (AppThemeMode? v) {
                        if (v != null) _onChanged(context, ref, v);
                      },
                    ),
                    SettingsRadioTile<AppThemeMode>(
                      title: SettingsStrings.themeLight,
                      subtitle:
                          'Bright surfaces — easier on sunny days.',
                      value: AppThemeMode.light,
                      groupValue: settings.themeMode,
                      leadingIcon: Icons.light_mode_outlined,
                      onChanged: (AppThemeMode? v) {
                        if (v != null) _onChanged(context, ref, v);
                      },
                    ),
                    SettingsRadioTile<AppThemeMode>(
                      title: SettingsStrings.themeDark,
                      subtitle:
                          'Lower brightness for late-night study sessions.',
                      value: AppThemeMode.dark,
                      groupValue: settings.themeMode,
                      leadingIcon: Icons.dark_mode_outlined,
                      onChanged: (AppThemeMode? v) {
                        if (v != null) _onChanged(context, ref, v);
                      },
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

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.themeMode});

  final AppThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: GlassCard(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: <Widget>[
            Container(
              width: AppSizes.iconXl,
              height: AppSizes.iconXl,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              alignment: Alignment.center,
              child: Icon(
                _iconFor(themeMode),
                size: AppSizes.iconLg,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Current selection',
                    style: theme.textTheme.labelMedium?.copyWith(
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    themeMode.displayName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return Icons.brightness_auto_rounded;
      case AppThemeMode.light:
        return Icons.light_mode_outlined;
      case AppThemeMode.dark:
        return Icons.dark_mode_outlined;
    }
  }
}