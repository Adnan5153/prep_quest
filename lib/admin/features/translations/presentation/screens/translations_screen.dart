import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/admin_palette.dart';
import '../../../../core/theme/admin_radius.dart';
import '../../../../core/theme/admin_spacing.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../../domain/entities/translation_entity.dart';
import '../providers/translations_provider.dart';

class TranslationsScreen extends ConsumerWidget {
  const TranslationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final LocaleTag active = ref.watch(activeLocaleProvider);
    final AsyncValue<TranslationCoverage> coverage =
        ref.watch(translationsCoverageProvider);
    final AsyncValue<List<TranslationEntry>> entries =
        ref.watch(translationsListProvider(active));
    final TextEditingController searchCtrl = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(AdminSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Translations', style: theme.textTheme.displayMedium),
                    const SizedBox(height: AdminSpacing.xs),
                    Text(
                      'Localization coverage. Strings drive UI copy, level prompts, and reward tooltips.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              coverage.maybeWhen(
                data: (TranslationCoverage c) => _CoveragePill(coverage: c),
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: AdminSpacing.lg),
          Row(
            children: <Widget>[
              ToggleButtons(
                isSelected: <bool>[
                  active == LocaleTag.english,
                  active == LocaleTag.bangla
                ],
                onPressed: (int idx) {
                  ref.read(activeLocaleProvider.notifier).state =
                      idx == 0 ? LocaleTag.english : LocaleTag.bangla;
                },
                borderRadius: BorderRadius.circular(AdminRadius.pill),
                constraints: const BoxConstraints(minWidth: 90, minHeight: 36),
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('English'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('বাংলা'),
                  ),
                ],
              ),
              const SizedBox(width: AdminSpacing.md),
              Expanded(
                child: TextField(
                  controller: searchCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Search keys or values',
                    prefixIcon: Icon(Icons.search, size: 16),
                  ),
                  onChanged: (_) {},
                ),
              ),
              const SizedBox(width: AdminSpacing.md),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_outlined, size: 16),
                label: const Text('Export JSON'),
              ),
              const SizedBox(width: AdminSpacing.sm),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add entry'),
              ),
            ],
          ),
          const SizedBox(height: AdminSpacing.lg),
          Expanded(
            child: entries.when(
              data: (List<TranslationEntry> list) {
                final String q = searchCtrl.text.toLowerCase();
                final List<TranslationEntry> filtered = q.isEmpty
                    ? list
                    : list
                        .where((TranslationEntry e) =>
                            e.key.toLowerCase().contains(q) ||
                            e.value.toLowerCase().contains(q))
                        .toList();
                return Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AdminRadius.lg),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(AdminSpacing.md),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text('Key', style: theme.textTheme.labelSmall),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text('Value',
                                  style: theme.textTheme.labelSmall),
                            ),
                            SizedBox(
                              width: 80,
                              child: Text('Updated',
                                  style: theme.textTheme.labelSmall),
                            ),
                            SizedBox(width: 40, child: Text('')),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (BuildContext _, int _) =>
                              const Divider(height: 1),
                          itemBuilder: (BuildContext c, int i) => _Row(
                            entry: filtered[i],
                            locale: active,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object e, _) => Center(child: Text('Failed: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoveragePill extends StatelessWidget {
  const _CoveragePill({required this.coverage});

  final TranslationCoverage coverage;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String pct = coverage.total == 0
        ? '0%'
        : ((coverage.byLocale.values.fold<int>(0, (int s, int v) => s + v) /
                    (coverage.total * 2)) *
                100)
            .toStringAsFixed(0);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AdminSpacing.md, vertical: AdminSpacing.sm),
      decoration: BoxDecoration(
        color: AdminPalette.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AdminRadius.pill),
        border: Border.all(color: AdminPalette.success.withValues(alpha: 0.4)),
      ),
      child: Text(
        'Coverage: $pct% (${coverage.total} keys)',
        style: theme.textTheme.labelMedium
            ?.copyWith(color: AdminPalette.success),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.entry, required this.locale});

  final TranslationEntry entry;
  final LocaleTag locale;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AdminSpacing.md, vertical: AdminSpacing.sm),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              entry.key,
              style: theme.textTheme.bodySmall
                  ?.copyWith(fontFamily: 'monospace'),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              entry.value,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              DateFormat('MMM d').format(DateTime.now()),
              style: theme.textTheme.bodySmall,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, size: 16),
          ),
        ],
      ),
    );
  }
}
