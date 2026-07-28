import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/admin_palette.dart';
import '../../../../core/theme/admin_radius.dart';
import '../../../../core/theme/admin_spacing.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../../../../shared/routing/admin_routes.dart';
import '../providers/themes_provider.dart';

class ThemesScreen extends ConsumerWidget {
  const ThemesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<List<ThemeSummary>> themes = ref.watch(themesListProvider);

    return Padding(
      padding: const EdgeInsets.all(AdminSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Themes', style: theme.textTheme.displayMedium),
          const SizedBox(height: AdminSpacing.sm),
          Text(
            'Seasonal palettes, weather, and atmosphere overrides. Themes swap on the client without an app release.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AdminSpacing.xl),
          Expanded(
            child: themes.when(
              data: (List<ThemeSummary> list) => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: AdminSpacing.lg,
                  mainAxisSpacing: AdminSpacing.lg,
                  childAspectRatio: 1.4,
                ),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  final ThemeSummary t = list[index];
                  return InkWell(
                    onTap: () => context.go(AdminRoutes.themeEditorPath(t.id)),
                    child: _ThemeCard(summary: t),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object e, _) => Center(child: Text('Failed: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({required this.summary});

  final ThemeSummary summary;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color sky = _skyFor(summary.id);
    final Color ground = _groundFor(summary.id);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AdminRadius.lg),
        border: Border.all(color: theme.colorScheme.outline),
        color: theme.colorScheme.surface,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[sky, ground],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Icon(_iconFor(summary.weather), size: 36, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AdminSpacing.md),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(summary.displayName,
                          style: theme.textTheme.titleSmall),
                      Text(summary.weather.wire,
                          style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                _StatusDot(status: summary.status),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _skyFor(String id) {
    switch (id) {
      case 'thm_winter':
        return const Color(0xFFBFD7E8);
      case 'thm_monsoon':
        return const Color(0xFF7DA0A8);
      case 'thm_night':
        return const Color(0xFF0B1335);
      case 'thm_ramadan':
        return const Color(0xFF1B0E36);
      case 'thm_eid':
        return const Color(0xFFFFE0B2);
      default:
        return const Color(0xFFA6D8FF);
    }
  }

  Color _groundFor(String id) {
    switch (id) {
      case 'thm_winter':
        return const Color(0xFFF5FBFF);
      case 'thm_monsoon':
        return const Color(0xFF3F7E47);
      case 'thm_night':
        return const Color(0xFF1B2E4B);
      case 'thm_ramadan':
        return const Color(0xFF311B92);
      case 'thm_eid':
        return const Color(0xFF66BB6A);
      default:
        return const Color(0xFFE4F4FF);
    }
  }

  IconData _iconFor(ThemeWeather w) {
    switch (w) {
      case ThemeWeather.sunny:
        return Icons.wb_sunny_outlined;
      case ThemeWeather.cloudy:
        return Icons.cloud_outlined;
      case ThemeWeather.rainy:
        return Icons.umbrella_outlined;
      case ThemeWeather.snowy:
        return Icons.ac_unit_outlined;
      case ThemeWeather.foggy:
        return Icons.blur_on_outlined;
      case ThemeWeather.windy:
        return Icons.air_outlined;
      case ThemeWeather.stormy:
        return Icons.flash_on_outlined;
    }
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});

  final WorkflowState status;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (status) {
      WorkflowState.draft => AdminPalette.statusDraft,
      WorkflowState.inReview => AdminPalette.statusInReview,
      WorkflowState.testing => AdminPalette.statusTesting,
      WorkflowState.published => AdminPalette.statusPublished,
      WorkflowState.archived => AdminPalette.statusArchived,
    };
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
