import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/admin_strings.dart';
import '../../../../core/theme/admin_palette.dart';
import '../../../../core/theme/admin_radius.dart';
import '../../../../core/theme/admin_spacing.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../providers/assets_provider.dart';

class AssetsScreen extends ConsumerWidget {
  const AssetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AssetKind? filter = ref.watch(assetKindFilterProvider);
    final String query = ref.watch(assetSearchQueryProvider);
    final AsyncValue<List<AssetSummary>> asyncAssets =
        ref.watch(assetsListProvider(filter));

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
                    Text('Assets', style: theme.textTheme.displayMedium),
                    const SizedBox(height: AdminSpacing.xs),
                    Text(
                      'Media library: images, Lottie, audio, video, fonts, custom. Versioned, deduplicated, CDN-backed.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () => _showUploadDialog(context, ref),
                icon: const Icon(Icons.upload_outlined, size: 16),
                label: const Text('Upload asset'),
              ),
            ],
          ),
          const SizedBox(height: AdminSpacing.xl),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: AdminStrings.placeholderSearchAssets,
                    prefixIcon: Icon(Icons.search, size: 16),
                  ),
                  onChanged: (String v) =>
                      ref.read(assetSearchQueryProvider.notifier).state = v,
                ),
              ),
              const SizedBox(width: AdminSpacing.md),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    _FilterChip(
                      label: 'All',
                      selected: filter == null,
                      onTap: () =>
                          ref.read(assetKindFilterProvider.notifier).state = null,
                    ),
                    for (final AssetKind k in AssetKind.values)
                      _FilterChip(
                        label: k.wire,
                        selected: filter == k,
                        onTap: () => ref
                            .read(assetKindFilterProvider.notifier)
                            .state = k,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AdminSpacing.lg),
          Expanded(
            child: asyncAssets.when(
              data: (List<AssetSummary> list) {
                final List<AssetSummary> filtered = query.isEmpty
                    ? list
                    : list
                        .where((AssetSummary a) =>
                            a.displayName
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                        .toList();
                if (filtered.isEmpty) {
                  return const Center(child: Text('No assets match.'));
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: AdminSpacing.md,
                    mainAxisSpacing: AdminSpacing.md,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (BuildContext context, int index) {
                    final AssetSummary a = filtered[index];
                    return _AssetCard(asset: a);
                  },
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

  void _showUploadDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (BuildContext c) {
        return AlertDialog(
          title: const Text('Upload asset'),
          content: const SizedBox(
            width: 380,
            child: Text(
              'Asset upload is mocked in this build. In production, this would call the CDN backend and emit a new AssetVersion record.',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(c).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AdminRadius.pill),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: AdminSpacing.sm, vertical: 4),
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primary.withValues(alpha: 0.12)
                : Colors.transparent,
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(AdminRadius.pill),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: selected ? theme.colorScheme.primary : null),
          ),
        ),
      ),
    );
  }
}

class _AssetCard extends StatelessWidget {
  const _AssetCard({required this.asset});

  final AssetSummary asset;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AdminSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AdminRadius.lg),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AdminPalette.ivory,
                borderRadius: BorderRadius.circular(AdminRadius.md),
              ),
              child: Center(
                child: Icon(_iconFor(asset.kind),
                    size: 36, color: AdminPalette.slate),
              ),
            ),
          ),
          const SizedBox(height: AdminSpacing.sm),
          Text(asset.displayName, style: theme.textTheme.titleSmall),
          Text(
            '${asset.kind.wire} · ${asset.width ?? '—'}×${asset.height ?? '—'}',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  IconData _iconFor(AssetKind kind) {
    switch (kind) {
      case AssetKind.image:
        return Icons.image_outlined;
      case AssetKind.lottie:
        return Icons.animation_outlined;
      case AssetKind.audio:
        return Icons.audiotrack_outlined;
      case AssetKind.video:
        return Icons.video_library_outlined;
      case AssetKind.font:
        return Icons.text_fields_outlined;
      case AssetKind.shader:
        return Icons.blur_on_outlined;
      case AssetKind.custom:
        return Icons.category_outlined;
    }
  }
}
