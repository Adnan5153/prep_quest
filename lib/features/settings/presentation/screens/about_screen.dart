import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../router.dart';
import '../constants/settings_strings.dart';
import '../widgets/settings_footer.dart';
import '../widgets/settings_header.dart';
import '../widgets/settings_navigation_tile.dart';
import '../widgets/settings_section.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  static const String _appVersion = '1.0.0';
  static const String _buildNumber = '100';
  static const String _packageName = 'com.prepquest.app';

  void _copyVersion(BuildContext context) {
    AppSnackBar.showSuccess(
      context,
      '${SettingsStrings.aboutCopyVersion}: $_appVersion ($_buildNumber)',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: AppSizes.tabletMaxWidth.toDouble(),
      desktop: AppSizes.desktopMaxWidth.toDouble(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(SettingsStrings.aboutTitle),
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
                  icon: Icons.info_outline_rounded,
                  eyebrow: SettingsStrings.sectionAbout,
                  title: SettingsStrings.aboutTitle,
                  subtitle: SettingsStrings.aboutSubtitle,
                ),
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: GlassCard(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: <Widget>[
                        const CircleAvatar(
                          radius: AppSizes.iconLg,
                          child: Icon(Icons.school_rounded,
                              size: AppSizes.iconLg),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Prep Quest',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          'Your smart BCS prep companion.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.sm,
                          children: <Widget>[
                            PrimaryButton(
                              text: 'Share',
                              icon: Icons.share_rounded,
                              onPressed: () => AppSnackBar.showInfo(
                                context,
                                '${SettingsStrings.aboutShare} — '
                                    '$_packageName',
                              ),
                            ),
                            SecondaryButton(
                              text: 'Copy version',
                              icon: Icons.copy_rounded,
                              onPressed: () => _copyVersion(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SettingsSection(
                  title: 'Details',
                  showDividers: true,
                  children: <Widget>[
                    SettingsNavigationTile(
                      title: SettingsStrings.aboutVersion,
                      valueLabel: _appVersion,
                      leadingIcon: Icons.numbers_rounded,
                      onTap: () => _copyVersion(context),
                    ),
                    SettingsNavigationTile(
                      title: SettingsStrings.aboutBuild,
                      valueLabel: _buildNumber,
                      leadingIcon: Icons.build_circle_outlined,
                      onTap: () => _copyVersion(context),
                    ),
                    SettingsNavigationTile(
                      title: SettingsStrings.aboutMaintainer,
                      valueLabel: SettingsStrings.aboutMaintainerName,
                      leadingIcon: Icons.handshake_outlined,
                      onTap: () => AppSnackBar.showInfo(
                        context,
                        SettingsStrings.aboutMaintainerName,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SettingsSection(
                  title: 'Support & community',
                  showDividers: true,
                  children: <Widget>[
                    SettingsNavigationTile(
                      title: SettingsStrings.aboutContactSupport,
                      subtitle:
                          SettingsStrings.aboutContactSupportSubtitle,
                      leadingIcon: Icons.support_agent_rounded,
                      onTap: () => AppSnackBar.showInfo(
                        context,
                        'support@prepquest.app',
                      ),
                    ),
                    SettingsNavigationTile(
                      title: SettingsStrings.aboutRate,
                      subtitle: SettingsStrings.aboutRateSubtitle,
                      leadingIcon: Icons.star_rate_rounded,
                      onTap: () => AppSnackBar.showInfo(
                        context,
                        'Open the Play Store listing to rate Prep Quest.',
                      ),
                    ),
                    SettingsNavigationTile(
                      title: SettingsStrings.aboutShare,
                      subtitle: SettingsStrings.aboutShareSubtitle,
                      leadingIcon: Icons.share_rounded,
                      onTap: () => AppSnackBar.showInfo(
                        context,
                        '${SettingsStrings.aboutShare} — '
                            '$_packageName',
                      ),
                    ),
                    SettingsNavigationTile(
                      title: SettingsStrings.aboutAcknowledgements,
                      subtitle:
                          SettingsStrings.aboutAcknowledgementsSubtitle,
                      leadingIcon: Icons.balance_rounded,
                      onTap: () => AppSnackBar.showInfo(
                        context,
                        'Open-source licenses will be listed here soon.',
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