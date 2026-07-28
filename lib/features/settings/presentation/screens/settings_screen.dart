import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
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
import '../widgets/settings_category_card.dart';
import '../widgets/settings_empty_state.dart';
import '../widgets/settings_error_state.dart';
import '../widgets/settings_loading_state.dart';
import '../widgets/settings_search_bar.dart';

/// Main Settings hub. Lays out the high-level categories as
/// glass-card sections; each row drills into a dedicated screen.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final SettingsState state = ref.read(settingsControllerProvider);
      if (state.status == SettingsStatus.initial) {
        ref.read(settingsControllerProvider.notifier).load();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() => _query = value.trim().toLowerCase());
  }

  void _onProfileChanged(SettingsState? previous, SettingsState next) {
    if (!mounted) return;
    if (next.errorMessage != null &&
        next.errorMessage != previous?.errorMessage) {
      AppSnackBar.showError(context, next.errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SettingsState>(
      settingsControllerProvider,
      _onProfileChanged,
    );
    final SettingsState state = ref.watch(settingsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(SettingsStrings.screenTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.goNamed(AppRoutes.profile),
        ),
      ),
      body: SafeArea(
        child: _buildBody(context, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SettingsState state) {
    if (state.status == SettingsStatus.initial ||
        (state.status == SettingsStatus.loading && state.settings == null)) {
      return const SettingsLoadingState();
    }
    if (state.status == SettingsStatus.error && state.settings == null) {
      return SettingsErrorState(
        title: SettingsStrings.loadError,
        message: state.errorMessage ?? SettingsStrings.loadError,
        onRetry: () =>
            ref.read(settingsControllerProvider.notifier).load(),
      );
    }
    final SettingsEntity settings =
        state.settings ?? SettingsEntity.defaults();
    return _SettingsBody(
      settings: settings,
      query: _query,
      searchController: _searchController,
      onSearchChanged: _onSearchChanged,
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody({
    required this.settings,
    required this.query,
    required this.searchController,
    required this.onSearchChanged,
  });

  final SettingsEntity settings;
  final String query;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final List<_SettingsCategory> all = _buildCategories(settings);
    final List<_SettingsCategory> filtered = _filter(all, query);

    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: _Header(summary: settings),
        ),
        SliverToBoxAdapter(
          child: SettingsSearchBar(
            controller: searchController,
            onChanged: onSearchChanged,
          ),
        ),
        if (filtered.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: SettingsEmptyState(
              title: SettingsStrings.noResultsTitle,
              subtitle: SettingsStrings.noResultsSubtitle,
              icon: Icons.search_off_rounded,
              actionLabel: SettingsStrings.resetSearchCta,
              onAction: () {
                searchController.clear();
                onSearchChanged('');
              },
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveBuilder.value<double>(
                context,
                mobile: AppSpacing.lg,
                tablet: AppSpacing.xl,
                desktop: AppSpacing.xxl,
              ),
            ),
            sliver: SliverList.builder(
              itemCount: filtered.length,
              itemBuilder: (BuildContext context, int index) {
                final _SettingsCategory category = filtered[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: SettingsCategoryCard(
                    title: category.title,
                    subtitle: category.subtitle,
                    icon: category.icon,
                    accentColor: category.accent,
                    trailingValue: category.valueLabel,
                    onTap: () => context.pushNamed(category.route),
                  ),
                );
              },
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxxl)),
      ],
    );
  }

  List<_SettingsCategory> _filter(
    List<_SettingsCategory> input,
    String query,
  ) {
    if (query.isEmpty) return input;
    return input
        .where((_SettingsCategory c) =>
            c.title.toLowerCase().contains(query) ||
            (c.subtitle?.toLowerCase().contains(query) ?? false))
        .toList(growable: false);
  }

  List<_SettingsCategory> _buildCategories(SettingsEntity settings) {
    return <_SettingsCategory>[
      _SettingsCategory(
        title: SettingsStrings.themeTitle,
        subtitle: SettingsStrings.themeSubtitle,
        icon: Icons.brightness_6_rounded,
        valueLabel: settings.themeMode.displayName,
        route: AppRoutes.settingsTheme,
        accent: AppColors.accent,
      ),
      _SettingsCategory(
        title: SettingsStrings.languageTitle,
        subtitle: SettingsStrings.languageSubtitle,
        icon: Icons.translate_rounded,
        valueLabel: settings.language.displayName,
        route: AppRoutes.settingsLanguage,
        accent: AppColors.info,
      ),
      _SettingsCategory(
        title: SettingsStrings.notificationsTitle,
        subtitle: SettingsStrings.notificationsSubtitle,
        icon: Icons.notifications_active_outlined,
        route: AppRoutes.settingsNotifications,
        accent: AppColors.primary,
      ),
      _SettingsCategory(
        title: SettingsStrings.privacyTitle,
        subtitle: SettingsStrings.privacySubtitle,
        icon: Icons.shield_outlined,
        route: AppRoutes.settingsPrivacy,
        accent: AppColors.secondary,
      ),
      _SettingsCategory(
        title: SettingsStrings.accessibilityTitle,
        subtitle: SettingsStrings.accessibilitySubtitle,
        icon: Icons.accessibility_new_rounded,
        route: AppRoutes.settingsAccessibility,
        accent: AppColors.success,
      ),
      _SettingsCategory(
        title: SettingsStrings.aboutTitle,
        subtitle: SettingsStrings.aboutSubtitle,
        icon: Icons.info_outline_rounded,
        route: AppRoutes.settingsAbout,
        accent: AppColors.accent,
      ),
      _SettingsCategory(
        title: 'Offline downloads',
        subtitle: 'Manage downloaded lessons, sync, and storage.',
        icon: Icons.cloud_off_rounded,
        route: AppRoutes.offlineDownloads,
        accent: AppColors.warning,
      ),
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.summary});

  final SettingsEntity summary;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: GlassCard(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: <Widget>[
            const CircleAvatar(
              radius: AppSizes.iconLg,
              backgroundColor: Color(0x331B3B6F),
              child: Icon(Icons.tune_rounded, size: AppSizes.iconLg),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Personalise your Prep Quest',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Tweak the look, language, notifications and privacy '
                    'controls to match how you study.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
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
}

class _SettingsCategory {
  const _SettingsCategory({
    required this.title,
    required this.icon,
    required this.route,
    this.subtitle,
    this.valueLabel,
    this.accent,
  });

  final String title;
  final String? subtitle;
  final String? valueLabel;
  final IconData icon;
  final String route;
  final Color? accent;
}