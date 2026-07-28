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

/// Lets the user pick between English and বাংলা.
class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  void _onChanged(
    BuildContext context,
    WidgetRef ref,
    AppLanguage language,
  ) {
    ref.read(settingsControllerProvider.notifier).updateLanguage(language);
    AppSnackBar.showSuccess(
      context,
      '${SettingsStrings.languageUpdated}: ${language.displayName}',
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
        title: const Text(SettingsStrings.languageTitle),
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
                  icon: Icons.translate_rounded,
                  eyebrow: SettingsStrings.sectionPreferences,
                  title: SettingsStrings.languageTitle,
                  subtitle: SettingsStrings.languageSubtitle,
                ),
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: GlassCard(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.language_rounded, size: 32),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            'Current: ${settings.language.displayName}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SettingsSection(
                  title: 'Available languages',
                  showDividers: true,
                  children: <Widget>[
                    SettingsRadioTile<AppLanguage>(
                      title: SettingsStrings.languageEnglish,
                      subtitle: 'BCS prep in English.',
                      value: AppLanguage.english,
                      groupValue: settings.language,
                      leadingIcon: Icons.translate_rounded,
                      onChanged: (AppLanguage? v) {
                        if (v != null) _onChanged(context, ref, v);
                      },
                    ),
                    SettingsRadioTile<AppLanguage>(
                      title: SettingsStrings.languageBengali,
                      subtitle: 'বাংলা ভাষায় প্রস্তুতি নিন।',
                      value: AppLanguage.bengali,
                      groupValue: settings.language,
                      leadingIcon: Icons.translate_rounded,
                      onChanged: (AppLanguage? v) {
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